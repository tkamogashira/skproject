% support file for 'aim-mat'
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function x=dB(y,method)
%   convert to dB representation

if nargin<2
    method='power';
end

if strcmp(method,'power')
    x=10*log(y)./log(10);
else
    x=20*log(y)./log(10);
end
