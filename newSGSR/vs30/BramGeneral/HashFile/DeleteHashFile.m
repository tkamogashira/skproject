function DeleteHashFile(fileName)
%DELETEHASHFILE remove hashfile
%   DELETEHASHFILE(fileName)
% 
%   See also PUTINHASHFILE, GETFROMHASHFILE, RMFROMHASHFILE, HASHFUNCTION

% Bram

% Params ...
if ~isequal(1, nargin)
    error('Wrong number of input parameters'); 
end

if ~ischar(fileName)
    error('Argument should be filename'); 
end
[filePath, fileName, fileExt] = fileparts(fileName);
if isempty(filePath)
    filePath = pwd; 
end
if isempty(fileExt)
    fileExt = '.hash'; 
end
if isempty(fileName)
    error('Argument should be filename'); 
end
fullFileName = fullfile(filePath, [fileName, fileExt]);

%Wissen van bestand ...
if exist(fullFileName, 'file')
    delete(fullFileName);
    delete([fullFileName '__*']);
else
    warning(sprintf('%s not found', fileName)); 
end