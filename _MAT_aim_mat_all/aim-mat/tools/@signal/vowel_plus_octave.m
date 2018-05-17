% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function sig=vowel_plus_octave(sig,options,ratio)
% construct two artificial vowels with octaves in pitch. The imortant thing
% is that the random generator is reset in between, so that all random
% elements of each period is identical


seed=sum(100*clock);
rand('seed',seed);
v1=gen_vowel(sig,options);

options.do_octave=1;
rand('seed',seed);
v2=gen_vowel(sig,options);

sig=ratio*v1+(1-ratio)*v2;
sig=scaletorms(sig,0.2);

