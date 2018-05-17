% support file for 'aim-mat'
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



%
%    Fc & Nch --> Frequencies which is equally spaced on ERB axis
%    Toshio Irino
%    8 Jan. 2003
%
%      INPUT:  FcMin : min. Fc
%              FcMax : max. Fc
%              NumCh : number of channels
%      OUTPUT: Frs: Freuqencies
%   
%
function Frs = FcNch2EqERB(FcMin, FcMax,NumCh)

if nargin < 3, help  FcNch2EqERB, end;

dERB = (Freq2ERB(FcMax)-Freq2ERB(FcMin))/(NumCh-1);
Frs =  ERB2Freq( Freq2ERB(FcMin):dERB:Freq2ERB(FcMax) );



