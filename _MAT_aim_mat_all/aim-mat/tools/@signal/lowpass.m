% method of class @signal
%
%   INPUT VALUES:
%
%   RETURN VALUE:
%
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function filtered_sig=lowpass(sig,frequency,stopband,ripple,stopbandatten)
% hack for an phase true lowpassfilter with cutoff at frequency
% used is a ButterworthFilter

if nargin < 5
    stopbandatten=60; % in dB - how many dB the signal is reduced in the stopband at least
end
if nargin < 4
    ripple=1; % in dB = ripple in the passband
end
if nargin <3
    stopband=frequency*2; % eine Oktave drüber
end

nyquist=getsr(sig)/2;
% fre_low=2;
fre_high=frequency;

% Finde raus, wieviel Punkte der Filter dafür haben muss
Wpass=fre_high/nyquist;
Wstop=(fre_high+stopband)/nyquist;
Wstop=min(Wstop,0.999999);
% try
    [n,Wn] = buttord(Wpass,Wstop,ripple,stopbandatten);
    % Berechne den IIR-Filter
    [b,a] = butter(n,Wn);

    vals=sig.werte';

%     % fill the part behind the signal and in front of the signal with
%     % values to avoid corner effects. this is probably not clever in all
%     % cases...
%     firstval=vals(1);
%     lastval=vals(end);
%     nr_vals=length(vals);
%     vals=[ones(1,nr_vals)*firstval vals ones(1,nr_vals)*lastval];

    nvals = filtfilt(b,a,vals);
    % extract the values back
%     nvals=nvals(nr_vals+1:2*nr_vals);

    filtered_sig=sig;	% a copy of the old one
    newname=sprintf('Lowpass filterd (%3.2fkHz) Signal: %s',frequency/1000,getname(sig));
    filtered_sig=setname(filtered_sig,newname);
    filtered_sig.werte=nvals';
% 
% catch
%     disp('error: cant do the low pass filtering');
%     filtered_sig=sig;
% end

% figure(235423)
% plot(sig);
% hold on
% plot(filtered_sig,'g');
% s=0;
