function GenSCCXCCTables(DirName)
%function that generates structure-arrays for all inclusion lists
%present in the current working directory ...

%B. Van de Sande 29-09-2004

%Checking input arguments ...
if (nargin == 0), DirName = pwd; 
elseif (nargin ~= 1), error('Wrong number of input arguments.'); end
if ~ischar(DirName), error('First argument should be character string with directory name.'); end
Pattern = lower(fullfile(DirName, '*.lst'));

%Generation of tables ...
D = dir(Pattern); FNames = {D.name}; N = length(FNames);

Props = {'limitmem', 'yes', 'maxmemsize', 50, 'tmpdir', DirName};
for n = 1:N, 
    [dummy, FileName] = fileparts(FNames{n});
    PermuteSCCXCC(FNames{n}, 'tmpfilename', FileName, Props{:});
end