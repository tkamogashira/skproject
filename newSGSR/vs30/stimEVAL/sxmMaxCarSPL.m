function maxSPL = sxmMaxCarSPL(modfreq, carfreq, moddepth, Chan);

% function maxSPL = sxmMaxSPL(modfreq, carfreq, moddepth);
% vs 05 and higher

if nargin<4, errordlg('No channel specified','error in sxmMaxCarSpl'); 
   return;
end;

% assume car SPL of zero
hifreq = carfreq+abs(modfreq);
lofreq = carfreq-abs(modfreq);

[dd ifilt] = safeSamplefreq(max(hifreq));

sideSPL = a2db(1e-2*moddepth);

loLevel = sideSPL + calibrate(lofreq, ifilt, Chan);
carLevel = 0 + calibrate(carfreq, ifilt, Chan);
hiLevel = sideSPL + calibrate(hifreq, ifilt, Chan);

% peak amplitudes
sq2 = 2^0.5;
loAmp = sq2*db2a(loLevel);
carAmp = sq2*db2a(carLevel);
hiAmp = sq2*db2a(hiLevel);
totAmp = loAmp+carAmp+hiAmp;
% how much can we amplify this peak ampl until it hits
% the D/A limit? Since we started with zero-dB carrier SPL,
% this outcome is equal to the max car SPL
maxSPL = a2db(maxMagDA./(totAmp+1e-20));

