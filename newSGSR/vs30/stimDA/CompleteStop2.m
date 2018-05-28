function y = CompleteStop;

% CompleteStop - disconnect all devices and stop D/A 
% Used for playRec interruption

% disconnect SS1(s)
ss1switching('N',1,1);

% stop D/A and clear I/O
s232('PD1stop', 1);
s232('PD1clrIO', 1);
pause(0.1);
s232('PD1clear', 1);