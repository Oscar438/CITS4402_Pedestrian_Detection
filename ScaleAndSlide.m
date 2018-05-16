function [outputArg1] = ScaleAndSlide(MinSize,MaxSize, Steps,im, SVM2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tic
StepSize = MinSize/Steps;
ScaleOutput = zeros(10000,5);
index = 1;
for ii = MinSize:StepSize:MaxSize
    Slide = slidingwindow(imresize(im,ii),SVM2,20,80,10,ii);
    MaxSup = NonMaximaSupression(Slide);
    [rows, cols] = size(MaxSup);
    ScaleOutput(index:index+rows-1,1:5) = MaxSup;
    index = index+rows;
end

FinalOutput = NonMaximaSupression(ScaleOutput);

figure,imshow(im)
hold on
[rows, cols] = size(FinalOutput);
sScoreStart = 'Score: ';
for ii = 1:rows
    if (FinalOutput(ii,3) == 0)
        continue
    end
    rectangle('Position',FinalOutput(ii,1:4),'EdgeColor','g', 'LineWidth', 3);
    sScore = num2str(FinalOutput(ii,5)*100);
    sScoreFinal = strcat(sScoreStart,sScore);
    text(double(FinalOutput(ii,1)), double(FinalOutput(ii,2)-10),sScoreFinal, 'Color', 'green', 'FontSize', 10);
end

toc

end

