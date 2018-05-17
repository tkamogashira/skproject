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


function res=nicespectrum(a)

nr=getnrpoints(a);

%1. schiebe es so, dass der mittelwert 0 ist
a=settozeroaverage(a);

%2. multipliziere das Signal mit einem HanningFenster
han=hanning(nr,'periodic');
a=a*han;

% 3. powerspectrum

res=powerspectrum(a);

