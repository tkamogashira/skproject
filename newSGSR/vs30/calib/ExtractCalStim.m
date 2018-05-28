function [playSig, compLim, iwf, flow, fhigh] = ExtractCalStim(CS, iband, ifilt);
% extract waveform and relevant spectral info of calibration stim
iwf = CS.bands.WaveIndex(iband, ifilt);
if iwf==1, % return all emptiness
   playSig = []; 
   compLim = [];
   iwf = [];
   flow = [];
   fhigh = [];
   return; 
end;

DF = CS.bands.DF(ifilt);
nshift = CS.bands.iLow(iband,ifilt)-2;
fsam = CS.params.SampleFreqs(ifilt);
wf = CS.WavePool(iwf).WaveForm; % un-heterodyned, complex waveform
nsam = length(wf);

omega = 2*pi*i*nshift*DF/fsam; % angular freq of heterodyner
playSig = real(exp(omega*(0:nsam-1)').*wf);
ncomp = CS.bands.Ncomp(iband,ifilt);
compLim = nshift+1+[1 ncomp];

% border freqs in Hz
flow = (compLim(1)-1)*DF;
fhigh = (compLim(2)-1)*DF;
