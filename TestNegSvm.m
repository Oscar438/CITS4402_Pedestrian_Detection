baseDir = [pwd '\Negative\'];

files = dir(baseDir); files(1:2) = [];
count = 1;
NumCrops = 335*2+1;
test = zeros(NumCrops, 324);
output = zeros(30,3);


for ii = 113:length(files)
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
        [ped, per] = predict(SVM2,test2);
        output(count,1) = ped;
        output(count,2:3) = per;
    count= count+1;
    
    sizeY = rows/3;
    sizeX = cols/3;
    imageCropped = imcrop(im, [centreX-(sizeX/2),centreY-(sizeY/2),sizeX,sizeY]);
    if (count == 37)
        imshow(imageCropped);
    end 
    imageresized = imresize(imageCropped,[80,20]);
    test2 = hog_feature_vector(imageresized);
    test(count,:) = test2;        [ped, per] = predict(SVM2,test2);
        output(count,1) = ped;
        output(count,2:3) = per;
    count= count+1;
    
    sizeY = rows/2;
    sizeX = cols/2;
    imageCropped = imcrop(im, [centreX-(sizeX/2),centreY-(sizeY/2),sizeX,sizeY]);
    if (count == 37)
        imshow(imageCropped);
    end 
    imageresized = imresize(imageCropped,[80,20]);
    test2 = hog_feature_vector(imageresized);
    test(count,:) = test2;
        [ped, per] = predict(SVM2,test2);
        output(count,1) = ped;
        output(count,2:3) = per;
    count= count+1;
end