  function [PID_DONE] = PIDfunct(a, m1,m2,m3,m4, m1SetPoint, m2SetPoint, m3SetPoint, m4SetPoint)
%%%%%%%%%%%%%%%%%%%%%%%%%% ROBOT Movement %%%%%%%%%%%%%%%%%%%%%%%%%%%%
pause(0.05) %pid cycle time
m1Volt = readVoltage(a,'A11');
m2Volt = readVoltage(a, 'A12');
m3Volt = readVoltage(a, 'A13');
m4Volt = readVoltage(a, 'A14');
PID_DONE = 0;

%m1 PID%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

m1P= 7;
m1I = 0;
m1D = 0;

m1error = (m1SetPoint - m1Volt)/5;
m1PTotal = m1P * m1error;

%m1ITotal = m1I*(m1errorLast + m1error);
%m1DTotal = m1D * (m1error - m1errorLast);
%m1errorLast = m1error;
m1Speed = m1PTotal;

if (m1Speed > 1)
    m1Speed = 1;
elseif(m1Speed < -1)
    m1Speed = -1;
elseif(0 <= m1Speed && m1Speed <= 0.2)
    m1Speed = 0.2;
elseif(0 >= m1Speed && m1Speed >= -0.3)
    m1Speed = -0.3;
end

m1.Speed = m1Speed;
if(abs(m1Volt-m1SetPoint) <=0.06)
    stop(m1);
elseif(m1.IsRunning == 0)
    start(m1);
end

%m2 PID %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
m2P= 3;
m2Speed = m2P*(m2SetPoint - m2Volt)/5;

if (m1.IsRunning == 0)
    if (m2Speed > 1)
        m2Speed = 1;
    elseif(m2Speed < -1)
        m2Speed = -1;
    elseif(0 <= m2Speed && m2Speed <= 0.2)
        m2Speed = 0.2;
    elseif(0 >= m2Speed && m2Speed >= -0.2)
        m2Speed = -0.2;
    end
    
    m2.Speed = m2Speed;
    if((abs(m2Volt-m2SetPoint) <=0.06) || (m2Volt >= 4.5))
        stop(m2);
    elseif(m2.IsRunning == 0)
        start(m2);
    end
else
    if(m2.IsRunning == 1)
        stop(m2);
    end
end

%m3 PID%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
m3P=10;
m3Speed = m3P*(m3SetPoint - m3Volt)/5;
if (m1.IsRunning == 0 && m2.IsRunning == 0)
    if (m3Speed > 1)
        m3Speed = 1;
    elseif(m3Speed < -1)
        m3Speed = -1;
    end
    
    m3.Speed = m3Speed;
    if(abs(m3Volt-m3SetPoint) <=0.06)
        stop(m3);
        
    elseif(m3.IsRunning == 0)
        start(m3);
    end
end

if(abs(m3Volt-m3SetPoint) <=0.06 && (abs(m2Volt-m2SetPoint) <=0.06) && (abs(m2Volt-m2SetPoint) <=0.06))
    PID_DONE = 1;
else
    PID_DONE = 0;
end
% %m4 PID  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% % m4P= 1;
% % m1Speed = m4P*(m4SetPoint - m4Volt)/5;
% % 
% % if (m4Speed > 1)
% %     m4Speed = 1;
% % elseif(m4Speed < -1)
% %     m4Speed = -1;
% % end
% % 
% % m4.Speed = m4Speed;
% % if(abs(m4Volt-m4SetPoint) <=0.06)
% %     stop(m4);
% % elseif(m4.IsRunning == 0)
% %     start(m4);
% % end
%%%%%%%%%%%%%%%%%%%%%%%%%%% ROBOT Movement %%%%%%%%%%%%%%%%%%%%%%%%%%%%


end