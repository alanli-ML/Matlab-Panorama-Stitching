function [H] = best_homography(I1matches, I1descs, I2matches, I2descs)
% best_homography Find 'best' homography between two images.
%
%   Deteremine the best homography between two images, given the set of all
%   matched features from the images (and their descriptors)
%
%   Inputs:
%   -------
%    I1matches  - 2xn array of matched points from Image 1.
%    I1descs    - mxn array of associated descriptors (if needed).
%    I2matches  - 2xn array of matched points from Image 2 (1-to-1).
%    I2descs    - mxn array of associated descriptors (if needed).
%
%   Outputs:
%   --------
%    H  - 3x3 perspective homography (matrix map) between image coordinates.

N = 1000;
    threshold = 0.15;
    [m,n] = size(I1matches);
    x_in = ones(3,n);
    x_in(1:2,:) = I1matches;
    y_in = ones(3,n);
    y_in(1:2,:) = I2matches;
    %run ransac
    for  i = 1:N
        %get 4 random points
        idx = randperm(n,4);
        %get transformation
        [H,A]=dlt_homography(I1matches(:,idx),I2matches(:,idx));
        
        res = H*x_in;
        res = res./res(3,:);
        %calculate error
        err = res-y_in;
        errsq = dot(err(1:2,:),err(1:2,:));
        %threshold error
        bin = errsq(:,:);
        bin(errsq<150) = 0;
        bin(errsq>=150) = 1;
        %get fraction of points within error threshold
        if sum(bin)/n <= threshold
            %success
            break
        end
    end
    if i == N
        %failed
        H = zeros(3);
    end
%------------------
  
end
