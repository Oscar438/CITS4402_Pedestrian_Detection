function [DataOut] = NonMaximaSupression(Data)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   Data [x,y,width,height,probability]
%   Data [width,height,x,y,probability]
%    1-> 3, 2->4, 

count = 1;
DataOut = zeros(size(Data));
for ii = 1:length(Data)
    [Maximum,index] = max(Data(:,5));
    if (Maximum == 0)
        break
    end
    width = Data(index,3);
    height = Data(index,4);
    DataOut(count,:) = Data(index,:);
    for jj = 1: length(Data)
        if (jj ~= count && (abs(Data(jj,1) - Data(count,1)) < width/2) && (abs(Data(jj,2) - Data(count,2)) < height/2))
            Data(jj,5) = 0;
        end
    end
    Data(index,5) = 0;
    count = count + 1;
end
end

