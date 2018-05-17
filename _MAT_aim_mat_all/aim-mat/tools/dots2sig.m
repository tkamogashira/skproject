% tool
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


function sig=dots2sig(dots,nr_bins)
% usage: sig=dots2sig(dots)
% makes a signal from the dots by adding them to bins according to their octave shift
% the dots must have pitchstrength in the region from 0 to 1
% the outsignal has nr_bins points and a length of 1


if nargin < 2
    nr_bins=100;
end

sig=signal(1,nr_bins);

nr=max(size(dots));
for i=1:nr
    shift=dots{i}.octave_shift;
    old_val=gettimevalue(sig,shift);
    new_val=dots{i}.pitchstrength;
    sig=settimevalue(sig,shift,old_val+new_val);
end
