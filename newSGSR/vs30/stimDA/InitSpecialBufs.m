function y=initspecialbufs;
% prepares special buffers: silences and sync pulse.
% These buffers are directly pushed to DAMA.
% Info is stored in globals GLBsilence and GLBsync

global SGSR GLBsilence GLBsync;
   

Nlarge = 100; % # samples in "large" silence buffers
GLBsilence = struct(...
   'Nlarge', Nlarge,...
   'large',  ML2dama(zeros(2,Nlarge)),...
   'small',  ML2dama(zeros(2,1))...
   );

Nsync = 10; % # samples in sync buffer
% generate sync samples. Note: at least 3 preceding zeros needed
% because PD1 misses them (see PD1 Manual: bugs & anomalies)
syncBuf = zeros(1, Nsync); 
if inLeuven,
   Nhigh = SGSR.TTLwidth;
else,
   Nhigh = 1;
end
ineg = Nsync-Nhigh; % index of negative phase of pulse
ipos = Nsync-Nhigh+1:Nsync; % indices of positive phase of pulse
syncBuf(ineg) = -SGSR.TTLamplitude; % neg phase of sync pulse precedes pos phase
syncBuf(ipos) = SGSR.TTLamplitude; % last one is pos phase of sync pulse
GLBsync = struct(...
   'Nsync',   Nsync,...
   'DBN',     ML2dama(syncBuf)...   
	);   
