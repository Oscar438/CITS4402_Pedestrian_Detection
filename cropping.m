% The MATLAB fullfile function might be a better solution here (if we're
% pedandic about '/' vs '\'
baseDir = [pwd '\training-data\'];
annotDir = [baseDir 'PennFudanPed\Annotation\'];

files = dir(annotDir); files(1:2) = [];
close all;
count = 1;
NumCrops = 335*2+1;
test = zeros(NumCrops, 324);
Labels = zeros(NumCrops,1);
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
        Labels(count) = 1; 
        count= count+1;
        %imshow(imageCropped);
    end
end
%335
baseDir = [pwd '\Negative\'];

files = dir(baseDir); files(1:2) = [];

%need 112
for ii = 1:112
    im = imread(files(ii).name);
    [rows, cols] = size(im);
    centreX = cols/2;
    centreY = rows/2;
    sizeY = rows/4;
    sizeX = cols/4;
    imageCropped = imcrop(im, [centreX-(sizeX/2),centreY-(sizeY/2),sizeX,sizeY]);
    imageresized = imresize(imageCropped,[80,20]);
    test2 = hog_feature_vector(imageresized);
    test(count,:) = test2;
    Labels(count) = 0; 
    count= count+1;
    
    sizeY = rows/3;
    sizeX = cols/3;
    imageCropped = imcrop(im, [centreX-(sizeX/2),centreY-(sizeY/2),sizeX,sizeY]);
    imageresized = imresize(imageCropped,[80,20]);
    test2 = hog_feature_vector(imageresized);
    test(count,:) = test2;
    Labels(count) = 0; 
    count= count+1;
    
    sizeY = rows/2;
    sizeX = cols/2;
    imageCropped = imcrop(im, [centreX-(sizeX/2),centreY-(sizeY/2),sizeX,sizeY]);
    imageresized = imresize(imageCropped,[80,20]);
    test2 = hog_feature_vector(imageresized);
    test(count,:) = test2;
    Labels(count) = 0; 
    count= count+1;
end

SVM = fitcsvm(test,Labels);
SVM2 = fitSVMPosterior(SVM);
% Next step is to scale all the images to the same size, was it 80x20? I
% can't remember.