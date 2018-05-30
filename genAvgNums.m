function [avgx,avgy, avgrat, xvar, yvar] = genAvgNums()
%GENAVGNUMS Summary of this function goes here
%   Detailed explanation goes here

baseDir = fullfile(pwd, 'training-data');
annotDir = fullfile(baseDir, 'PennFudanPed', 'Annotation');

files = dir(annotDir); files(1:2) = [];
count=1;
xsum=0;
ysum=0;
ratsum = 0
for ii = 1:170
fileName = fullfile(annotDir, files(ii).name);
record = PASreadrecord(fileName);
    for jj = 1 : length(record.objects)
        bbox = record.objects(jj).bbox;
        bbox(3:4) = bbox(3:4) - bbox(1:2);
        xsum = xsum + bbox(3);
        ysum = ysum + bbox(4);
        ratsum = ratsum + bbox(3)/bbox(4);
        count= count+1;
    end
end
avgx = xsum/count;
avgy = ysum/count;
avgrat = ratsum/count;

xvar = 0;
yvar = 0;

for ii = 1:170
fileName = fullfile(annotDir, files(ii).name);
record = PASreadrecord(fileName);
    for jj = 1 : length(record.objects)
        bbox = record.objects(jj).bbox;
        bbox(3:4) = bbox(3:4) - bbox(1:2);
        xvar = (bbox(3)-avgx)^2;
        yvar = (bbox(4)-avgy)^2;
    end
end
xvar = xvar/(count-1);
yvar = yvar/(count-1);



