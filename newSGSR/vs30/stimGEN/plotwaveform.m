function [t, smpls]=plotwaveform(SD,iwf,plotargs);

% plotwaveform - debug function
% function [t, smpls]=plotwaveform(SD,iwf,plotargs);

if nargin<3, plotargs='b'; end;

smpls = [];

dbn = SD.waveform{iwf}.DAdata.bufDBNs;
rep = SD.waveform{iwf}.DAdata.bufReps;
Nrepsil = SD.waveform{iwf}.DAdata.Nrepsil;
for ii=1:length(dbn),
   smpls= [smpls kron(ones(1,rep(ii)),dama2ml(dbn(ii)))];
end
smpls = [smpls zeros(1, Nrepsil)];
N = length(smpls);
dt = 1e-3*SD.waveform{iwf}.DAdata.samP;
t=linspace(0,(N-1)*dt, N);
if nargout>0, return; end;
f1;
plot(t, smpls, plotargs);
xlabel('time (ms)');