% panorama Script that produces an attractive panormama from three images.
%
%  Script that uses your homography and bilinear interpolation functions, a
%  feature detector, and an outlier removal function, to stitch together a
%  three-image panorama.
%


%load images in grayscale and rgb and get features
books1_rgb=imread('panorama\books_01.png');
books1=rgb2gray(books1_rgb);
%only get features from overlapping sections to save time and reduce errors
[p1,feat1]=features(books1(:,300:end));
p1(1,:) = p1(1,:) + 300;

%repeat for remaining images
books2_rgb = imread('panorama\books_02.png');
books2=rgb2gray(books2_rgb);
[p2,feat2]=features(books2(:,1:150));

books2_right = books2(:,300:end);
[p2_right,feat2_right]=features(books2_right);
p2_right(1,:) = p2_right(1,:) + 300;

books3_rgb = imread('panorama\books_03.png');
books3=rgb2gray(books3_rgb);
[p3,feat3]=features(books3(:,1:150));



%match features individually
n12 = size(p2,2);
j = 1;
for i=1:n12
   [bd, idx] = matches(feat2.Features(i,:)',feat1.Features');
    %remove if no feature matches closely enough
   if ~isnan(idx)
        indexPairs12(j,:) = [i,idx];
        j = j +1;
   end
end
%repeat for right image
n23 = size(p2_right,2);
j=1;
for i=1:n23
   [bd, idx] = matches(feat2_right.Features(i,:)',feat3.Features');
   if ~isnan(idx)
        indexPairs23(j,:) = [i,idx];
        j = j+1;
   end
end

%get the corresponding points for the matched features
matchedPoints1 = p1(:,indexPairs12(:,2));
matchedPoints2L = p2(:,indexPairs12(:,1));

matchedPoints3 = p3(:,indexPairs23(:,2));
matchedPoints2R = p2_right(:,indexPairs23(:,1));


%remove matches with large vertical offsets; this is a horizontal panorama
for i = size(matchedPoints1,2):-1:1
    if abs(matchedPoints1(2,i) - matchedPoints2L(2,i)) > 100
        matchedPoints1(:,i) = [];
        matchedPoints2L(:,i) = [];
    end
end
%repeat for right image
for i = size(matchedPoints3,2):-1:1
    if abs(matchedPoints3(2,i) - matchedPoints2R(2,i)) > 100
        matchedPoints3(:,i) = [];
        matchedPoints2R(:,i) = [];
    end
end

figure; showMatchedFeatures(books1,books2,matchedPoints1',matchedPoints2L');
figure; showMatchedFeatures(books3,books2,matchedPoints3',matchedPoints2R');

%get best homography between points
H12 = best_homography(matchedPoints2L,[],matchedPoints1,[]);
H23 = best_homography(matchedPoints2R,[],matchedPoints3,[]);

%create pano canvas
pano = zeros(1000,2000,3,'uint8');
xoffset = 800;
yoffset = 200;


%display side images transformed into space of middle image
for x =-500:100
    for y = -100:900
        %transform pixel in pano to pixel in left image
        p_t = H12*[x;y;1];
        p_t = p_t/p_t(3);
        if p_t(1) >= 1 && p_t(1) <= size(books1,2) && p_t(2) >= 1 && p_t(2) <= size(books1,1)
            %use bilinear interpolation to estimate value
            for i = 1:3  
              v = bilinear_interp(books1_rgb(:,:,i),p_t);
              pano(y+yoffset,x+xoffset,i) = v;
            end
        end
     end
end

%repeat for right image
for x = 400:900
    for y = -100:900
        p_t = H23*[x;y;1];
        p_t = p_t/p_t(3);
        if p_t(1) >= 1 && p_t(1) <= size(books3,2) && p_t(2) >= 1 && p_t(2) <= size(books3,1)
            %disp(p_t)
            for i = 1:3  
              v = bilinear_interp(books3_rgb(:,:,i),p_t);
              pano(y+yoffset,x+xoffset,i) = v;
            end
        end
    end
end

%paste in central image
pano(yoffset+1:yoffset+size(books2_rgb,1),xoffset+1:xoffset+size(books2_rgb,2),:) = books2_rgb;
figure;imshow(pano);
imwrite(pano,'panorama.png')


%------------------
