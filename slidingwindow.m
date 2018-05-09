function [bbox] = slidingwindow(im,model, xbox, ybox, step, scale)
%SLIDING-WINDOW Summary of this function goes here
%   Detailed explanation goes here
% bbox = [xbox/scale, ybox/scale, xpos/scale, ypos/scale, probability]
[height, width] = size(im);
count = 1;
notperson = 1;
bbox = zeros(1000,5);
for ii = 1:step:height-ybox
    for jj = 1:step:width-xbox
        notperson = notperson + 1;
        imageCropped = im(ii:ii+ybox,jj:jj+xbox);
        imageResized = imresize(imageCropped,[80,20]);
        hogImg = hog_feature_vector(imageResized);
        [ped, per] = predict(model, hogImg);
        if (ped == 1)
           probability = per(1,2);
           xpos = jj;
           ypos = ii;
           bbox(count,:) = [xbox/scale, ybox/scale, xpos/scale, ypos/scale, probability];
           count = count + 1;
        end
    end
end


end

