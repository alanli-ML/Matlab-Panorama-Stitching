function [pts, desc] = features(I)
% freatures Extract feature points and associated descriptors from image.
%
%   Extract feature points (possibly at subpixel level) and descriptors from    
%   the supplied monochrome (single channel) image. You may call another 
%   detector from within this function. Note that every point returned shoud 
%   have an associated descriptor, and they should be in the same order.
%
%   Inputs:
%   -------
%    I  - Input image, monochrome, of arbitary size.
%
%   Outputs:
%   --------
%    pts   - 2xn array of feature points (x, y) from image.
%    desc  - mxn array of (column) descriptor vectors, on per point.


%get harris corners
  corners = detectHarrisFeatures(I);
  [features, valid_corners] = extractFeatures(I, corners);
  pts = valid_corners.Location';
  desc = features;
%------------------
  
end