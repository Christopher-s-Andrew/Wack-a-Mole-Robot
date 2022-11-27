%camera color detection
function [Xc, Yc, Zc] = blobFinder(camera1, camera2, steroParameters, filter)
    %use color finder to determin threshold for buttons latter
    %may need seperate filters for each image?
    if (filter == "red") %red button
        c1Min = 0.857;
        c1Max = 0.0;
        c2Min = 0.315;
        c2Max = 0.632;
        c3Min = 0.392;
        c3Max = 0.581; 
    elseif (filter == "blue") %blue button
        c1Min = 0;
        c1Max = 0;
        c2Min = 0;
        c2Max = 0;
        c3Min = 0;
        c3Max = 0;         
    else %green button
        c1Min = 0;
        c1Max = 0;
        c2Min = 0;
        c2Max = 0;
        c3Min = 0;
        c3Max = 0;  
    end   
    
    %grab snapshot from each camera
    image1 = snapshot(camera1);
    image2 = snapshot(camera2);
    
    %undistort image
    image1=undistortImage(image1, steroParameters.CameraParameters1);
    image2=undistortImage(image2, steroParameters.CameraParameters1);
    
    %show original image
    figure(1)
    imshow(image1)
    
    %convert to right image format
    image1_colorSpace = rgb2hsv(image1);
    image2_colorSpace = rgb2hsv(image2);
    
    %mask creation and application
    image1_mask = ( (image1_colorSpace(:,:,1) >= c1Min) | (image1_colorSpace(:,:,1) <= c1Max) ) & ...
(image1_colorSpace(:,:,2) >= c2Min ) & (image1_colorSpace(:,:,2) <= c2Max) & ...
(image1_colorSpace(:,:,3) >= c3Min ) & (image1_colorSpace(:,:,3) <= c3Max);
    
    image2_mask = ( (image2_colorSpace(:,:,1) >= c1Min) | (image2_colorSpace(:,:,1) <= c1Max) ) & ...
(image2_colorSpace(:,:,2) >= c2Min ) & (image2_colorSpace(:,:,2) <= c2Max) & ...
(image2_colorSpace(:,:,3) >= c3Min ) & (image2_colorSpace(:,:,3) <= c3Max);

    %show masked image for 1 camera (DEBUG)
    im1_masked = image1_mask;
    imageToShowMask=image1;
    imageToShowMask(repmat(~im1_masked,[1 1 3])) = 0; 
    figure(2); clf;
    imshow(imageToShowMask)
    
    %masked image 2
     im2_masked = image2_mask;
    imageToShow2Mask=image2;
    imageToShow2Mask(repmat(~im2_masked,[1 1 3])) = 0; 
    figure(3); clf;
    imshow(imageToShow2Mask)
    
    %centroid detection and largest finding
    CC = bwconncomp(image1_mask);
    s = regionprops(CC,'Centroid','Area');
    centroids = cat(1,s.Centroid);
    areas = cat(1,s.Area);
    [m,ind] = max(areas);
    
    if(m >= 10)
    xCam1 = centroids(ind,1);
    yCam1 = centroids(ind,2);
    end
    
    CC = bwconncomp(image2_mask);
    s = regionprops(CC,'Centroid','Area');
    centroids = cat(1,s.Centroid);
    areas = cat(1,s.Area);
    [m,ind] = max(areas) ;
    
    
    if(m >= 10)
       xCam2 = centroids(ind,1);
         yCam2 = centroids(ind,2);
    end
    
    %find point in 3d
    %checks to make sure the max object is at least a decent size
    %indicating button
    if(m >= 10)
        [Xc, Yc, Zc] = triangulate([xCam1,yCam1], [xCam2, yCam2], steroParameters);
    else
        Xc = 0;
        Yc = 0;
        Zc = 0;
    end
   %return
end