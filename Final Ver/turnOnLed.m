function turnOnLed(a, x)
if(x=='red')
    writePWMDutyCycle(a, 'D44', 1); % Turn on Red
elseif(x=='blu')
    writePWMDutyCycle(a, 'D45', 1); % Turn on blue
elseif(x=='yel')
    writePWMDutyCycle(a, 'D46', 1); % Turn on green
end
end