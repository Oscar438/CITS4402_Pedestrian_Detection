function [output, output2] = main(im, SVM2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
output = slidingwindow(imresize(im,0.3), SVM2, 20 ,80,1,0.3);
output2 = NonMaximaSupression(output);
figure,imshow(im)
hold on
for ii = 1:length(output2)
    rectangle('Position',output2(ii,1:4),'EdgeColor','g', 'LineWidth', 3);
end
end

