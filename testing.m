%camera setup
load('steroConfig.mat');
cam1 = webcam(1);
cam2 = webcam(2);


[Xc, Yc, Zc] = blobFinder(cam1, cam2, stereoParams, "red")
[id, loc, pose] = aprilFinder(cam1, stereoParams)