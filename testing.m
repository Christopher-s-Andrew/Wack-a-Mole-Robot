%camera setup
load('steroConfig.mat');
load('cameraSingle.mat');
cam1 = webcam(1);
%cam2 = webcam(2);

image = snapshot(cam1);
imshow(image)

%[Xc, Yc, Zc] = blobFinder(cam1, cam2, stereoParams, "red")
[id, loc, pose] = aprilFinder(cam1, cameraParams);

%tag needs to be roughly parallel to camera for this to work worth a damn

%flip tag assuming X axise is aligned with robot x axies
R_x_by_Pi = [1 0 0; 0 -1 0; 0 0 -1]; 

%this is to flip the robot frame tag into the correct orientation for our
%DH stuff so we can extract angle data from the Transform
R_x_by_Pi_Over_2 = [1 0 0; 0 0 1; 0 -1 0];
%robot 0 tag to robot 0

%need to tweak this so it grabs the right tags
R_robot_0_tag_In_Cam = pose(1).Rotation;
R_robot_2_tag_In_Cam = pose(2).Rotation;
R_robot_3_tag_In_Cam = pose(3).Rotation;

%rotate so z is facing camera like it should for our DH param
R_robot_2_In_Cam = transpose(transpose(R_robot_2_tag_In_Cam)*R_x_by_Pi);
R_robot_3_In_Cam = transpose(transpose(R_robot_3_tag_In_Cam)*R_x_by_Pi);

%rotate so Robot 0 points up instead of away from the camera
R_robot_0_In_Cam = transpose(transpose(R_robot_0_tag_In_Cam)*R_x_by_Pi_Over_2);

R_robot_2_In_robot_0 = transpose(R_robot_0_In_Cam)*R_robot_2_In_Cam;
R_robot_3_In_robot_0 = transpose(R_robot_0_In_Cam)*R_robot_3_In_Cam;


q1 = atan2d(R_robot_2_In_robot_0(1,3),-R_robot_2_In_robot_0(2,3))
q2 = atan2d(R_robot_2_In_robot_0(3,1),R_robot_2_In_robot_0(3,2))

q3 = atan2d(R_robot_3_In_robot_0(3,1),R_robot_3_In_robot_0(3,2))-q2