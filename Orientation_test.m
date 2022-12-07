cam1 = webcam(1);
load('steroConfig.mat');
intrinsics = stereoParams.CameraParameters1;
I=snapshot(cam1);
I = undistortImage(I, intrinsics, OutputView="same");

tagSize = 0.015;

[id,loc,pose] = readAprilTag(I,"tagStandard41h12",intrinsics,tagSize);

worldPoints = [0 0 0; tagSize/2 0 0; 0 tagSize/2 0; 0 0 tagSize/2];

for i = 1:length(pose)
    % Get image coordinates for axes.
    imagePoints = world2img(worldPoints,pose(i),intrinsics);
    
    % Draw colored axes.
    I = insertShape(I,Line=[imagePoints(1,:) imagePoints(2,:); ...
        imagePoints(1,:) imagePoints(3,:); imagePoints(1,:) imagePoints(4,:)], ...
        Color=["red","green","blue"],LineWidth=7);

    I = insertText(I,loc(1,:,i),id(i),BoxOpacity=1,FontSize=25);
end
imshow(I)

%rotate about Z

