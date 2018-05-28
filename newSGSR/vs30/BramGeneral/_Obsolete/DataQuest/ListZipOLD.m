function S = ListZip(FileName, varargin)
%LISTZIP    list zipfile entries.
%   LISTZIP(FileName) list the entries of the supplied zipfile.
%   S = LISTZIP(FileName) returns a structure-array with contents of
%   zipfile.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   Attention! This program uses the WinZip(R) Command Line Support Add-On
%   Version 1.0 (Build 3181). Other versions of this utility may not be
%   compatible with this program.

%B. Van de Sande 18-06-2004

%-------------------------------default parameters----------------------------
%Directoy where WinZip Command Line utility can be found ...
DefParam.unzipprog  = 'c:\program files\winzip\wzunzip.exe';

%-----------------------------------------------------------------------------
%Check input arguments ...
if (nargin == 1) & ischar(FileName) & strcmpi(FileName, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
elseif (nargin < 1) | ~ischar(FileName), 
    error('First argument should be name of zipfile.'); 
end
Param = checkproplist(DefParam, varargin{:});
if ~ischar(Param.unzipprog) | ~exist(Param.unzipprog, 'file'), 
    error('Cannot find WinZip® Command Line Support Add-On.'); 
end

%Arguments for the WinZip Command Line utility ...
% -vb : view the list of files in the Zip file in brief format
UnZipOpts = '-vb';
Cmd = ['"' Param.unzipprog '" ' UnZipOpts  ' ' FileName];
[Status, Str] = dos(Cmd);
if Status, error(sprintf('Couldn''t read archive ''%s''.', FileName)); end

%Skip header and ending ...
idx = find(Str == sprintf('\n')); %NewLine is line separator ...
Str = Str(idx(7)+1:idx(end-2));
%Removing backspaced information ...
idx = max(find(Str == sprintf('\b'))); Str(1:idx) = [];
%Reading actual information ...
[Size, Ratio, Month, Day, Year, Hour, Min, Names] = strread(Str, '%*d %d %d %% %d/%d/%d %d:%d %s');
NElem = length(Names);

%Reformat information ...
S = struct('name', '', 'date', '', 'bytes', [], 'ratio', [], 'path', ''); S = repmat(S, NElem, 1);
%Folder information is simply added to the name of the individual files ...
N = length(S); Path = repmat({''}, N, 1);
CA = char(Names); [R, C] = find(CA == '/'); 
if ~isempty(R),
    CA(sub2ind(size(CA), R, C)) = '\'; %Replace '/' by '\' ...
    [C, idx] = sort(C); R = R(idx); [R, idx] = unique(R); C = C(idx);
    for n = R(:)', [Path{n}, Names{n}] = deal(CA(n, 1:C(n)), deblank(CA(n, C(n)+1:end))); end
end   
[S.name] = deal(Names{:}); [S.path] = deal(Path{:});
Args = num2cell(Size); [S.bytes] = deal(Args{:});
Args = num2cell(Ratio); [S.ratio] = deal(Args{:});
Args = cellstr(datestr(datenum([Year, Month, Day, Hour, Min, zeros(NElem, 1)]))); [S.date] = deal(Args{:});

%Remove entries that contain only path information ...
idx = find(cellfun('isempty', {S.name}));
S(idx) = [];

%Display information if requested ...
if (nargout == 0), disp(cv2str(S)); clear('S'); end

%-----------------------------------------------------------------------------