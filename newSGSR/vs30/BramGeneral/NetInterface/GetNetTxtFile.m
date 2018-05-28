function s = GetNetTxtFile(varargin)
%GETNETTXTFILE get textfile over network
%   s = GETNETTXTFILE(URL) gets textfile specified by its URL and returns a character string with its contents.
%   s = GETNETTXTFILE(CompName, Dir, FileName) gets textfile specified by name of computer, shared directory and
%   filename.
%
%   Attention! This version of the network-interface uses mapped network drives instead of a directly exploiting
%   the network facilities. So the name of the computer which you are referring to in the LAN should be the drive 
%   letter that is associated with the computer. (Using the JAVA API will overcome this minor problem in the
%   future)
%
%   See also COPYNETFILE, PROBENETFILE

%B. Van de Sande 16-07-2003

%Parsing parameters ...
switch nargin
    case 1 %URL opgegeven ...
        URL = parseURL(varargin{1});
        if ~strcmpi(URL.Protocol, 'file')
            error('Protocol should be ''file''.');
        end
        [CompName, Dir, FileName] = deal([URL.CompName ':'], URL.Dir, URL.FileName);
    case 3 %Server, folder en bestandsnaam apart opgegeven ...
        [CompName, Dir, FileName] = deal(varargin{:});
        [CompName, Dir] = deal(fileparts(CompName), fileparts(Dir)); %Verwijderen van eventueel afsluitende slash ..
    otherwise
        error('Wrong number of input arguments.');
end

if isempty(ProbeNetFile(CompName, Dir, FileName))
    error('Requested file doesn''t exist.'); 
end
FN = [CompName '\' Dir '\' FileName];

%Reading textfile ...
fid = fopen(FN, 'rt'); 
if fid < 0
    error(sprintf('Cannot open network file %s.', FN)); 
end
s = [];
while 1
    Line = fgetl(fid); 
    if ~ischar(Line)
        break; 
    else
        s = [s Line char(10)]; 
    end
end    
fclose(fid);