function [outFeature, outLabel] = negativetraining(model, files, negativesmining, hogrows, hogcols, featureSize, prob)
%NEGATIVETRAINING Summary of this function goes here
%   Creates a new labeled set of training data, which gets fed in to the
%   SVM
outFeature = zeros(5000, featureSize);
count = 1;
for kk = 1:negativesmining
    im = imread(files(kk).name);
    fprintf(strcat('working on image nbr: ', string(kk)));
    for ii = linspace(0.2, 0.4, 3)
        index=0;
        Slide = slidingwindow(imresize(im,ii),model,hogcols,hogrows,ii, prob, hogrows, hogcols);
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
                count = count+1;
            end 
        end
    end
end
outFeature( ~any(outFeature,2), : ) = [];
[rows, ~] = size(outFeature);
outLabel = zeros(rows, 1);

end

