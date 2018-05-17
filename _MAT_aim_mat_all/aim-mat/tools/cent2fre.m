% support file for 'aim-mat'
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function hz=cent2fre(f0,cent)
% usage: hz=cent2fre(sp,cent,oct)
% returns the frequency of a cent-note, or this frequency in another octave
% base is "A" at 27.5 Hz

hz=f0*power(2,((cent)/1200));
