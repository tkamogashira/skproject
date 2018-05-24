function d = stimDefDir;
% StimDefDir - folder containing native stimulus definitions
%     StimDefDir returns the folder in which the native stimulus 
%     definitions reside. By convention, the stimulus definition for 
%     stimulus Foo is in a file names stimdefFoo in this dir. stimdefFS is 
%     the uhr example. Non-native stimuli may be added by adding one or
%     several external stimulus directories to stimdefPath and by placing
%     the stimulus definitions in those directories.
%
%     See also StimGUI, stimdefPath, stimdefFS.

persistent D

if isempty(D),
    D = fullfile(versiondir, 'StimGen', 'StimDef');
end

d = D;


