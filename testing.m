%camera setup
load('steroConfig.mat');
cam1 = webcam(1);
cam2 = webcam(2);


blobFinder(cam1, cam2, stereoParams, "red")
