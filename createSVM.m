% The MATLAB fullfile function might be a better solution here (if we're
% pedandic about '/' vs '\'

baseDir = fullfile(pwd, 'training-data');
annotDir = fullfile(baseDir, 'PennFudanPed', 'Annotation');
negDir = fullfile(baseDir, 'Negative');
pednegdir = fullfile(baseDir, 'ped-negative');

files = dir(annotDir); files(1:2) = [];
close all;
count = 1;
numCrops = 5000;
test = zeros(numCrops, 324);

labels = zeros(numCrops,1);
for ii = 1 : 170
    fileName = fullfile(annotDir, files(ii).name);
    record = PASreadrecord(fileName);
    image = imread(fullfile(baseDir,record.imgname));
    negImage = rgb2gray(image);
    for jj = 1 : length(record.objects)
        bbox = record.objects(jj).bbox;
        bbox(3:4) = bbox(3:4) - bbox(1:2);
        imageCropped = imcrop(image,bbox);
        imageresized = imresize(imageCropped,[80,20]);
        test2 = hog_feature_vector(imageresized);
        test(count,:) = test2;
        labels(count) = 1; 
        count= count+1;
        negImage(bbox(2):(bbox(2)+bbox(4)+10), bbox(1):(bbox(1)+bbox(3)+10)) = 200;
        %imshow(imageCropped);
    end
   %%% imwrite(negImage, strcat('ped-negative\neg', int2str(ii), '.png') )
%     [height, width, garbage] = size(negImage);
%     xbox = 40;
%     ybox = 160;
%     for kk = 1:ybox*4:height-ybox
%         for ll = 1:xbox*4:width-xbox
%             negImageCropped = negImage(kk:kk+ybox,ll:ll+xbox);
%             negImageResized = imresize(negImageCropped,[80,20]);
%             test2 = hog_feature_vector(negImageResized);
%             test(count,:) = test2;
%             labels(count) = 0; 
%             count = count+1;
%         end
%     end
end
%335

files = dir(negDir); files(1:2) = [];
for ii = 1:30
    negImage = imread(files(ii).name);
    testNeg = negImage;
    [height, width, garbage] = size(negImage);
    xbox = int16(width./10);
    ybox = int16(height./4);
%     if ii == 11
%       figure, imshow(testNeg)
%       hold on;
%     end
    for kk = 1:ybox:height-ybox
        for ll = 1:xbox:width-xbox
%             if ii == 11
%                 rectangle('Position',[ll, kk, xbox, ybox],'EdgeColor','g', 'LineWidth', 3); 
%             end
            negImageCropped = negImage(kk:kk+ybox,ll:ll+xbox);
            negImageResized = imresize(negImageCropped,[80,20]);
            test2 = hog_feature_vector(negImageResized);
            test(count,:) = test2;
            labels(count) = 0; 
            count = count+1;
        end
    end
end

test = test(1:count, :);
labels = labels(1:count,:);

SVM = fitcsvm(test,labels);
SVM2 = fitSVMPosterior(SVM);
[appendTest, appendLabel] = negativetraining(SVM2, files, 20, 80, 20, 324);
test = [test; appendTest];
labels = [labels; appendLabel];
SVM = fitcsvm(test,labels);
SVM2 = fitSVMPosterior(SVM);

files = dir(negDir); files(1:2) = [];

[appendTest, appendLabel] = negativetraining(SVM2, files, 20, 80, 20, 324);
test = [test; appendTest];
labels = [labels; appendLabel];
SVM = fitcsvm(test,labels);
SVM2 = fitSVMPosterior(SVM);

% Next step is to scale all the images to the same size, was it 80x20? I
% can't remember.