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


function [cent,oct,relcent]=getmusicaltone(fre)
% usage: [cent,oct]=getmusicaltone(fre)
% gives back the cent of this tone and in which octave above 27.5 Hz it is
% and the relative cent above the last octave - redundant, but useful

min_fre=27.5; % the frequency, that defines the smallest frequency (A2)

oct=floor(log2(fre/min_fre));

% one octave is 1200 cent:
% f= f_min*power(2,oct)*power(2,cent/1200)

cent=1200*log2(fre/min_fre);

relcent=cent-oct*1200;
