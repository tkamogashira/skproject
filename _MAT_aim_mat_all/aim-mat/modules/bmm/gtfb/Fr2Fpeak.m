% support file for 'aim-mat'
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



%
%    Estimate fr from fpeak 
%    Toshio IRINO
%    10 June 98
%
% function [fpeak, ERBw] = Fr2Fpeak(n,b,c,fr)
%    INPUT:  n,b,c : gammachirp param.
%            fr    : fr
%    OUTPUT: fpeak : peak freq.
%            ERBw  : ERBw(fr)
%
function [fpeak, ERBw] = Fr2Fpeak(n,b,c,fr)

if nargin < 4, help Fr2Fpeak; end;

n = n(:);
b = b(:);
c = c(:);
fr = fr(:);

[dummy ERBw] = Freq2ERB(fr);
fpeak = fr + c.*ERBw.*b./n;
