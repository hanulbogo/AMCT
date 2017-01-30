function [Salpix, Sal]= AbsorptionTime_Hops(EdgSup,SaliencyParams)


Img =SaliencyParams.Img;
Label=SaliencyParams.Label;
LabelLine =SaliencyParams.LabelLine;
k =SaliencyParams.num_region;
ConPixDouble =SaliencyParams.ConPixDouble;
SupCol =SaliencyParams.SupCol;


ConPixDouble(EdgSup==1, EdgSup==1)=1;

% DrawSimilarityOneFrame(Img, ConPixDouble, Label);


[rows, cols]= find(ConPixDouble>0);
DPos= [rows,cols];

DPosAll=mat2cell(repmat(DPos, [SaliencyParams.Ncol,1]),repmat(length(DPos),[SaliencyParams.Ncol,1]),2);
DcolAll=cellfun(@colordist,SupCol, DPosAll,'UniformOutput',0);
DcolNorAll =cellfun(@normalize2, DcolAll,'UniformOutput',0);
DcolNorAll =cell2mat(DcolNorAll);
DcolNorAll =reshape(DcolNorAll,[length(DPos), SaliencyParams.Ncol]);

% DcolNor= max( DcolNorAll,[],2);
DcolNor=  DcolNorAll(:,1);%,[],2);
weight = exp( -20*DcolNor) + .00001;

WconFirst=zeros(k,k);
for mm=1:length(DPos)
    j=DPos(mm,1);
    z=DPos(mm,2);
    WconFirst(j,z)= weight(mm);
end
WconFirst(eye(k)==1)=1;
% WconFirst = sparse( [Dcol(:,1);Dcol(:,2)], [Dcol(:,2);Dcol(:,1)], [weight,weight],k ,k );
% WconFirst = full(WconFirst )  + eye(k);   % the affinity matrix of the graph model

%




[ height,width ] = size(Label(:,:,1));
PixNum = numel(Label);
labels= 1:k;
prolabels =labels(EdgSup'==0);
fixedBG= zeros(size(Img,1),size(Img,2));
for l=1: size(prolabels,2)
    fixedBG((Label==prolabels(l)-1))=1;
end
Discard = sum(WconFirst,2);
% DiscardPos = find( Discard < 0.5 );
% % to discard the outlier �ֺ��� �ϳ��� �ȴ�����(�⺻ �ڱ��ڽŰ� 1�̴ϱ�
% % �ֺ�����Ⱦֵ��̶� similiarity���� 0.1���� ������, �̰ſ� �ɸ��� �������� saliency ������.
% % %�׷��� ����� ����.
% LenDiscardPos = length(DiscardPos);
%
% for j=1:LenDiscardPos
%     EdgSup( DiscardPos(j) ) = 2;
% end

NumIn = k - length( find( EdgSup == 2 ) );
%Edge�� ����ִ¾ֵ� �ȿ��ִ°ɷ� ġ�� duplicate�ؼ� absorbing����ϱ� In������ k-discardlength
NumEdg = length( find( EdgSup==1 ) );
%�����Ѿֵ鰹��
EdgWcon = zeros( k, NumEdg );
%absorbing�� �������ֵ��� connection
%������ ������ connection�� ������.
%�츮�� �̺κ��� ������ߵ�.
mm=1;
for j=1:k
    if EdgSup(j)==1
        EdgWcon(:,mm) = WconFirst(:,j);
        mm = mm + 1;
    end
end
alph = 1;  W=zeros(k,k);
% salth =255;
% global maxsal;
%%%%%%%%%%%% absorb MC
if NumIn == k
    BaseEdg = sum( EdgWcon, 2 )*6; %�󸶳� neighbor�� boundary sup�� ����ִ°�
    D = diag( Discard + BaseEdg );%Discard�� �󸶳� neighbor�� ��Ҵ°�
    Wcon =  D \ WconFirst;
    I = eye( NumIn );
    N = ( I - alph* Wcon  ); %������ Wcon�� transient state�� transient matrix
    y = ones( NumIn, 1 );
    
    Sal = N \ (EdgSup==0);%N\y;
%     Sal = N\y;
    
    %     maxsal = max(Sal(:));
%         Sal(Sal>salth)=salth;
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



