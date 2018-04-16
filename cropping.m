baseDir = '\\uniwa.uwa.edu.au\userhome\Students1\21293921\My Documents\MATLAB\project1\';
annotDir = [baseDir 'PennFudanPed\Annotation\'];

files = dir(annotDir); files(1:2) = [];
close all;
for ii = 1 : 130
    fileName = [annotDir files(ii).name];
    record = PASreadrecord(fileName);
    for jj = 1 : length(record.objects)
        bbox = record.objects(jj).bbox;
        bbox(3:4) = bbox(3:4) - bbox(1:2);
        image = imread(strcat(baseDir,record.imgname));
        imageCropped = imcrop(image,bbox);
        hogg_feature_vector(imageCropped);
        imshow(imageCropped);
    end
    hold off;    
end