function ph=delayPhase(ph, freq, delay, unwrapCoef);
% delayPhase - delay Phase-versus-frequency data
%   delayPhase(PH, Freq, delay, unwrapCoef) returns the delayed phase
%   values, i.e., PH with a linear phase equal to freq.*delay added.
%   Input args:
%         PH: phase in cycles
%       Freq: frequency in Hz (or kHz, see next arg)
%      Delay: delay in S (or ms; in each case must Freq.*Delay be in Cyles)
% unwrapCoef: value indicating how to handle unwrapping. Potential values
%             of unwrapCoef are:
%         -2  unwrap before imposing the delay and add int#cycles towards zero
%         -1  unwrap before imposing the delay
%          0  do not unwrap (default)
%          1  unwrap after imposing the delay 
%          2  unwrap after imposing the delay  and add int#cycles towards zero
%  By convention, positive delays cause phase increments.
%
%  See also cunwrap.

if nargin<4, unwrapCoef=0; end;

if unwrapCoef<0,
   ph = cunwrap(ph);
   if unwrapCoef==-2,
      ph = ph - samesize(round(mean(ph)),ph);
   end
end
ph = ph+freq.*delay;
if unwrapCoef>0,
   ph = cunwrap(ph);
   if unwrapCoef==2,
      ph = ph - samesize(round(nanmean(ph)),ph);
   end
end

