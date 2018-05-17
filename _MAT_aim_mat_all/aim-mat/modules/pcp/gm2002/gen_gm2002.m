% generating function for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function sig=gensgm(sig,options)
% generating function for the outer/middle ear transfere function 

%waithand=waitbar(0,'generating pre cochlea processing');

samplerate=getsr(sig);
start_time=getminimumtime(sig);


firfiltercoef = ff_design(samplerate,1); %  Frontal free-field to cochlea correction
% firfiltercoef = ff_design(samplerate,2); % Diffuse-field to cochlea correction
% 		firfiltercoef = ff_design(samplerate,3); % ITU corrections for telephony.



% to compensate the huge delay from the filter, a pause is added to the
% signal, that is taken away in the end:
pause=signal(abs(options.delay_correction),samplerate);
sig=setstarttime(sig,0);
sig=append(sig,pause);

Snd=getvalues(sig);
Snd=Snd';
Snd = filter(firfiltercoef,1,Snd);

sig=setvalues(sig,Snd);

%take the delay back:
siglen=getlength(sig);
sig=getpart(sig,abs(options.delay_correction),siglen);
sig=setstarttime(sig,start_time);

%close(waithand);
