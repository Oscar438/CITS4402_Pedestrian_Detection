function [bbox, person, notperson] = slidingwindow(im,model, xbox, ybox, step, scale)
%SLIDING-WINDOW Summary of this function goes here
%   Detailed explanation goes here
% bbox = [xpos/scale, ypos/scale, xbox/scale, ybox/scale, probability]
[height, width, garbage] = size(im);
count = 1;
notperson = 1;
if (height - ybox <= 0|| width - xbox <= 0)
    bbox = zeros(1,5);
   return 
end
bbox = zeros(round((width/step)*(height/step)), 5);
for ii = 1:step:height-ybox
    for jj = 1:step:width-xbox
        notperson = notperson + 1;
        imageCropped = im(ii:ii+ybox,jj:jj+xbox);
        imageResized = imresize(imageCropped,[80,20]);
        hogImg = hog_feature_vector(imageResized);
        [ped, per] = predict(model, hogImg);
        probability = per(1,2);
        if (ped == 1 && probability > 0.9)
           xpos = jj;
           ypos = ii;
           bbox(count,:) = [xpos/scale, ypos/scale, xbox/scale, ybox/scale, probability];
           count = count + 1;
        end
    end
end
person = count;
end

