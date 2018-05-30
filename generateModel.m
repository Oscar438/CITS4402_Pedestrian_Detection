function [svm] = generateModel(positives, negatives, negativesmining, miningiterations, hogrows, hogcols)
%GENERATEMODEL Summary of this function goes herehere
%   Detailed explanation goes here

baseDir = fullfile(pwd, 'training-data');
annotDir = fullfile(baseDir, 'PennFudanPed', 'Annotation');
negDir = fullfile(baseDir, 'Negative');
pednegdir = fullfile(baseDir, 'ped-negative');

files = dir(annotDir); files(1:2) = [];

count = 1;
numCrops = 10000;

fileName = fullfile(annotDir, files(1).name);
record = PASreadrecord(fileName);
image = imread(fullfile(baseDir,record.imgname));
imageresized = imresize(image,[hogrows,hogcols]);
[ ~, featureSize ] = size(hog_feature_vector(imageresized));

test = zeros(numCrops, featureSize);
labels = zeros(numCrops,1);
for ii = 1 : positives
    fileName = fullfile(annotDir, files(ii).name);
    record = PASreadrecord(fileName);
    image = imread(fullfile(baseDir,record.imgname));
    negImage = rgb2gray(image);
    %lbp of image??
%     image = lbp(image);
 
    for jj = 1 : length(record.objects)
        bbox = record.objects(jj).bbox;
        bbox(3:4) = bbox(3:4) - bbox(1:2);
        imageCropped = imcrop(image,bbox);
        imageresized = imresize(imageCropped,[ hogrows, hogcols]);
        test2 = hog_feature_vector(imageresized);
        test(count,:) = test2;
        labels(count) = 1; 
        count= count+1;
        negImage(bbox(2):(bbox(2)+bbox(4)+10), bbox(1):(bbox(1)+bbox(3)+10)) = 200;
        %imshow(imageCropped);
    end
% % %     imwrite(negImage, strcat(fullfile(baseDir, 'ped-negative', 'neg'), int2str(ii), '.png') )
%     [height, width, garbage] = size(negImage);
%     xbox = 40;
%     ybox = 160;
%     for kk = 1:ybox*4:height-ybox
%         for ll = 1:xbox*4:width-xbox
%             negImageCropped = negImage(kk:kk+ybox,ll:ll+xbox);
%             negImageResized = imresize(negImageCropped,[ hogrows, hogcols]);
%             test2 = hog_feature_vector(negImageResized);
%             test(count,:) = test2;
%             labels(count) = 0; 
%             count = count+1;
%         end
%     end
end
%335

files = dir(negDir); files(1:2) = [];
for ii = 1:negatives
    negImage = imread(files(ii).name);
%     negImage = lbp(negImage);
    [height, width, ~] = size(negImage);
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
            negImageResized = imresize(negImageCropped,[ hogrows, hogcols ]);
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
% 
% files = dir(negDir); files(1:2) = [];
% for kk = 1:miningiterations
%     [appendTest, appendLabel] = negativetraining( SVM2, files, negativesmining, hogrows, hogcols, featureSize, kk);
%     test = [test; appendTest];
%     labels = [labels; appendLabel];
%     SVM = fitcsvm(test,labels);
%     SVM2 = fitSVMPosterior(SVM);
% end

svm = SVM2;

end

