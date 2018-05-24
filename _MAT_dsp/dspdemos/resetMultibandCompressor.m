function resetMultibandCompressor
%RESETMULTIBANDCOMPRESSOR Function callback to reset
%multibanddynamiccompression model
% The function is executed when the RESET button on the tuning GUI is
% clicked

% Copyright 2013 The MathWorks, Inc. 

% Flip the switch which disables the subsystem for one step
switchVal = get_param('multibanddynamiccompression/Reset Control/Switch','sw');
switchVal = ~str2double(switchVal);
set_param('multibanddynamiccompression/Reset Control/Switch','sw', num2str(switchVal));

end