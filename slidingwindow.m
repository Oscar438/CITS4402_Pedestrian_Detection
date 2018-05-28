function [bbox] = slidingwindow(im,model, xbox, ybox, scale, prob,  hogrows, hogcols)
%SLIDING-WINDOW Summary of this function goes here
%   Detailed explanation goes here
% bbox = [xpos/scale, ypos/scale, xbox/scale, ybox/scale, probability]
[height, width, ~] = size(im);
step = max([ceil(width/xbox), ceil(height/ybox), ceil(xbox/5), ceil(ybox/5)]);
stepx = step;
stepy = step;

count = 1;
if (height - ybox <= 0|| width - xbox <= 0)
    bbox = zeros(1,7);
   return 
end
bbox = zeros(round((width/step)*(height/step)), 7);

for ii = 1:stepy:height-ybox
    for jj = 1:stepx:width-xbox
        imageCropped = im(ii:ii+ybox,jj:jj+xbox);
        imageResized = imresize(imageCropped,[ hogrows, hogcols]);
        hogImg = hog_feature_vector(imageResized);
        [ped, per] = predict(model, hogImg);
        probability = per(1,2);
        if (ped == 1 && probability > prob)
           xpos = jj;
           ypos = ii;
           bbox(count,:) = [xpos/scale, ypos/scale, xbox/scale, ybox/scale, probability, xbox, ybox];
           count = count + 1;
        end
    end
end
end

