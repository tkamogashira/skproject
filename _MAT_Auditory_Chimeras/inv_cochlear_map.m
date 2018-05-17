function f = inv_cochlear_map(x, Fmax)
% INV_COCHLEAR_MAP - Convert distance along the basilar membrane to frequency
% 		     using M.C. Liberman's cochlear frequency map for the cat.
%
% Usage: f = inv_cochlear_map(x, Fmax)
%	x		Percent distance from apex of basilar membrane
%	Fmax	Maximum frequency represented on the basilar membrane in Hz.
%			By default, this is 57 kHz, the value for the cat.
%			Setting Fmax to 20 kHz gives a map appropriate for the human cochlea.
%	f		Frequency in Hz
%
%	Copyright Bertrand Delgutte, 1999-2000
%
% SEE ALSO: cochlear_map			

f = 456 * 10.^(.021 *x) - 364.8;

if nargin > 1,
   	f = f * Fmax/inv_cochlear_map(100);
end
