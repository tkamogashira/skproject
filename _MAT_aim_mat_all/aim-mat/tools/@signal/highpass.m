% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=highpass(sig,frequency,stopband,ripple,stopbandatten)
% hack for an phase true lowpassfilter with cutoff at frequency
% used is a ButterworthFilter

if nargin < 5
    stopbandatten=60; % in dB - how many dB the signal is reduced in the stopband at least
end
if nargin < 4
    ripple=1; % in dB = ripple in the passband
end
if nargin <3
    stopband=frequency/2; % eine Oktave drunter
end

nyquist=getsr(sig)/2;
fre_low=frequency;

% passband
wp=[fre_low/nyquist 0.98];

% stopband
ws=[(fre_low-stopband)/nyquist 0.99];

% Finde raus, wieviel Punkte der Filter dafür haben muss
[n,Wn] = buttord(wp,ws,ripple,stopbandatten);
% Berechne den IIR-Filter
[b,a] = butter(n,Wn);

% testen:
% freqz(b,a,512,getsr(sig));

vals=sig.werte;
nvals = filtfilt(b,a,vals);
sig.werte=nvals;