function [b] = bilinear_interp(I, pt)
% bilinear_interp Performs bilinear interpolation for a given image point.
%
%   Given the (x y) location of a point in an input image, use the 
%   surrouning 4 pixels to output the bilinearly interpolated intensity.
%
%   Note that images are (usually) integer-valued functions (in 2D), therefore
%   the intensity value you return should be an integer.
%
%  Inputs:
%  -------
%   I   - Input image (monochrome, one channel - n rows x m columns).
%   pt  - Point in input image (x, y), with subpixel precision.
%
%  Outputs
%  -------
%   b  - Interpolated brightness or intensity value (whole number >= 0).
  
    
    % convert point to unit square
    x = pt(1) - floor(pt(1));
    y = pt(2) - floor(pt(2));
    
    %use matrix representation of bilinear interpolation
    xMat = [1-x, x];
    yMat = [1-y, y];
    s = size(I);
    % get surronding pixels
    xL = min(max(floor(pt(1)),1),s(2));
    xR = max(min(ceil(pt(1)),s(2)),1);
    yL = min(max(floor(pt(2)),1),s(1));
    yR = max(min(ceil(pt(2)),s(1)),1);
    
    %calculate value
    intensityMat = [double(I(yL,xL)),double(I(yR,xL));double(I(yL,xR)),double(I(yR,xR))];
    
    b = round(xMat * intensityMat * yMat');
%------------------

end
