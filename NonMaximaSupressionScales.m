function [DataOut] = NonMaximaSupressionScales(Data)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   Data [x,y,width,height,probability]
%   Data [width,height,x,y,probability]
%    1-> 3, 2->4, 
DataOut = zeros(size(Data));
[rows, ~] = size(Data);
for ii = 1:rows
    [Maximum,index] = max(Data(:,5));
    if (Maximum == 0)
        break
    end
    widthMax = Data(index,3);
    heightMax = Data(index,4);
    DataOut(ii,:) = Data(index,:);
    for jj = 1: rows
        widthCurrent = Data(jj,3);
        heightCurrent = Data(jj,4);
        width = max(widthCurrent,widthMax);
        height = max(heightMax,heightCurrent);
        if (jj ~= index && ((abs(Data(index,1) - Data(jj,1)) < width) && (abs(Data(index,2) - Data(jj,2) ) < heightMax))) 
            Data(jj,5) = 0;
         elseif (jj ~= index && ((abs((Data(index,1)+widthMax) - (Data(jj,1)+Data(jj,3))) < width/2) && (abs((Data(index,2)) - Data(jj,2)) < height)))
            Data(jj,5) = 0; 
        end
    end
    Data(index,5) = 0;
end
end

