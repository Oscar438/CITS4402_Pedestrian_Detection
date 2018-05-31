function [time] = ScaleAndSlide(MinSize,MaxSize, samples, im, SVM2, hogrows, hogcols, prob, sup, xbox, ybox, norec, advanced,net,boxes)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tic    
ScaleOutput = zeros(1,7);
index = 1;
[~,c,~] = size(im);
while(MinSize*c < xbox)
    MinSize = MinSize*1.5;
end

for ii = linspace(MinSize, MaxSize, samples)
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
    sScoreFinal = strcat(sScore, '% scale: ', string(FinalOutput(ii ,6)) );
    text(double(FinalOutput(ii,1)), double(FinalOutput(ii,2)-10),sScoreFinal, 'Color', 'green', 'FontSize', 13);
    
end
hold off
time = toc;

if (time < 2 && norec == 0)
    time = time + ScaleAndSlide(0.35,0.5, 4,im, SVM2, hogrows, hogcols, prob, sup, xbox, ybox, 1, advanced);
    % the reason this is low is because we only want to search this space
    % when the picture is really really small and the previos spaces have
    % gone through very very quickly
     if (time  <  2)
     time = time + ScaleAndSlide(0.6,0.7,4,im, SVM2, hogrows, hogcols, prob, sup, xbox, ybox, 1, advanced);
    end
    if (time  <  3)
     time = time + ScaleAndSlide(0.7,0.9,4,im, SVM2, hogrows, hogcols, prob, sup, xbox, ybox, 1, advanced);
    end
end

end


