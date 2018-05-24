function resetRLSSystemIdentification
% Function used as callback for reset button on
% rlsfiltersystemidentification model

% Copyright 2013 The MathWorks, Inc. 

% Flip the switch whcih disables the subsystem for one step
switchVal = get_param('RLSFilterSystemIdentification/Reset Control/Switch','sw');
switchVal = ~str2double(switchVal);
set_param('RLSFilterSystemIdentification/Reset Control/Switch','sw', num2str(switchVal));

end