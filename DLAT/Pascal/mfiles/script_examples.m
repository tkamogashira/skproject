% script_examples.m
%
% all the examples in the .m files
%
% 
% MAA Winter 2001  (January 20th 2001)
%----------------------------------------------------------------

% ******************************************************************
% This MATLAB software was developed by Michael A Akeroyd for 
% supporting research at the University of Connecticut
% and the University of Sussex.  It is made available
% in the hope that it may prove useful. 
% 
% Any for-profit use or redistribution is prohibited. No warranty
% is expressed or implied. All rights reserved.
% 
%    Contact address:
%      Dr Michael A Akeroyd,
%      Laboratory of Experimental Psychology, 
%      University of Sussex, 
%      Falmer, 
%      Brighton, BN1 9QG, 
%      United Kingdom.
%    email:   maa@biols.susx.ac.uk 
%    webpage: http://www.biols.susx.ac.uk/Home/Michael_Akeroyd/
%  
% ******************************************************************



wave1 = mcreatetone(500, 60, 60, 500, 0, 250, 20, 20000, 1);
wave1 = mcreatetone(500, 50, 60, 0, 0, 250, 20, 20000, 1);
wave1 = mcreatetone(500, 60, 60, 0, 90, 250, 20, 20000, 1);

leftwaveform  = sin(0:0.01:2*pi);  
rightwaveform = sin(0:0.01:2*pi);
wave1 = mwavecreate(leftwaveform, rightwaveform, 20000, 1);

wave1 = mcreatecomplextone('complextonefile1.txt', 0, 20, 20000, 1);

wave1 = mcreatenoise1(500, 400, 40, 40, 500, 0, 250, 10, 20000, 1);
wave1 = mcreatenoise1(500, 400, 40, 50, 0, 0, 250, 10, 20000, 1);
wave1 = mcreatenoise1(500, 400, 40, 40, 0, 90, 250, 10, 20000, 1);

wave1 = mcreatenoise2(300, 700, 40, 40, 500, 0, 250, 10, 20000, 1);
wave1 = mcreatenoise2(300, 700, 40, 50, 0, 0, 250, 10, 20000, 1);
wave1 = mcreatenoise2(300, 700, 40, 40, 0, 90, 250, 10, 20000, 1);

wave1 = mcreatenoise1rho(500, 400, 40, 40, 0, 250, 10, 20000, 1);
wave1 = mcreatenoise1rho(500, 400, 40, 40, -1, 250, 10, 20000, 1);
wave1 = mcreatenoise2rho(300, 700, 40, 40, 0, 250, 10, 20000, 1);
wave1 = mcreatenoise2rho(300, 700, 40, 40, -1, 250, 10, 20000, 1);

wave1 = mcreatehuggins1(600, 16, 500, 1000, 40, 40, 0, 0, 250, 10, 20000, 1);
wave1 = mcreatehuggins2(600, 16, 0, 2000, 40, 40, 0, 0, 250, 10, 20000, 1);

rho = mwavenormcorr(wave1, 1);


mwaveplot(wave1, 'stereo', -1, -1);
mwaveplot(wave1, 'left', -1, -1);
mwaveplot(wave1, 'stereo', 0, 10);
mwaveplot(wave1, 'stereo', wave1.duration_ms-10, -1);

mwaveplay(wave1, -1, 'stereo', 1);
%mwaveplay(wave1, -1, 'left', 1);
%mwaveplay(wave1, -1, 'swap', 1);
%mwaveplay(wave1, 32765, 'stereo', 1);

mwavesave('sound1.wav', wave1, -1, 'stereo', 1);
mwavesave('sound1.wav', wave1, -1, 'left', 1);
mwavesave('sound1.wav', wave1, -1, 'swap', 1);
mwavesave('sound1.wav', wave1, 32765, 'stereo', 1);


wave1 = mcreatetone(500, 60, 60, 0, 0, 250, 10, 20000, 1);
wave2 = mcreatetone(1000, 60, 60, 0, 0, 250, 10, 20000, 1);
wave3 = mwaveadd(wave1, wave2, 1);

wave1 = mcreatetone(500, 60, 60, 0, 0, 250, 10, 20000, 1);
wave2 = mcreatetone(1000, 60, 60, 0, 0, 250, 10, 20000, 1);
wave3 = mwavecat(wave1, wave2, 250, 1);

wave1 = mcreatetone(500, 60, 60, 0, 0, 250, 10, 20000, 1);
wave2 = mcreatetone(1000, 60, 60, 0, 0, 250, 10, 20000, 1);
wave3 = mwavecat(wave2, wave1, 0, 1);



f_erb = mhztoerb(500, -1, -1, 1);
[q bw] = mstandarderbparameters;
f_erb = mhztoerb(500, q, bw, 1);

f_hz = merbtohz(10.746, -1, -1, 1);
[q bw] = mstandarderbparameters;
f_hz = merbtohz(10.746, q, bw, 1);

erb = merb(500, -1, -1, 1);
[q bw] = mstandarderbparameters;
erb = merb(500, q, bw, 1);



[multichanneloutput, cfs, n, lf, hf, q, bw] = mgammatonefilterbank(47.4, 1690, 1, wave1.leftwaveform, wave1.samplefreq, 1);
[multichanneloutput, cfs, n, lf, hf, q, bw] = mgammatonefilterbank(500, 1690, 0, wave1.leftwaveform, wave1.samplefreq, 1);



cc1 = mcorrelogram(47.4, 1690, 1, -3500, 3500, 'envelope', 'cp', wave1, 2);
cc1 = mcorrelogram(47.4, 1690, 1, -3500, 3500, 'hw', 'cp', wave1, 2);
cc1 = mcorrelogram(47.4, 1690, 1, -3500, 3500, 'envelope', 's', wave1, 2);
cc1 = mcorrelogram(500, 1690, 0, -3500, 3500, 'hw', 'cp', wave1, 2);

close all;
mccgramplot4panel(cc1);
mccgramplot4panel(cc1, 10, 2);
mccgramplot4panel(cc1, 0, 0);

close all;
mccgramplot3dmesh(cc1);
mccgramplot3dsurf(cc1);
mccgramplotaverage(cc1);

close all;
mccgramplot2dsqrt(cc1);
mccgramplot2dsqrt(cc1, 10, 2);
mccgramplot2dsqrt(cc1, 0, 0);



mcallccdisplay(cc1);
msaveccdisplay('correlogram1.bcc', cc1, '#1');

[cc2 ccw] = mccgramdelayweight(cc1, 'colburn', 1);
[cc2 ccw] = mccgramfreqweight(cc1, 'stern', 1);

centroid = mccgramcentroid(cc1, 1);

peak = mccgrampeak(cc1, 'largest', 1);
peak = mccgrampeak(cc1, 'best', 1);
peak = mccgrampeak(cc1, 'best', 2);



fftmatrix = mfft1side(wave1.leftwaveform, 20000, 2048, 2);
waveform = minversefft1side(fftmatrix, 20000, 1);


% the end!
%---------------------------------------------------
