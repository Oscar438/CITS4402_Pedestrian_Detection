% The MATLAB fullfile function might be a better solution here (if we're
% pedandic about '/' vs '\'
baseDir = [pwd '\training-data\'];
annotDir = [baseDir 'PennFudanPed\Annotation\'];

files = dir(annotDir); files(1:2) = [];
close all;
count = 1;
test = zeros(335, 324);
for ii = 1 : 130
    fileName = [annotDir files(ii).name];
    record = PASreadrecord(fileName);
    max = 0;
    for jj = 1 : length(record.objects)
        bbox = record.objects(jj).bbox;
        bbox(3:4) = bbox(3:4) - bbox(1:2);
        image = imread(strcat(baseDir,record.imgname));
        imageCropped = imcrop(image,bbox);
        imageresized = imresize(imageCropped,[80,20]);
        test2 = hog_feature_vector(imageresized);
        test(count,:) = test2;
        count= count+1;
        %imshow(imageCropped);
    end
end

for (
% Next step is to scale all the images to the same size, was it 80x20? I
% can't remember.