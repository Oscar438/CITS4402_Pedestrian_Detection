% The MATLAB fullfile function might be a better solution here (if we're
% pedandic about '/' vs '\'
baseDir = [pwd '\training-data\'];
annotDir = [baseDir 'PennFudanPed\Annotation\'];

files = dir(annotDir); files(1:2) = [];
close all;
output = zeros(30,3);
count = 1;
for ii = 131 : 150
    fileName = [annotDir files(ii).name];
    record = PASreadrecord(fileName);
    max = 0;
    for jj = 1 : length(record.objects)
        bbox = record.objects(jj).bbox;
        bbox(3:4) = bbox(3:4) - bbox(1:2);
        image = imread(strcat(baseDir,record.imgname));
        imageCropped = imcrop(image,bbox);
        if (count ==24)
            imshow(imageCropped);
        end
        imageresized = imresize(imageCropped,[80,20]);
        test2 = hog_feature_vector(imageresized);
        [ped, per] = predict(SVM2,test2);
        output(count,1) = ped;
        output(count,2) = per(1,2);
        count= count+1;
        %imshow(imageCropped);
    end
end