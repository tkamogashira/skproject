function [Win, SampleRange] = simpleRamp(Ntot, fsam, RampDur, RiseOrFall);
% simpleRamp - unsophisticated cos2 rise or fall ramp
Nramp = round(RampDur*1e-3*fsam); 
if isequal('rise', lower(RiseOrFall)),
   Win = sin(linspace(0,pi/2,Nramp)').^2;
   SampleRange = 1:Nramp;
else, % Fall
   Win = cos(linspace(0,pi/2,Nramp)').^2;
   SampleRange = Ntot-Nramp+1:Ntot;
end



