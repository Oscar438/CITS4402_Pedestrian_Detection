function [DataOut] = NonMaximaSupression(Data)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   Data [x,y,width,height,probability]
%   Data [width,height,x,y,probability]
%    1-> 3, 2->4, 

count = 1;
DataOut = zeros(size(Data));
[rows, cols] = size(Data);
for ii = 1:rows
    [Maximum,index] = max(Data(:,5));
    if (Maximum == 0)
        break
    end
    width = Data(index,3);
    height = Data(index,4);
    DataOut(ii,:) = Data(index,:);
    for jj = 1: rows
        if (jj ~= index && ((abs(Data(jj,1) - Data(index,1)) < width/10) || (abs(Data(jj,2) - Data(index,2)) < height/10)))
            Data(jj,5) = 0;
        end
    end
    Data(index,5) = 0;
end
end
