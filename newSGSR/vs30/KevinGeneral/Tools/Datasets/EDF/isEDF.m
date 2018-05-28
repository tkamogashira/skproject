function boolean = isEDF(FileName)
%ISEDF check if filename is an existing EDF datafile

%B. Van de Sande 22-04-2004

if (nargin ~= 1)
    error('Wrong number of input arguments.');
end
if ~ischar(FileName) && ~iscellstr(FileName)
    error('First and only argument should be filename.');
end

if iscellstr(FileName)
    N = numel(FileName);
    boolean = zeros(1,N);
    for n = 1:N
        boolean(n) = isEDF(FileName{n}); %Use recursion ...
    end
    boolean = reshape(boolean, size(FileName));
else
    [FullFileName, FileName, FileExt] = parseEDFFileName(FileName);
    
    %-----------------------------------NEW METHOD---------------------------------------
    %File extension is always '.DAT' for a madison datafile. No general pattern in file-
    %name, because some datafiles where created by GWE instead of RA ...
    %------------------------------------------------------------------------------------
    if strcmpi(FileExt, '.DAT') && exist(FullFileName, 'file')
        boolean = true;
    else
        boolean = false;
    end
end