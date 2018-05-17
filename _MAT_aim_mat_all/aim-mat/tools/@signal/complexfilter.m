% method of class @signal
%   INPUT VALUES:
%   RETURN VALUE:
%       sig:  @signal 
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=complexfilter(sig,formant_fre,formant_fre_width,formant_amp)
% creates an vocal by filtering the signal (wich probably is a clicktrain)
% in different formants

nr_formants=length(formant_fre);

for i=1:nr_formants
	fre=formant_fre(i);
	wid=formant_fre_width(i);
	fsig(i)=bandpass(sig,fre-wid,fre+wid,wid/10);
% 	play(fsig(i));
end
% plot(powerspectrum(fsig(1)),[10,13000],'b')
% hold on
% plot(powerspectrum(fsig(2)),[10,13000],'r')
% plot(powerspectrum(fsig(3)),[10,13000],'g')
% plot(powerspectrum(fsig(4)),[10,13000],'c')

sumsig=fsig(1)*formant_amp(1);
for i=2:nr_formants
	sumsig=sumsig+fsig(i)*formant_amp(i);
end
% plot(powerspectrum(sumsig),[10,13000],'k')
sig=sumsig;
