function d = GUIdefaultsDir(GUIname, Flag);
% GUIdefaultsDir - folder containing default values for GUIs
%     GUIdefaultsDir returns the name of the folder in which GUI defaults
%     are stored.
%
%     GUIdefaultsDir('Foo') returns the subdirectory in which GUI defaults
%     of the GUI named Foo are stored.
%
%     GUIdefaultsDir('Foo', 'create') also creates this dir if it does not
%     exist yet.
%
%     GUIdefaultsDir('Foo\Faa', ...), etc, is also a valid syntax. Only 
%     the last subdir will be created if necessary and requested.
%
% 
%     See also SetupInfo

if nargin<1, GUIname = ''; end
if nargin<2, Flag = '---'; end

[Flag, Mess] = keywordMatch(Flag,{'create', '---'}, 'Flag input arg');
error(Mess);

persistent D

if isempty(D),
    D = fullfile(EarlyRootDir, 'GUIdefaults');
end

d = D;
if ~isempty(GUIname),
    d = fullfile(d,GUIname);
    if isequal('create', Flag) && ~exist(d,'dir'),
        [DD,NN] = fileparts(d);
        [okay,Mess] = mkdir(DD,NN);
        error(Mess);
    end
end


