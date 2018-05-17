%
%     Demonstrations for introducting auditory filters
%     Making probe tone sequence
%     Irino, T.
%     Created:  11 Mar 2010
%     Modified: 11 Mar 2010
%     Modified: 11 Jun 2010
%

   fs = 44100;   % recommended for sound()
   Tpip = 0.2;   % 200 ms;
   fp = 2000;    % 2000 Hz probe
   AmpPip = 0.2; 
   piptone = AmpPip * sin(2*pi*fp*((0:Tpip*fs-1)/fs));
   LenPip = length(piptone);
   win1 = hanning(0.02*fs)';
   LenWin1 = length(win1);
   win2 = [win1(1:LenWin1/2) ones(1,LenPip-LenWin1) win1(LenWin1/2+1:end)];
   piptone = win2.*piptone;

   NumStair = 16;
   dBstair = [0:-5:-5*(NumStair-1)];
   % disp(['Probe tone, Step number: ' int2str(NumStair)]);
   
   zz = zeros(1,LenPip);
   pipStair1 = zz;
   for ns = 1:length(dBstair)
     Amp2 =  10^(dBstair(ns)/20);
     pipStair1 = [pipStair1 Amp2*piptone zz];
   end; 

   zz = zeros(1,0.5*fs);
   pipStair = [zz pipStair1 zeros(1,2*fs) pipStair1 zz];
   %

  return
  
