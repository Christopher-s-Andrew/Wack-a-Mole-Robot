function [id, loc, pose] = aprilFinder(camera1, stereoProprties)

    intrinsics = stereoProprties.CameraParameters1;
    
    image = snapshot(camera1);
    image = undistortImage(image, intrinsics, OutputView="same");
    
    tagSize = 0.037; %in meters
    tagFamily = ["tagStandard41h12"];
    
    [id, loc, pose] = readAprilTag(image, tagFamily, intrinsics, tagSize);
end