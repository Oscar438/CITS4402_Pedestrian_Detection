function [outFeature, outLabel] = negativetraining(model, files, negativesmining, hogrows, hogcols, featureSize, itr)
%NEGATIVETRAINING Summary of this function goes here
%   Creates a new labeled set of training data, which gets fed in to the
%   SVM
outFeature = zeros(5000, featureSize);
count = 1;
for kk = ((itr-1)*negativesmining+1):(itr*negativesmining)
    im = imread(files(kk).name);
    for ii = linspace(0.05, 0.3, 10)
        index=0;
        Slide = slidingwindow(imresize(im,ii),model,hogcols,hogrows,ii, 0.6, hogrows, hogcols);
        MaxSup = NonMaximaSupression(Slide);
        MaxSup( ~any(MaxSup,2), : ) = []; 
        [rows, ~] = size(MaxSup);
        MaxSup = uint16(MaxSup);
   
        
        if rows>0
            for jj = 1:rows
                index = index+1;
                imCr = imcrop( im, MaxSup(index, 1:4) );
                imresiz = imresize(imCr,[ hogrows, hogcols ]);
                outFeature(count, :) = hog_feature_vector(imresiz);
%                 if ii == 1
%                     imshow(imCr)
%                 end
                count = count+1;
            end 
        end
    end
end
outFeature( ~any(outFeature,2), : ) = [];
[rows, cols] = size(outFeature);
outLabel = zeros(rows, 1);

end

