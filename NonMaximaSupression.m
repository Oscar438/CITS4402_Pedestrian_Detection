function [DataOut] = NonMaximaSupression(Data)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   Data [x,y,width,height,probability]
DataOut = zeros(size(Data));
[rows, ~] = size(Data);
for ii = 1:rows
    [Maximum,index] = max(Data(:,5));
    if (Maximum == 0)
        break
    end
    width = Data(index,3);
    height = Data(index,4);
    DataOut(ii,:) = Data(index,:);
    for jj = 1: rows
        if (jj ~= index && ((abs(Data(index,1) - Data(jj,1)) < width/2) && (abs( Data(index,2) -Data(jj,2)) < height)))
            Data(jj,5) = 0;
        elseif (jj ~= index && ((abs((Data(index,1)+width) - (Data(jj,1)+Data(jj,3))) < width/2) && (abs( Data(index,2) - Data(jj,2)) < height)))
            Data(jj,5) = 0;  
        end
    end
    Data(index,5) = 0;
end
end

