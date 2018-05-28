function ph=delayPhase(ph, freq, delay, unwrapCoef);
% delayPhase - delay Phase(freq) data
%  usage: ph=delayPhase(ph, freq, delay, unwrapCoef);
%  ph in cycles, freq*delay in cycles too.
%  unwrapCoef values:
%    -2  unwrap before imposing the delay and add int#cycles towards zero
%    -1  unwrap before imposing the delay
%     0  do not unwrap (default)
%     1  unwrap after imposing the delay 
%     2  unwrap after imposing the delay  and add int#cycles towards zero
%  By convention, positive delays cause phase increments.

if nargin<4, unwrapCoef=0; end;

if unwrapCoef<0,
   ph = unwrap(2*pi*ph)/2/pi;
   if unwrapCoef==-2,
      ph = ph - round(mean(ph));
   end
end
ph = ph+freq*delay;
if unwrapCoef>0,
   ph = unwrap(2*pi*ph)/2/pi;
   if unwrapCoef==2,
      ph = ph - round(mean(ph));
   end
end
