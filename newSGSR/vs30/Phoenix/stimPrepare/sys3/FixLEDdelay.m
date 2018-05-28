function fixLEDdelay(d);
% FixLEDdelay - set delay between manual LED on and central LED off.
%   fixLEDdelay(D) sets the delay between the switch on time of any
%   manually operated LED and the switch-off time of the central fixation LED.
%   The delay is set to D ms. If D = inf, the central LED is not switched off 
%   when a "manual LED" is switched on.
%
%   Note: Use BoardLED to switch on the central LED to begin with.
%
%   See also InitBoardControl, BoardLED.

Dev = 'RP2_2';

if isinf(d), % disable switching off the FIX-LED
   sys3setpar(0, 'StinosControl', Dev);
   return;
end

if d<0,
   error('Negative delays will not be allowed.');
end

% enable switching off the FIX-LED
sys3setpar(1, 'StinosControl', Dev);
% retrieve sample freq and convert delay to # samples
Fsam = initboardLeds('fsam');
NsamDelay = round(1e-3*d*Fsam);
NsamDelay = min(1e8, NsamDelay); % avoid wrap-around errors
NsamDelay = max(1, NsamDelay); % avoid ill-defined behaviot of pulsetrain2 cmp in circuit
sys3setpar(NsamDelay, 'NsamDelay', Dev);

