function [time] = ScaleAndSlide(MinSize,MaxSize, samples,im, SVM2, hogrows, hogcols, prob, sup, xbox, ybox, xvar,yvar)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tic;
StepSize = (MaxSize-MinSize)/samples;
ScaleOutput = zeros(1,7);
index = 1;

for ll = -2:yvar:2
    for jj = -5:xvar:5
        for ii = MinSize:StepSize:MaxSize
            MaxSup = slidingwindow(imresize(im,ii),SVM2,xbox+jj,ybox+ll,ii,prob, hogrows, hogcols);
            if sup == 1
                MaxSup = NonMaximaSupression(MaxSup);
            end
            [rows, ~] = size(MaxSup);
            ScaleOutput(index:index+rows-1,1:7) = MaxSup;
            index = index+rows;
        end
    end
end
if sup == 1
    FinalOutput = NonMaximaSupressionScales(ScaleOutput);
else 
    FinalOutput = ScaleOutput;
end

imshow(im)
hold on
[rows, ~] = size(FinalOutput);
sScoreStart = 'Score: ';
for ii = 1:rows
    if (FinalOutput(ii,3) == 0)
        continue
    end
    rectangle('Position',FinalOutput(ii,1:4),'EdgeColor','g', 'LineWidth', 3);
    sScore = num2str(FinalOutput(ii,5)*100);
    sScoreFinal = strcat(sScoreStart,sScore, ' ratio: x:', num2str(FinalOutput(ii, 6)),' y: ', num2str(FinalOutput(ii,7)));
    text(double(FinalOutput(ii,1)), double(FinalOutput(ii,2)-10),sScoreFinal, 'Color', 'green', 'FontSize', 10);
end
hold off
time = toc;

end


