baseDir = [pwd '\Negative\'];

files = dir(baseDir); files(1:2) = [];

for ii = 1:length(files)
    im = imread(files(ii).name);
    [rows, cols] = size(im);
    centreX = cols/2;
    centreY = rows/2;
    sizeY = rows/4;
    sizeX = cols/4;
    imageCropped = imcrop(im, [centreX-(sizeX/2),centreY-(sizeY/2),sizeX,sizeY]);
    imshow(imageCropped);
    pause(1);
    sizeY = rows/3;
    sizeX = cols/3;
    imageCropped = imcrop(im, [centreX-(sizeX/2),centreY-(sizeY/2),sizeX,sizeY]);
    imshow(imageCropped);
    pause(1);
    sizeY = rows/2;
    sizeX = cols/2;
    imageCropped = imcrop(im, [centreX-(sizeX/2),centreY-(sizeY/2),sizeX,sizeY]);
    imshow(imageCropped);
    pause(1);
end


%im2col and imresize will be much better here
%If we resize afterwards as well that would be good