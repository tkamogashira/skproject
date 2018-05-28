function ph=ucunwrap(ph, freq, flag)
% ucunwrap - unwrap phase data expressed in cycles which are not sorted in frequency
%    ucunwrap(Ph, Freq) unwraps a phase array or matrix Ph that is 
%    expressed in cycles instead of radians, and whose elements correspond 
%    to the frequencies in array  or matrix Freq. This is useful for 
%    unwrapping of phase data that are not sorted according to frequency - 
%    and shouldn't be. Any NaNs in Ph are ignored in the unwarpping process
%    and are returned unchanged.
%
%    ucunwrap(Ph, Freq, '-tozero') also adds an integer number of cycles to
%    the phases in such a way that the average phase is in the interval
%    [-0.5 0.5].
%
%    ucunwrap(Ph, Freq, '-biased', f0, delay) performs a "biased unwrap".
%
%    See also unwrap, cunwrap, DelayPhase.

if nargin<3, flag=''; end

% store size
phSize = size(ph);
% temporarily sort ph by freq
[dum isort] = sort(freq);
ph = ph(isort);
% delegate unwrapping work to cunwrap (note: unwrap ignores NaNs)
ph = cunwrap(ph);
% unsort
ph(isort) = ph;
% reshape
ph = reshape(ph, phSize);

switch lower(flag),
    case '', % do nothing
    case '-tozero',
        ph = ph - round(mean(ph));
    otherwise,
        error(['Invalid flag ''' flag '''.']);
end



