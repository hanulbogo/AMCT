function [Salpix, Sal]= AbsorptionTime_CNN(EdgSup,SaliencyParams)


Img =SaliencyParams.Img;
Label=SaliencyParams.Label;
LabelLine =SaliencyParams.LabelLine;
k =SaliencyParams.num_region;
ConPixDouble =SaliencyParams.ConPixDouble;
SupCol =SaliencyParams.SupCol;


ConPixDouble(EdgSup==1, EdgSup==1)=1;
[rows, cols]= find(ConPixDouble>0);
DPos= [rows,cols];
 
DPosAll=mat2cell(repmat(DPos, [SaliencyParams.Ncol,1]),repmat(length(DPos),[SaliencyParams.Ncol,1]),2);
DcolAll=cellfun(@colordist,SupCol, DPosAll,'UniformOutput',0);
DcolNorAll =cellfun(@normalize2, DcolAll,'UniformOutput',0);
DcolNorAll =cell2mat(DcolNorAll);
DcolNorAll =reshape(DcolNorAll,[length(DPos), SaliencyParams.Ncol]);

DcolNor= max( DcolNorAll,[],2);
weight = exp( -20*DcolNor) + .00001;

WconFirst=zeros(k,k);
for mm=1:length(DPos)
    j=DPos(mm,1);
    z=DPos(mm,2);
    WconFirst(j,z)= weight(mm);
end
WconFirst(eye(k)==1)=1;

[ height,width ] = size(Label(:,:,1));
PixNum = numel(Label);
 labels= 1:k;
    prolabels =labels(EdgSup'==0);
    fixedBG= zeros(size(Img,1),size(Img,2));
    for l=1: size(prolabels,2)
        fixedBG((Label==prolabels(l)-1))=1;
    end
Discard = sum(WconFirst,2);

NumIn = k - length( find( EdgSup == 2 ) );
%Edge에 들어있는애도 안에있는걸로 치고 duplicate해서 absorbing만드니까 In개수는 k-discardlength
NumEdg = length( find( EdgSup==1 ) );
%복사한애들갯수
EdgWcon = zeros( k, NumEdg );
%absorbing과 나머지애들의 connection
%복사한 원본의 connection을 따른다.
%우리는 이부분을 고쳐줘야됨.
mm=1;
for j=1:k
    if EdgSup(j)==1
        EdgWcon(:,mm) = WconFirst(:,j);
        mm = mm + 1;
    end
end
alph = 1;  W=zeros(k,k);
% salth =255;
global maxsal;
%%%%%%%%%%%% absorb MC
if NumIn == k
    BaseEdg = sum( EdgWcon, 2 )*5; %얼마나 neighbor인 boundary sup와 닮아있는가
    D = diag( Discard + BaseEdg );%Discard는 얼마나 neighbor와 닮았는가
    Wcon =  D \ WconFirst;
    I = eye( NumIn );
    N = ( I - alph* Wcon  ); %현재의 Wcon은 transient state의 transient matrix

    Sal = N \ (EdgSup==0);%N\y;
    Sal = normalize(Sal);
    
    if max(Sal)~=1
        Sal = ones(size(Sal));
    end
else
    BaseEdg = zeros( NumIn, 1 );
    sumD = zeros( NumIn, 1 );
    mm=1;
    for j = 1:k
        if EdgSup(j) < 2
            BaseEdg(mm) = sum( EdgWcon( j, : ) );
            sumD(mm) = Discard(j);
            W(mm,:) = WconFirst(j,:);
            mm = mm + 1;
        end
    end
    mm=1;
    for j=1:k
        if EdgSup(j) < 2
            W( :,mm)=W(:,j);
            mm=mm+1;
        end
    end
    Wmid = W( 1:NumIn, 1: NumIn );
    D = diag( BaseEdg + sumD );
    Wmid = D \ Wmid;
    I = eye( NumIn );
    N = ( I - alph* Wmid  );
    y = ones( NumIn, 1 );
    Sal = N \ y;

%     Sal(Sal>salth)=salth;
    Sal = normalize(Sal);
    if max(Sal)~=1
        Sal = ones(size(Sal));
    end
end
 %%%%%%%%%%%  entropy decide 2
    Entro = zeros( 11, 1 );
    for j = 1 : NumIn
        entroT =  floor( Sal(j) * 10 ) + 1;
        Entro( entroT ) = Entro( entroT ) + 1;
    end
    Entro(10) = Entro(10) + Entro(11);
    Entro = Entro ./ NumIn;
    Entropy = 0;
    for  j = 1 : 10
        Entropy = Entropy + Entro(j) * min( ( j ), ( 11 - j ) );
    end
    % output the saliency map directly from absorb MC
    if   Entropy < 2
        if NumIn < k
            SalAll = zeros(k,1);
            mm=1;
            for j= 1: k
                if EdgSup (j ) < 2
                    SalAll(j) = Sal( mm );
                    mm=mm+1;
                end
            end
            for j=1:LenDiscardPos
                if EdgSup(DiscardPos(j))==0
                    SalAll( DiscardPos(j) ) = 1 ;
                else
                    SalAll( DiscardPos(j) ) = 0 ;
                end
            end
            
            
            SalLine = sup2pixel( PixNum, LabelLine, SalAll );  % to convey the saliency value from superpixel to pixel
            Salpix = reshape( SalLine, width, height );
            Salpix = Salpix';
            Sal= SalAll;
        else
            SalLine = sup2pixel( PixNum, LabelLine, Sal );
            Salpix = reshape( SalLine, width, height );
            Salpix = Salpix';
        end

    else
        %%%%%%%%%%%% equilibrium post-process
        if NumIn == k
            sumDiscard = sum( Discard );
            c = Discard ./ sumDiscard;
            rW = 1 ./ c;
            sumrW = sum(rW);
            rW = rW / sumrW;
            Sal = N \ rW;
            Sal = normalize(Sal);
        else
            sumsumD = sum( sumD );
            c = sumD ./ sumsumD;
            rW = 1 ./ c;
            sumrW = sum(rW);
            rW = rW / sumrW;
            Sal = N \ rW;
            Sal = normalize(Sal);
        end
        if NumIn < k
            SalAll = zeros(k,1);
            mm=1;
            for j= 1: k
                if EdgSup (j ) < 2
                    SalAll(j) = Sal( mm );
                    mm=mm+1;
                end
            end
            for j = 1:LenDiscardPos        % to descide the saliency of outlier based on neighbour's saliency
                            if EdgSup(DiscardPos(j))==0
                                SalAll( DiscardPos(j) ) = 1 ;
                            else
                                SalAll( DiscardPos(j) ) = 0 ;
                            end
            end
            
            SalLine = sup2pixel( PixNum, LabelLine, SalAll );
            Salpix = reshape( SalLine, width, height );
            Salpix = Salpix';
            Sal= SalAll;
        else
            SalLine = sup2pixel( PixNum, LabelLine, Sal );
            Salpix = reshape( SalLine, width, height );
            Salpix = Salpix';
        end

    end

    figure(4);
    subplot(3,1,1);
    imshow(uint8(Img));
    subplot(3,1,2);
    imshow(fixedBG);
    title('Candidate Region');
    subplot(3,1,3);
    imshow(Salpix,[]);
    title('Final Color Saliency');
    
end



