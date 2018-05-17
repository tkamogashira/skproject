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


function scaler=getfiltervaluehighpass(cur_fre,cutoff,dbperoctave)


%feststellen, wieviel octaven ich unter dem cutoff bin:
octs=log2(cutoff/cur_fre);

% wieviel dB sind das?
nrdB=octs*dbperoctave;

scaler=power(10,(-nrdB/20));

% gib nur die Werte > Cutoff zurück
scaler=min(1,scaler);






