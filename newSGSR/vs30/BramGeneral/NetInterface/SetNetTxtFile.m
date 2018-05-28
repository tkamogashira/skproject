function SetNetTxtFile(varargin)
%SETNETTXTFILE write textfile over network
%   SETNETTXTFILE(URL, s) writes character string s to textfile specified by its URL.
%   SETNETTXTFILE(CompName, Dir, FileName, s) writes character string s to textfile specified by name of computer, 
%   shared directory and filename.
%
%   Attention! This version of the network-interface uses mapped network drives instead of a directly exploiting
%   the network facilities. So the name of the computer which you are referring to in the LAN should be the drive 
%   letter that is associated with the computer. (Using the JAVA API will overcome this minor problem in the
%   future)
%
%   See also GETNETTXTFILE, COPYNETFILE, PROBENETFILE

%B. Van de Sande 18-07-2003

%Parsing parameters ...
switch nargin,
case 2, %URL opgegeven ...    
    URL = parseURL(varargin{1});
    if ~strcmpi(URL.Protocol, 'file'), error('Protocol should be ''file''.'); end
    [CompName, Dir, FileName] = deal([URL.CompName ':'], URL.Dir, URL.FileName);    
    s = varargin{2};
case 4, %Server, folder en bestandsnaam apart opgegeven ...
    [CompName, Dir, FileName] = deal(varargin{:});
    [CompName, Dir] = deal(fileparts(CompName), fileparts(Dir)); %Verwijderen van eventueel afsluitende slash ...
    s = varargin{4};
otherwise, error('Wrong number of input arguments.'); end
if ~ischar(s), error('Wrong input arguments.'); end 

if ~isempty(ProbeNetFile(CompName, Dir, FileName)), error('File already exists.'); end
FN = [CompName '\' Dir '\' FileName];

%Writing textfile ...
fid = fopen(FN, 'wt'); if fid < 0, error(sprintf('Cannot open network file %s.', FN)); end
fprintf(fid, '%s', s);
fclose(fid);