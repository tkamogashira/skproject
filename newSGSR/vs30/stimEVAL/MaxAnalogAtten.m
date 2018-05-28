function m=MaxAnalogAtten(hardMax);

% MaxAnalogAtten - returns maximum attenuation in dB featured by analog attenuators

global SGSR;
persistent FactMax
if nargin<1,
   hardMax=0;
end

if hardMax
   if isempty(FactMax),
      Nam = setpa4s;
      if any('4'==Nam),
         FactMax = 99.9;
      else,
         FactMax = 120;
      end
   end
   m = FactMax; 
else,
   m = SGSR.maxAtten;
end
