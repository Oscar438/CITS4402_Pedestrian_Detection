function [output, output2] = main(im, SVM2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
tic
output = slidingwindow(imresize(im,0.3), SVM2, 20 ,80,10,0.3);
output2 = NonMaximaSupression(output);
figure,imshow(im)
hold on
[rows, cols] = size(output2);
sScoreStart = 'Score: ';
for ii = 1:rows
    if (output2(ii,3) == 0)
        break
    end
    rectangle('Position',output2(ii,1:4),'EdgeColor','g', 'LineWidth', 3);
    sScore = num2str(output2(ii,5)*100);
    sScoreFinal = strcat(sScoreStart,sScore);
    text(double(output2(ii,1)), double(output2(ii,2)-10),sScoreFinal, 'Color', 'green', 'FontSize', 10);
end
toc
end

