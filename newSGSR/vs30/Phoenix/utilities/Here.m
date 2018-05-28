function h = Here(h);
% HERE - current location
%   HERE returns a string that identifies where we are.
%   HERE('FOO') sets it to FOO.
%
%   See compuname.

if nargin>0,
   ID.here = h;
   saveFieldsInSetupFile(ID,'computerID');
else,
   qq.here = '';;
   h = getFieldsFromSetupFile(qq, 'computerID');
   h = h.here;
end




