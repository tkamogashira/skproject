function S = ListZip(FileName)
%LISTZIP    list zipfile entries.
%   LISTZIP(FileName) list the entries of the supplied zipfile.
%   S = LISTZIP(FileName) returns a structure-array with contents of
%   zipfile.

%B. Van de Sande 25-04-2005

import java.text.DateFormat;
import java.util.Locale;
import java.util.Date;
import java.util.zip.ZipFile;
import java.util.zip.ZipEntry;

%-----------------------------------------------------------------------------
%Check input arguments ...
if (nargin < 1) | ~ischar(FileName), error('First argument should be name of zipfile.'); end

%Open the Zip file ...
if ~exist(FileName, 'file'), error('File ''%s'' does not exist.', FileName); end
try, zipFile = ZipFile(FileName); catch, error(sprintf('Error opening zipfile ''%s''.', FileName)); end

%Reading actual information ...
S = struct('name', '', 'date', '', 'bytes', [], 'ratio', [], 'path', ''); S(1) = []; n = 1;
dateFormat = DateFormat.getDateInstance(DateFormat.MEDIUM);
timeFormat = DateFormat.getTimeInstance(DateFormat.MEDIUM, Locale.FRANCE);
enumeration = zipFile.entries;
while enumeration.hasMoreElements,
    zipEntry = enumeration.nextElement;
    if ~zipEntry.isDirectory,
        [Path, FileName, FileExt] = fileparts(char(zipEntry.getName));
        if ~isempty(Path), Path(find(Path == '/')) = '\'; end; FileName = [FileName, FileExt];
        Size = double(zipEntry.getSize); CompressedSize = double(zipEntry.getCompressedSize);
        if (Size ~= 0), Ratio = round(100*CompressedSize/Size); else, Ratio = NaN; end
        dateObj = Date(zipEntry.getTime);
        DateStr = datestr(datenum([char(dateFormat.format(dateObj)), ' ', char(timeFormat.format(dateObj))]));
        
        [S(n).name, S(n).date, S(n).bytes, S(n).ratio, S(n).path] = deal(FileName, DateStr, Size, Ratio, Path);
        n = n + 1;
    end
end
%The returned structure-array must be a columnvector in order to avoid concatenation
%problems...
S = S(:);

%Close zipfile ...
zipFile.close;

%Display information if requested ...
if (nargout == 0), disp(cv2str(S)); clear('S'); end

%-----------------------------------------------------------------------------