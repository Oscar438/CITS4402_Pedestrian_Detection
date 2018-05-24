
function [bbox, person, notperson] = slidingwindow(im,model, xbox, ybox, step, scale, prob)
%SLIDING-WINDOW Summary of this function goes here
%   Detailed explanation goes here
% bbox = [xpos/scale, ypos/scale, xbox/scale, ybox/scale, probability]
[height, width, garbage] = size(im);


step = max([ceil(width/xbox), ceil(height/ybox), ceil(xbox/5), ceil(ybox/5)]);
stepx = step;
stepy = step;


count = 1;
notperson = 1;
if (height - ybox <= 0|| width - xbox <= 0)
    bbox = zeros(1,5);
   return 
end
bbox = zeros(round((width/step)*(height/step)), 5);

for ii = 1:stepy:height-ybox
    for jj = 1:stepx:width-xbox
        notperson = notperson + 1;
        imageCropped = im(ii:ii+ybox,jj:jj+xbox);
        imageResized = imresize(imageCropped,[80,20]);
        hogImg = hog_feature_vector(imageResized);
        [ped, per] = predict(model, hogImg);
        probability = per(1,2);

        if (ped == 1 && probability > prob)
           xpos = jj;
           ypos = ii;
           bbox(count,:) = [xpos/scale, ypos/scale, xbox/scale, ybox/scale, probability];
           count = count + 1;
        end
    end
end
person = count;
end

