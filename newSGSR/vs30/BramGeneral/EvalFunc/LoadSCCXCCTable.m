function SLoad = LoadSCCXCCTable(FileName, Expr)

%B. Van de Sande 27-09-2004

%Checking input arguments ...
if (nargin == 1), Expr = ''; elseif (nargin ~= 2), error('Wrong number of input arguments.'); end
if ~ischar(FileName), error('First argument should be character string with name of experiment.'); end
[Path, FileName, FileExt] = fileparts(FileName);
if isempty(Path), Path = pwd; end
if isempty(FileName), error('Invalid experiment name.'); end
if isempty(FileExt), FileExt = '.mat'; end
Pattern = lower(fullfile(Path, [FileName, '_*', FileExt]));
if ~ischar(Expr), error('Second argument should be character string with logical expression.'); end

%Actual loading of table ...
D = dir(Pattern); N = length(D); FNames = {D.name}; SLoad = [];
for n = 1:N,
    load(FNames{n}, 'S');
    if ~isempty(Expr), SLoad = [SLoad; structfilter(S, Expr)];
    else, SLoad = [SLoad; S]; end
end