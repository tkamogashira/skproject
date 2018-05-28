function AddJavaClassPath(mfile, Force);
% AddJavaClassPath - update classpath.txt to include user-written stuff
%    AddJavaClassPath('myfile') updates the classpath.txt file to
%    include the directory that contains the file 'myfile'. 
%
%    Note 1: both classpath.txt and the directory-to-be-added (D2B+) are
%            determined using WHICH, so watch out for any shadowed versions.
%    Note 2: the classfile is only updated if the date of the D2B+ folder
%            or any the files it contains is more recent than the date of the 
%            classpath.txt file.
%    Note 3: if the classpath is indeed updated (see previous note), then
%            a warning is given that the java stuff cannot be used before
%            re-starting MatLab. This will no longer be necessary in 
%            future MatLab versions. 
% 
%    AddJavaClassPath('myfile', 'force') always adds the folder to the 
%    classpath, regardless of the condition described in Note 2 above.
%
%    The best strategy for setting classpath would be to check in any
%    mfile that uses a user-defined Java class whether the class is 
%    in the classpath. If not, that mfile should add the new directory.

if nargin<2, Force=0; end

% find folder containing mfile
NewDir = fileparts(which(mfile));
if isempty(NewDir),
   warning(['Cannot find file ''' mfile ''' in current MatLab path.']);
   return;
end
% get most recent date of NewDir or contents
fileList = dir(NewDir);
idots = strmatch('..', {fileList.name}, 'exact');
fileList(idots) = []; % remove parent dir
NewDirdate = max(datenum({fileList.date}));

% full name of classpath,txt
CPfile = which('classpath.txt');
CPdir = dir(CPfile);
CPdate = datenum(CPdir.date);

% users don't have access here; is obsolete anyway (Kevin)

%if (NewDirdate>CPdate) | Force, % need to update
%   AddLineToFile(NewDir, CPfile);
%   warning('Java classpath has been updated; restart MatLab to make new classes available.');
%end







