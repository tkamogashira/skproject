function x = cochlear_map(f, Fmax)
% INV_COCHLEAR_MAP - Convert frequency to distance along the basilar membrane
% 		     using M.C. Liberman's cochlear frequency map for the cat.
%
% Usage: x = cochlear_map(f, Fmax)
%	f		Frequency in Hz
%	Fmax	Maximum frequency represented on the basilar membrane in Hz.
%			By default, this is 57 kHz, the value for the cat.
%			Setting Fmax to 20,000 Hz gives a map appropriate for the human cochlea.
%	x		Percent distance from apex of basilar membrane
%
%	Copyright Bertrand Delgutte, 1999-2000
%
% SEE ALSO: inv_cochlear_map			

if nargin > 1,
   	f = f * inv_cochlear_map(100)/Fmax;
end

x = log10(f/456 + .8)/.021;
