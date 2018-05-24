function D = DataDir(D);
% datadir - get/set data directory
%   Datadir returns the current data directory if one exists. If none
%   exists, an error occurs.
%   
%   Datadir d:\FOO\subdir sets the data directory to d:\FOO\subdir.
%   The specified directory must exist. This setting is rembered across
%   Matlab sessions.
%
%   Note that "known experimenters" are specified by named subdirectories
%   of Datadir.
%
%   See also Experiment, KnownExperimenters, setuplist.

if nargin<1, % get
    D = fromsetupFile('localsettings', 'Datadir', '-default', 123);
    if isequal(123,D), 
        error('No datadir defined. Use Datadir to specify it.');
    end
else,  % set
    if ~isdir(D),
        error(['''' D ''' is not an existing directory.'])
    end
    ToSetupFile('localsettings', '-propval', 'Datadir', D);
    clear experiment/folder; % ugly but useful: empty cached experiment locations
end
