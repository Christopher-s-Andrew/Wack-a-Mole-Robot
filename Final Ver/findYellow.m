function foundYellow = findYellow(camObj)

RGB = snapshot(camObj); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.378;
channel1Max = 0.437;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.804;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.388;
channel3Max = 0.882;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


CC = bwconncomp(sliderBW);
s = regionprops(CC,'Centroid','Area');
centroids = cat(1,s.Centroid);
areas = cat(1,s.Area);
[m,ind] = max(areas); % find the largest connected component

if m > 10
    foundYellow = 1;
else
    foundYellow = 0;
end



end