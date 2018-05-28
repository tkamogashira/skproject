function newDialog(FileName, Name, ShowBars);
% newDialog - create new dialog from gcf
%   newDialog(FileName, Name, Callback, ShowToolBar, ShowMenuBar);
%   defaults: ShowToolBar = ShowMenuBar = 0

if nargin<3, ShowBars = 0; end
if ischar(ShowBars), ShowBars = str2num(ShowBars); end;

global VERSIONDIR

olFN = get(gcf, 'filename');
[PP, NN, EE] = fileParts(olFN);
FileName = FullFileName(FileName, PP, '.fig');
% look if exists in path
if exist(FileName,'file'),
   error(['Named dialog already exists: ' which(FileName)]);
end

figh = gcf; % use existing fig if any
set(figh, 'filename', FileName);
set(figh, 'name', Name);
set(figh, 'numbertitle', 'off');
set(figh, 'tag', Name);
if ShowBars,
   set(figh, 'menubar', 'figure');
   set(figh, 'toolbar', 'figure');
else,
   set(figh, 'menubar', 'none');
   set(figh, 'toolbar', 'none');
end
set(figh, 'color', 0.753*[1 1 1]);

rget;





