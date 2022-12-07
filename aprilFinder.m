function [id, loc, pose] = aprilFinder(camera1, stereoProprties)

    intrinsics = stereoProprties.Intrinsics;
    
    image = snapshot(camera1);
    image = undistortImage(image, intrinsics);
    imshow(image)
    %tagSize = 0.015; %in meters
    tagSize = 0.025;
    tagFamily = ["tagStandard41h12"];
    
    [id, loc, pose] = readAprilTag(image, tagFamily, intrinsics, tagSize);
end