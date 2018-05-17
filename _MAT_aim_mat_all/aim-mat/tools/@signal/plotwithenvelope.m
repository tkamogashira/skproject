% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function plotwithenvelope(signal,border,stil)

h=hilbertenvelope(signal);
hh=GetData(h);
plot(hh,'b-','linewidth',1.2);hold on

if nargin==3
    plot(signal,border,stil); 
end

if nargin==2
    plot(signal,border); 
end

if nargin==1
    plot(signal); 
end




