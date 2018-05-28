function sd=exportdir(d);
% EXPORTDIR - get/set export directory 
%   EXPORTDIR returns export dir as char string.
%
%   EXPORTDIR('foo') sets the export directory to foo.
%
%   EXPORTDIR('factory') sets the export directory to
%   the factory default.
%
%   See also defaultdirs.

persistent SD

if isempty(SD), % set to factory default
   global DEFDIRS
   SD = [DEFDIRS.Export];
end

if nargin>0,
   if isequal('factory', lower(d)),
      global DEFDIRS
      SD = [DEFDIRS.Export];
   elseif exist(d, 'dir'), SD = d;
   else, error(['Non-existing directory ''' d '''.']);
   end
end

sd = SD;



