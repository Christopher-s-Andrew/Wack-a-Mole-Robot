function [PUSH]= ButtonPress(a, motorOBJ)

start(motorOBJ);

while ~(readDigitalPin(a, 'D22') == 0 || readDigitalPin(a, 'D23') == 0 || readDigitalPin(a, 'D24') == 0)
    motorOBJ.Speed = -0.5;
    pause(0.2);
end
PUSH = 1;
turnOffLed(a, 'red');
turnOffLed(a, 'blu');
turnOffLed(a, 'yel');
motorOBJ.Speed = 0.5;
pause(1);

end