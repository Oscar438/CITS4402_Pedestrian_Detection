% The MATLAB fullfile function might be a better solution here (if we're
% pedandic about '/' vs '\'
baseDir = [pwd '\training-data\'];
annotDir = [baseDir 'PennFudanPed\Annotation\'];
negDir = [pwd '\Negative\'];

files = dir(annotDir); files(1:2) = [];
close all;
count = 1;
numCrops = 3360;
test = zeros(numCrops, 324);
labels = zeros(numCrops,1);
for ii = 1 : 130
    fileName = [annotDir files(ii).name];
    record = PASreadrecord(fileName);
    image = imread(strcat(baseDir,record.imgname));
%     negImage = rgb2gray(image);
    for jj = 1 : length(record.objects)
        bbox = record.objects(jj).bbox;
        bbox(3:4) = bbox(3:4) - bbox(1:2);
        imageCropped = imcrop(image,bbox);
        imageresized = imresize(imageCropped,[80,20]);
        test2 = hog_feature_vector(imageresized);
        test(count,:) = test2;
        labels(count) = 1; 
        count= count+1;
%         negImage(bbox(2):(bbox(2)+bbox(4)), bbox(1):(bbox(1)+bbox(3))) = 0;
        %imshow(imageCropped);
    end
%     [height, width, garbage] = size(negImage);
%     xbox = 40;
%     ybox = 160;
%     for kk = 1:80:height-ybox
%         for ll = 1:20:width-xbox
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
for ii = 1:112
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
            if ii == 11
                rectangle('Position',[ll, kk, xbox, ybox],'EdgeColor','g', 'LineWidth', 3); 
            end
            negImageCropped = negImage(kk:kk+ybox,ll:ll+xbox);
            negImageResized = imresize(negImageCropped,[80,20]);
            test2 = hog_feature_vector(negImageResized);
            test(count,:) = test2;
            labels(count) = 0; 
            count = count+1;
        end
    end

end

SVM = fitcsvm(test,labels);
SVM2 = fitSVMPosterior(SVM);
% [appendTest, appendLabel] = negativetraining(SVM2, files);
% test = [test; appendTest];
% labels = [labels; appendLabel];
% SVM = fitcsvm(test,labels);
% SVM2 = fitSVMPosterior(SVM);


% Next step is to scale all the images to the same size, was it 80x20? I
% can't remember.