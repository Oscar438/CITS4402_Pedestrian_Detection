function [time] = ScaleAndSlide(MinSize,MaxSize, samples,im, SVM2, hogrows, hogcols, prob, sup, xbox, ybox, advanced,net,boxes)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tic
StepSize = (MaxSize-MinSize)/samples;
ScaleOutput = zeros(1,7);
index = 1;

for ii = MinSize:StepSize:MaxSize
    MaxSup = slidingwindow(imresize(im,ii),SVM2,xbox,ybox,ii,prob, hogrows, hogcols);
    if sup == 1
        MaxSup = NonMaximaSupression(MaxSup);
    end
    [rows, ~] = size(MaxSup);
    ScaleOutput(index:index+rows-1,1:7) = MaxSup;
    index = index+rows;
end


if sup == 1
    FinalOutput = NonMaximaSupressionScales(ScaleOutput);
else 
    FinalOutput = ScaleOutput;
end


imshow(im)


hold on
[rows, ~] = size(FinalOutput);
%fprintf('Start Detection \n');
for ii = 1:rows
    if (FinalOutput(ii,3) == 0)
        continue
    end
    if advanced == 1
        rect = [FinalOutput(ii,1)-20,FinalOutput(ii,2)-20,...
            FinalOutput(ii,3)+40,FinalOutput(ii,4)+40];
        [probability,FastRCNNTime] = rcnnScoreChecker(imcrop(im,rect),net,boxes);
        fprintf('CNN Time: %f seconds, Probability: %f \n',FastRCNNTime,probability*100)
        if probability < 0.4
            continue
        end
    end
    
    rectangle('Position',FinalOutput(ii,1:4),'EdgeColor','g', 'LineWidth', 3);
    sScore = num2str(round(FinalOutput(ii,5)*10000)/100);
    sScoreFinal = strcat(sScore, '%');
    text(double(FinalOutput(ii,1)), double(FinalOutput(ii,2)-10),sScoreFinal, 'Color', 'green', 'FontSize', 13);
    
end
hold off
time = toc;
extra = 0;
if (time < 0.5 )
   extra = ScaleAndSlide(MinSize,MaxSize*1.3, samples,im, SVM2, hogrows, hogcols, prob, sup, xbox, ybox, advanced);
end
time = time + extra;

end


