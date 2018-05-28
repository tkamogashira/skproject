function [Thr, Slope] = SpikeSimFun(SpontRate, Freqs, Thr, Slope);
global SpikeSim
persistent F T S maxT maxS
if nargin==0, % default stuff
   spspsp = 12;
   fff = [0  1500 2500 3000 10e3];
   ttt = [80 60   5    70    80 ];
   sss= [2 1 1 0.5 0.5]*300/40;
   SpikeSimFun(spspsp, fff, ttt, sss);
   return;
end
if nargin==4, % initialize
   SpikeSim = CollectInStruct(SpontRate);
   F = Freqs;
   T = Thr;
   S = Slope;
   maxS = max(S);
   maxT = max(T);
   return
end
if nargin==1,
   if isempty(SpontRate), SpikeSim = []; return; end; % undefine
   f = SpontRate; % 1st arg is frequency - return Thr and Slope
   Thr = min(maxT,interp1(F,T,f));
   Slope = min(maxS,interp1(F,S,f));
   return
end

