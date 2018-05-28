function fixledcontrol(s);
% FixLEDconrol - control behavior of fixation LED
%   FixLEDcontrol(1) turns the LED on continuously (default)
%   FixLEDcontrol(2) turns the LED off when a switch is pressed (Din3 on RP2_2)

if nargin < 1,
    s = 1;
end
Dev = 'RP2_2';

if s == 1
    sys3setpar(1, 'FixLEDon', Dev);
elseif s == 2 
    sys3setpar(0, 'FixLEDon', Dev);
else 
    disp('Wrong input argument, choose 1 or 2');
    return;
end


    