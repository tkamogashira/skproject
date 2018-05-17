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


function fsig=powerspectrum(sig,nr_fft)
% usage: sig=powerspectrum(a)
% returns a fsignal class containing the powerspectrum of the signal class a
% a should have a lenght of 2^n the result however, is one point longer!
% in the first bin is additionally the zero value
% the result is normed, so that the highest value is 0dB
% berechnet das Power Spektrum aus dem Signal a.
% die Phasen werden weggeworfen

if nargin < 2
    nr_fft=1024;
end



Fs = getsr(sig);
vals=getvalues(sig);
y=fft(vals,nr_fft);
py=y.*conj(y);
% 
% % Verlängerung des Signals um einen Punkt, damit der Nullanteil noch dabei ist
nr=round(size(py,1)/2+1); % eines mehr (der Nullanteil)


% use the powerspectrum from the toolbox
% [ppy,w]=periodogram(vals,[],'onesided',nr_fft,Fs); % only real values

% otherwise calculate it yourself:
ppy=py(1:nr)/nr*2;



%normierung auf Energie
%s=sum(abs(ppy));
%energy=s*s;
energy = sum(ppy.^2);
if energy==0
    ppy=1;
else
    ppy=ppy/energy; 
    ppy=20*log(ppy);
    ppy=ppy-max(ppy);
end

fsig=fsignal(ppy,nr); % Signal mit der richtigen Samplerate
fsig=setdf(fsig,Fs/(nr-1)/2); % kleinester Frequenzabstand

fsig=setmaxfre(fsig,Fs/2);

% sig=setsr(sig,nr); %sr bedeutet für fsignals was anderes, nämlich die Zahl der Punkte
fsig=setname(fsig,sprintf('Power Spectrum of Signal \n%s',sig.name));
fsig=setunit_x(fsig,'Frequency (Hz)');
fsig=setunit_y(fsig,'Power Spectral Density (dB/Hz)');
