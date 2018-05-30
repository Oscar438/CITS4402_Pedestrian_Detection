function [newim] = lbp(im)
%LBP Summary of this function goes here
%   Detailed explanation goes here
if size(im,3)==3
    im=rgb2gray(im);
end
[r,c] = size(im);
newim = zeros(r-2, c-2);

for ii = 1:r-2
    for jj = 1:c-2
        if im(ii, jj) > im(ii+1, jj+1) 
            newim(ii, jj) = newim(ii, jj) + 1;
        end
         if im(ii, jj+1) > im(ii+1, jj+1) 
            newim(ii, jj) = newim(ii, jj) + 2;
         end
         if im(ii, jj+2) > im(ii+1, jj+1) 
            newim(ii, jj) = newim(ii, jj) + 4;
         end
         if im(ii+1, jj+2) > im(ii+1, jj+1) 
            newim(ii, jj) = newim(ii, jj) + 8;
         end
         if im(ii+2, jj+2) > im(ii+1, jj+1) 
            newim(ii, jj) = newim(ii, jj) + 16;
         end
         if im(ii+2, jj+1) > im(ii+1, jj+1) 
            newim(ii, jj) = newim(ii, jj) + 32;
         end
         if im(ii+2, jj) > im(ii+1, jj+1) 
            newim(ii, jj) = newim(ii, jj) + 64;
         end
         if im(ii+1, jj) > im(ii+1, jj+1) 
            newim(ii, jj) = newim(ii, jj) + 128;
         end
    end
end

end

