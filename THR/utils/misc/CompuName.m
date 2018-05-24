function Name = CompuName(varargin);
% COMPUNAME - name of computer, if known
%   COMPUNAME returns a character string containing the name of
%   the computer. You can set this name by SETCOMPUNAME.
%   If no name has been defined, COMPUNAME returns "??".
%
%   Note: these names are meaningful only within EARLY.
%
%   See also SETCOMPUNAME, WHERE.


FileName = fullfile(prefdir(1), 'computerID.EARLY'); % setup file must be kept outside EARLY dirs
if nargin<1, % regular call, see help
    Name = myflag('Compuname___'); % try to retrieve from persistent flag (no file I/O)
    if isempty(Name),
        try,
            qq = load(FileName, '-mat'); Name = qq.Name;
            myflag('Compuname___', Name); % store as persistent flag
        catch,
            Name = '??';
        end
    end
else, % do the work for setcompuname; error checking already done there
    if isequal('-setcompuname', varargin{1}),
        Name = varargin{2};
        save(FileName, 'Name', '-mat');
        myflag('Compuname___', Name); % store as persistent flag
    else,
        error(nargchk(1, 1, nargin));
    end
end

