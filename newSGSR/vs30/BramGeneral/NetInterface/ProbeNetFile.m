function [LastModified, Bytes] = ProbeNetFile(varargin)
%PROBENETFILE probe file over network
%   [LastModified, Bytes] = PROBENETFILE(URL) probes file specified by its URL. Probing includes checking if the
%   file exists and when this is the case returning the date and time when it was last modified and the file size
%   in bytes. 
%   [LastModified, Bytes] = PROBENETFILE(CompName, Dir, FileName) probes file specified by name of computer, shared 
%   directory and filename.
%
%   Attention! This version of the network-interface uses mapped network drives instead of a directly exploiting
%   the network facilities. So the name of the computer which you are referring to in the LAN should be the drive 
%   letter that is associated with the computer. (Using the JAVA API will overcome this minor problem in the
%   future)
%
%   See also GETNETTXTFILE, COPYNETFILE

%B. Van de Sande 16-07-2003

%Parsing parameters ...
switch nargin,
case 1, %URL opgegeven ...    
    URL = parseURL(varargin{1});
    if ~strcmpi(URL.Protocol, 'file'), error('Protocol should be ''file''.'); end
    [CompName, Dir, FileName] = deal([URL.CompName ':'], URL.Dir, URL.FileName);    
case 3, %Server, folder en bestandsnaam apart opgegeven ...
    [CompName, Dir, FileName] = deal(varargin{:});
    [CompName, Dir] = deal(rmSlash(CompName), rmSlash(Dir)); %Verwijderen van eventueel afsluitende slash ...
otherwise, error('Wrong number of input arguments.'); end

%Probing file over network ...
FullFileName = [CompName '\' Dir '\' FileName];
if exist(FullFileName, 'file'),
    S = dir(FullFileName);
    [LastModified, Bytes] = deal(datenum(S.date, 0), S.bytes);
else, [LastModified, Bytes] = deal([]); end

%------------------------------------------------lokale functies--------------------------------------------
function s = rmSlash(s)

if s(end) == '\', s(end) = []; end