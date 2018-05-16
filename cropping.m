% The MATLAB fullfile function might be a better solution here (if we're
% pedandic about '/' vs '\'
baseDir = [pwd '\training-data\'];
annotDir = [baseDir 'PennFudanPed\Annotation\'];

files = dir(annotDir); files(1:2) = [];
close all;
count = 1;
negcount = 1;
NumCrops = 11735+336;
test = zeros(NumCrops, 324);
Labels = zeros(NumCrops,1);
for ii = 1 : 130
    fileName = [annotDir files(ii).name];
    record = PASreadrecord(fileName);
    image = imread(strcat(baseDir,record.imgname));
    negImage = rgb2gray(image);
    for jj = 1 : length(record.objects)
        bbox = record.objects(jj).bbox;
        bbox(3:4) = bbox(3:4) - bbox(1:2);
        imageCropped = imcrop(image,bbox);
        imageresized = imresize(imageCropped,[80,20]);
        test2 = hog_feature_vector(imageresized);
        test(count,:) = test2;
        Labels(count) = 1; 
        count= count+1;
        negImage(bbox(2):(bbox(2)+bbox(4)), bbox(1):(bbox(1)+bbox(3))) = 0;
        %imshow(imageCropped);
    end
    [height, width, garbage] = size(negImage);
    xbox = 40;
    ybox = 160;
    for kk = 1:80:height-ybox
        for ll = 1:20:width-xbox
            negImageCropped = negImage(kk:kk+ybox,ll:ll+xbox);
            negImageResized = imresize(negImageCropped,[80,20]);
            test2 = hog_feature_vector(negImageResized);
            test(count,:) = test2;
            Labels(count) = 0; 
            count = count+1;
        end
    end
  
     
end
%335

%need 112
for ii = 1:620
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