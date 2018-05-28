function [AnaAtten, NumAtten, OK] = LevelAdjustment(SPL, MaxSPL, maxAnaAtten, prefNumAtten); 
% LevelAdjustment - determine attenuation for optimal D/A conversion
%    usage: [AnaAtten, NumAtten, OK] = LevelAdjustment(SPL, MaxSPL, activeDA, maxAnaAtten, prefNumAtten); 
%    all iput args must be single numbers

if nargin<3, maxAnaAtten = 99.9; end
if nargin<4, prefNumAtten = 10; end % preferred num atten: 10 dB
OK = 0;


AnaAtten = maxAnaAtten; 
NumAtten = nan;
maxAnaAtten = 0.1*floor(10*maxAnaAtten); % attenuators are set im 0.1-dB steps

totalAtten = MaxSPL - SPL; % sum of num atten and ana atten must be exact
anaatt =  totalAtten - prefNumAtten;
anaatt = 0.1*round(10*anaatt); % apply 0.1-dB rounding
if anaatt<0, % relax numatten and see if level can be attained
   gain = min(prefNumAtten, -anaatt);
   gain = 0.1*ceil(10*gain);
   anaatt = anaatt + gain;
end
if anaatt>maxAnaAtten,
   anaatt = maxAnaAtten;
end
if anaatt<0,
   return;
end
AnaAtten = anaatt;
NumAtten = totalAtten - anaatt; % the total is not affected by roundings

OK = 1;



