function getImage(fileName)

cam1 = webcam(1);
cam2 = webcam(2);

snap1 = snapshot(cam1);
snap2 = snapshot(cam2);

imwrite(snap1, "C:\Users\Chris\Documents\school\UH_SEM_7\Intro to robotics\Final Project\cam1cali\" + fileName + ".png");
imwrite(snap2, "C:\Users\Chris\Documents\school\UH_SEM_7\Intro to robotics\Final Project\cam2cali\" + fileName + ".png");
end