function Str = DurString(D);
% DurString - string indicating a duration
%    DurString(Dur) returns a string indicating the duration Dur in a 
%    min:sec format. Dur is in ms.
%
%  See also DATESTR.

D = D*1e-3; % ms -> s
Nmin = floor(D/60);
Nsec = ceil(D-Nmin*60);
Str = [num2str(Nmin) ':' dec2base(Nsec,10,2)];




