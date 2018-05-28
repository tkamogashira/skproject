function [time, NTD] = apple2NTD(DF,iSeq, cdelay, maxlag);
% apple2ntd - predict noise delay function from LF zwuis data
%   sample usage: apple2NTD('C0604',{[25 28 29 32] [26 27 30 31]});
%                       datafile^    ^left seq     ^right seq
%   non-plotting usage:
%       [time, NTD] = apple2NTD(DF,iSeq, cdelay, maxlag);

if nargin<4, 
   maxlag = 10; % ms
end

setgrapefile(DF); 
AA = apple(iSeq, cdelay); delete(gcf);
ds = dataset(DF,iSeq{1}(1));
RecSide = channelchar(ds.session.RecordingSide);
NoiseEar1 = channelchar(ds.NoiseEar);
if isequal(RecSide, NoiseEar1),
   ipsi = 2; contra = 1; % noise in recording side -> zwuis in contra
else,
   ipsi = 1; contra = 2;
end
freqAxis = linspace(0,6,2^10); % in kHz
dt = 0.5/max(freqAxis); % in ms
Nfreq = length(freqAxis)
T = 2*dt*Nfreq;
for ichan=1:2,
   isig = AA(ichan).isign;
   Ncomp = length(isig);
   Fcar = AA(ichan).Fcar(isig);
   TRFamp = AA(ichan).TRFamp(isig);
   Aspec = interp1(Fcar,TRFamp, freqAxis);
   inan = isnan(Aspec);
   Aspec(inan) = -inf;
   %f2 ; xplot(Aspec,ploco(ichan))
   TRFphase = AA(ichan).TRFphase(isig);
   Phspec = interp1(Fcar,TRFphase, freqAxis);
   inan = isnan(Phspec);
   Phspec(inan) = 0;
   %xplot(freqAxis,Aspec,ploco(ichan));
   %xplot(freqAxis,Phspec,ploco(ichan));
   Cspec = db2a(Aspec).*exp(2*pi*i*Phspec);
   Cspec = [Cspec 0*Cspec];
   ImpRes(ichan,:) = fftshift(real(ifft(Cspec)));
end
% select middle part of impulse responses
Ncentral = round(3*maxlag/dt)
Nfr = size(ImpRes,2);
icentral = round(Nfr/2);
irange = icentral+Ncentral*[-1 1];
ImpRes = ImpRes(:,irange(1):irange(2));
Nmaxlag = round(maxlag/dt);
NTD = xcorr(ImpRes(ipsi,:), ImpRes(contra,:), Nmaxlag);
Nitd = length(NTD);
time = 1e3*linspace(-maxlag, maxlag, Nitd); % us
if nargout<1,
   figure;
   dplot([dt -maxlag],NTD);
   xlabel('ITD (\mus)')
end
%xdplot(dt,ImpRes(2,:),'g');










