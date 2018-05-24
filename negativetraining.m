function [outFeature, outLabel] = negativetraining(model, files)
%NEGATIVETRAINING Summary of this function goes here
%   Creates a new labeled set of training data, which gets fed in to the
%   SVM
outFeature = zeros(3360, 648);
count = 1;
for kk = 1:50
    im = imread(files(kk).name);
    for ii = linspace(0.05, 0.3, 10)
        index=0;
        Slide = slidingwindow(imresize(im,ii),model,30,80,5,ii, 0.3);
        MaxSup = NonMaximaSupression(Slide);
        MaxSup( ~any(MaxSup,2), : ) = []; 
        [rows, cols] = size(MaxSup);
        MaxSup = uint16(MaxSup);
   
        
        if rows>0
            for jj = 1:rows
                index = index+1;
                imCr = imcrop( im, MaxSup(index, 1:4) );
                imresiz = imresize(imCr,[80,30]);
                outFeature(count, :) = hog_feature_vector(imresiz);
                if ii == 1
                    imshow(imCr)
                end
                count = count+1;
            end 
        end
    end
end
outFeature( ~any(outFeature,2), : ) = [];
[rows, cols] = size(outFeature);
outLabel = zeros(rows, 1);

end

