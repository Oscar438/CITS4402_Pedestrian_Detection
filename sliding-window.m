function [bbox] = sliding-window(im,model, xbox, ybox, step, itr)
%SLIDING-WINDOW Summary of this function goes here
%   Detailed explanation goes here
% bbox = [xbox/scale, ybox/scale, xpos/scale, ypos/scale, probability]
[height, width] = size(im)
scale
bbox = []
for ii = 1:step:height-ybox
    for jj = 1:step:width-xbox
        imageCropped = im(ii:ii+ybox,jj:jj+xbox);
        imageResized = imresize(imageCropped,[80,20]);
        hogImg = hog_feature_vector(imageResized);
        [ped, per] = predict(model, hogImg):
    end
end


end

