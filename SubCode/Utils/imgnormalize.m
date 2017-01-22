function img =imgnormalize(img)

img =reshape(normalize(img(:)),size(img));