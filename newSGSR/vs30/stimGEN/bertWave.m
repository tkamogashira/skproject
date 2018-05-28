function [WF, FS, ENV] = BERTWAVE(ds);

% BERTWAVE - reconstruct waveform of BERT data
%    [Y, FS, ENV] BERTWAVE(DS), where DS is dataset object, returns the uncalibrated
%    waveform of the BERT stimulus of DS in a column vector Y.
%    FS is the sample rate in Hz.
%    ENV is the modulator waveform, i.e. the envelope with the DC component removed.

global BERTbuffer

if isa(ds, 'dataset'), 
   pp = ds.stimparam;
   ichan = ds.chan;
else, % assume the stim parameters are passed
   pp = ds;
   ichan = pp.active;
end
pp.dummy = 99; % difference from normal usage -> stim will be computed anew
[dum dum2 ENV]=prepareBERTstim(pp,0,1); % (..,0,1) = (..,do not force, no calibration)
if ichan==0, ichan=1; end; % diotic stimulus -> pick 1st channel
WF = BERTbuffer.ModTone{ichan}; 
FS = BERTbuffer.fsam;

