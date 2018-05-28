function targetFN = CopyNetFile(varargin)
%COPYNETFILE get file over network
%   localFN = COPYNETFILE(URL) gets file specified by its URL and generate a local temporary file, named in localFN.
%   localFN = COPYNETFILE(CompName, Dir, FileName) gets file specified by name of computer, shared directory and
%   filename.
%
%   Attention! This version of the network-interface uses mapped network drives instead of a directly exploiting
%   the network facilities. So the name of the computer which you are referring to in the LAN should be the drive
%   letter that is associated with the computer. (Using the JAVA API will overcome this minor problem in the
%   future)
%
%   See also GETNETTXTFILE, PROBENETFILE

%B. Van de Sande 16-07-2003

%Parsing parameters ...
switch nargin
    case 1 %URL opgegeven ...
        URL = parseURL(varargin);
        if ~strcmpi(URL.protocol, 'file')
            error('Protocol should be ''file''.');
        end
        [CompName, Dir, FileName] = deal([URL.CompName ':'], URL.Dir, URL.FileName);
    case 3
        %Server, folder en bestandsnaam apart opgegeven ...
        [CompName, Dir, FileName] = deal(varargin{:});
        [CompName, Dir] = deal(fileparts(CompName), fileparts(Dir)); %Verwijderen van eventueel afsluitende slash ...
    otherwise
        error('Wrong number of input arguments.');
end

if isempty(ProbeNetFile(CompName, Dir, FileName))
    error('Requested file doesn''t exist.'); 
end
sourceFN = [CompName '\' Dir '\' FileName];
targetFN = fullfile(tmpdir, FileName);

%Downloading file to a temporary local file with same filename and extension ...
if exist(targetFN, 'file')
    warning('Local temporary file already exists and is deleted.');
    delete(targetFN);
end

%Downloading in BINARY mode and completely BUFFERING the binary file (file size must always be smaller than
%memory size) ...
source_fid = fopen(sourceFN, 'r');
if source_fid < 0
    error(['Cannot open network file ' sourceFN ' in binary mode.']); 
end
Buffer = fread(source_fid, Inf, 'uchar');
fclose(source_fid);

target_fid = fopen(targetFN, 'w');
if target_fid < 0
    error(['Cannot generate local temporary file ' targetFN]); 
end
count = fwrite(target_fid, Buffer, 'uchar');
fclose(target_fid);
if ~isequal(count, length(Buffer))
    error(['Cannot generate local temporary file ' targetFN '.'])); 
    delete(targetFN); 
end