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
        width = min(widthCurrent,widthMax);
        height = min(heightMax,heightCurrent);
        %remove lower boxes that are completely surrounding a higher one
        if(jj ~= index && ((Data(index, 1) - Data(jj, 1)) >= 0) ... 
                && ((Data(index, 2)-Data(jj, 2)) >= 0) ... 
                && ((Data(index, 1) + Data(index, 3) - Data(jj, 1) - Data(jj, 3)) <= 0) ...
                && ((Data(index, 2) + Data(index, 4)-Data(jj, 2) - Data(jj, 4)) <= 0 ))
            Data(jj,5) = 0;
        end
        %remove boxes that share too much x, much harsher on y value
        %because we are mainly interested in people in the foreground
        if (jj ~= index && ((abs(Data(index,1) - Data(jj,1)) < width/2) && (abs(Data(index,2) - Data(jj,2) ) < height))) 
            Data(jj,5) = 0;
         elseif (jj ~= index && ((abs((Data(index,1)+widthMax) - (Data(jj,1)+Data(jj,3))) < width/2) && (abs((Data(index,2)) - Data(jj,2)) < height)))
            Data(jj,5) = 0; 
        end
    end
    Data(index,5) = 0;
end
end

