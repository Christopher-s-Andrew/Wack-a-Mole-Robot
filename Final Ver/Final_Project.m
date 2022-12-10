% load('steroConfig.mat');
clear
%cam1 = webcam(2);
load('CameraSettings.mat');


a = arduino('COM7','Mega2560','Libraries','Adafruit\MotorShieldV2');
shield = addon(a,'Adafruit\MotorShieldV2');
m1 = dcmotor(shield,1);
m1.Speed = 0.3;

m2 = dcmotor(shield,2);
m2.Speed = 0.3;

m3 = dcmotor(shield,3);
m3.Speed = 0.3;

m4 = dcmotor(shield,4);
m4.Speed = 0.3;


m1errorLast = 0;
m1summation = 0;
% clear('cam'); % clear the cam object so you can make a new one
% cam = webcam('USB Camera'); %open m1
% the camera

m1SetPoint = 3.5400;
m2SetPoint = 2.8983;
m3SetPoint = 1.2268;

[m1SetPoint, m2SetPoint, m3SetPoint ] = ReturnHome();

%%%%%%%%%%%%%%%%%%%%% Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
configurePin(a, 'D44', 'PWM'); % Red LED Pin
configurePin(a, 'D45', 'PWM'); % Blue LED Pin
configurePin(a, 'D46', 'PWM'); % Yellow LED Pin

writePWMVoltage(a, 'D44', 5); % Set 5V to each LED
writePWMVoltage(a, 'D45', 5); % Set 5V to each LED
writePWMVoltage(a, 'D46', 5); % Set 5V to each LED

writePWMDutyCycle(a, 'D44', 1); % 75% Duty Cycle Initially to Red LED
writePWMDutyCycle(a, 'D45', 0); % 0% Duty Cycle Initially to Blue LED
writePWMDutyCycle(a, 'D46', 0); % 0% Duty Cycle Initially to Yellow LED

configurePin(a, 'D22', 'Pullup'); % Red Button Pin
configurePin(a, 'D23', 'Pullup'); % Blue Button Pin
configurePin(a, 'D24', 'Pullup'); % Yellow Button Pin

clockSignal = 0; % Alternates Color to be switched to

redOn = 1; % signals used to determine which Color Button is Active
blueOn = 0;
yellowOn = 0;
state = 0;

%%%%%%%%%%%%%%%%%%%End Init%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while( true)

% Randomizes color by consistently alternating clockSignal
	if(clockSignal == 0)
		clockSignal = 1;
	else
		clockSignal = 0;
	end

    if(redOn == 1)
        if(readDigitalPin(a, 'D22') == 0) % Red Button Pressed if True
            redOn = 0;
            turnOffLed(a, 'red');
            if(clockSignal == 0)
                blueOn = 1;
                turnOnLed(a, 'blu');
            else
                yellowOn = 1;
                turnOnLed(a, 'yel');
            end
        end
    elseif (blueOn == 1)
        if(readDigitalPin(a, 'D23') == 0) % Blue Button Pressed if True
            blueOn = 0;
            turnOffLed(a, 'blu');
            if(clockSignal == 0)
                yellowOn = 1;
                turnOnLed(a, 'yel');
            else
                redOn = 1;
                turnOnLed(a, 'red');
            end
        end
    elseif(yellowOn == 1)
        if(readDigitalPin(a, 'D24') == 0) % Yellow Button Pressed if True
            yellowOn = 0;
            turnOffLed(a, 'yel');
            if(clockSignal == 0)
                blueOn = 1;
                turnOnLed(a, 'blu');
            else
                redOn = 1;
                turnOnLed(a, 'red');
            end
        end
    end
%%

%IAMDONE = PIDfunct(a, m1, m2, m3, m4, m1SetPoint, m2SetPoint, m3SetPoint, 0)

% State Machine
switch(state)
    case 0 % color detection
        if(findBlue(cam1) == 1)
            m1SetPoint = 3.3675;
            m2SetPoint = 3.5100;
            m3SetPoint = 2.0280;

            m4SetPoint = 0;
            state = 1;
        elseif(findYellow(cam1) == 1)
            m1SetPoint = 3.6452;
            m2SetPoint = 3.4848;
            m3SetPoint = 1.8768;
            state = 1;
        elseif(findRed(cam1) == 1)
            m1SetPoint = 3.5400;
            m2SetPoint = 2.8983;
            m3SetPoint = 1.2268;
            state = 1;
        end
        
    case 1 %PID to get to button
        if(PIDfunct(a, m1, m2, m3, m4, m1SetPoint, m2SetPoint, m3SetPoint, 0) == 1)
            state = 2;
        end
    case 2 %push button
        ButtonPress(a, m3);
        state = 3;
    case 3 %update the button
        %if(readDigitalPin(a, 'D22') == 0 || readDigitalPin(a, 'D23') == 0 || readDigitalPin(a, 'D24') == 0)
            state = 4;
        %end
    case 4 %move arm up
        start(m3);
        m3.Speed = 0.5;
        pause(0.4);
        stop(m3);
        state = 5;
    case 5 %return home
       [m1SetPoint, m2SetPoint, m3SetPoint] = ReturnHome();
       b = randi(4);
            
       if(b == 1)
            turnOnLed(a, 'blu');
       elseif( b == 2)
            turnOnLed(a, 'red');
       else
            turnOnLed(a, 'yel');
       end
           
    
        state = 6;
    case 6 %PID to return home
        if(PIDfunct(a, m1, m2, m3, m4, m1SetPoint, m2SetPoint, m3SetPoint, 0) == 1)
            state = 0;
        end
end

end



