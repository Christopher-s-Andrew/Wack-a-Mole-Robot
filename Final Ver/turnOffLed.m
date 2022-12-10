function turnOffLed(a, x)
if(x=='red')
    writePWMDutyCycle(a, 'D44', 0); % Turn on Red
elseif(x=='blu')
    writePWMDutyCycle(a, 'D45', 0); % Turn on Red
elseif(x=='yel')
    writePWMDutyCycle(a, 'D46', 0); % Turn on Red
end
end