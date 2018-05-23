function [outFeature, outLabel] = negativetraining(model, files)
%NEGATIVETRAINING Summary of this function goes here
%   Creates a new labeled set of training data, which gets fed in to the
%   SVM
outFeature = zeros(3360, 324);
index=0
for kk = 1:50
    im = imread(files(kk).name);
    for ii = linspace(0.01, 0.3, 20)
        Slide = slidingwindow(imresize(im,ii),model,25,80,5,ii);
        MaxSup = NonMaximaSupression(Slide);
        MaxSup( ~any(MaxSup,2), : ) = [];
        [rows, cols] = size(MaxSup);
        MaxSup = uint16(MaxSup);
        if rows>0
            for jj = 1:rows
                index = index+1;
                imCr = imcrop( im, MaxSup(index, 1:4) );
                imresiz = imresize(imCr,[80,20]);
                outFeature(index, :) = hog_feature_vector(imresiz);
            end 
        end     
    end
end
outFeature( ~any(outFeature,2), : ) = [];
[rows, cols] = size(outFeature);
outLabel = zeros(rows, 1);

end

