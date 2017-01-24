function feats_reshape = reshapeCNNFeature_img(feats,pad,im_w,im_h,layers,scales)
featdim =0;
for j=1:length(layers)
    featdim = featdim+size(feats{j},1);
end
% feats_reshape = cell(length(layers),1);
feats_reshape = zeros(im_h, im_w, featdim);
featdim =1;
for j = 1:length(layers)
    act = feats{j};
    act = reshape(act,[size(act,1),512/scales(j),512/scales(j)]);

    if im_w > im_h && (im_w >= 512 || im_h >= 512)
        tmp = imresize(permute(act,[2,3,1]),[im_w im_w]);
    elseif im_h > im_w && (im_w >= 512 || im_h >= 512)
        tmp = imresize(permute(act,[2,3,1]),[im_h im_h]);
    elseif im_w <= 512 && im_h <= 512
        tmp = imresize(permute(act,[2,3,1]),[512 512]);
    end
    act = imPad(tmp, -pad, 0);
    
%     act = reshape(permute(act,[3,1,2]),[size(act,3),im_w*im_h]);
    act= bsxfun(@times, act, 1./(sqrt(sum(act.^2,3))+eps));
    feats_reshape(:,:,featdim:featdim+size(act,3)-1) = act;
    featdim = featdim + size(act,3);
end
