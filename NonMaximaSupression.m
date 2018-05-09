function [DataOut] = NonMaximaSupression(Data)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   Data [x,y,width,height,probability]
count = 1;
DataOut = zeros(size(Data));
for ii = 1:length(Data)
    Maximum = max(Data(5,:));
    if (Maximum == 0)
        break
    end
    DataOut(count) = Data(Maximum,:);
    for jj = 1: length(Data)
        if (jj ~= count && (abs(Data(jj,1) - Data(count,1)) < width/2) && (abs(Data(jj,2) - Data(count,2)) < height/2))
            Data(jj,5) = 0;
        end
    end
    Data(Maximum,5) = 0;
    count = count + 1;
end


end

