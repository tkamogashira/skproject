function [name, allnames] = IDFstimname(Id)

% function name = IDFstimname(id);
% returns name corresponding stimulus nuber Id
% e.g., IDFstimname(12) equals 'aims'
% all names returns the names of all stimuli
% in a cell array
% Notes: Id counts from zero; if Id exceeds range of
% existing names, a warning is produced and name is
% set to '???'
% XXX "fsbt" renamed to "bfs"

persistent stimNames;

if (isempty(stimNames)) % initialize on first call
   stimNames = {'fs' 'afs' 'spl'  'aspl'  'iid' ...
         'itd' 'bb'  'fm'  'afm'  'ifs'  'aifs'  'ims' ...
		    'aims'  'fslog'  'afslog'  'bfs'  'lms' ...
          'alms'  'bms'  'cfs'  'spont'  'ctd' 'ici' ...
          'ntd' 'anspl' 'nspl' 'acspl' 'cspl' 'end' };
end
 
if ((Id<0) || (Id>=length(stimNames)))
    warning('stimulus Id exceeds range of known names');
    name = '???';
else
    name = stimNames{Id+1};
end
 
if nargout>1
    allnames = stimNames;
end
