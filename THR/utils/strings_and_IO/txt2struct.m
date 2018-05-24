function S = txt2struct(filename, form, delim, Nheader, multdelim)
% TXT2STRUCT - converts a text file to a struct
%   TXT2STRUCT('Foo.txt', 'format') converts delimited text file Foo.txt to 
%   a struct array. The column names are used as fieldnames. The format of
%   each column should be designated as in a call to textscan.m (e.g. '%s
%   %n %q' for 3 columns with a string, a number and a (possibly
%   double-quoted) string respectively). N indicates the number of header
%   lines.
%
%   TXT2STRUCT('Foo.txt', 'format', D, N, multdelim) also specifies the 
%   delimiter D of the file, the number of header lines N, and the option
%   to interpret repeated delimiters as a single delimiter. The defaults
%   are N=1, D = ' \b\t' (i.e. a white space), and multdelim = True. . 
%   If N>1, still only the first line is used for collecting the 
%   fieldnames. Any additional lines are skipped.
%
%   Missing numbers will be converted to NaN's. Missing strings will be
%   treated as empty strings.
%
%   See also TEXTSCAN.

if nargin<3,
    delim = ' \b\t'; % default delimiter white space
end
if nargin<4,
    Nheader = 1; % default: only single header line containing the field names
end
if nargin<5,
    multdelim = 1; % treat repeated white space characters as a single delimiter
end

% Import datafile
[fid, Mess] = fopen(filename);                              % open file
error(Mess);
ncols = numel(findstr('%', form));                          % number of columns in .txt file
txtform = repmat('%s', 1, ncols);                           % construct .txt format
txt = textscan(fid, txtform, 1, 'Delimiter', delim, 'MultipleDelimsAsOne', multdelim); % read header for fieldnames
[dat curpos] = textscan(fid, form, 'HeaderLines', Nheader, 'Delimiter', delim, 'MultipleDelimsAsOne', multdelim); % read data and get current position in file
fseek(fid,0,'eof'); endpos = ftell(fid);                    % get end position in file
fclose(fid);                                                % close file

% Check for errors in input file
if ~isequal(curpos, endpos)
    szdat1 = size(dat{1});
    error(['Error in input file on line ' num2str(szdat1(1)+Nheader) '.'])
end
% Check for valid field names
txt_peeled = [txt{:}];                                      % create field names
if ~all(cellfun(@isvarname, txt_peeled), 2)
    error('Non-valid field names present in first line of input file.')
end

% Create struct from cell array
Nentry = numel(dat{1});                                     % number of elements of struct
Nfields = numel(txt_peeled);                                % number of fields
for ifield = 1:Nfields
    D = dat{ifield};                                        % check if data is of class 'cell' or 'double'
    if strcmp(class(D), 'double')
        D = num2cell(D);                                    % if class of data is 'double', convert to 'cell'
    end
    [S(1:Nentry).(txt_peeled{ifield})] = deal(D{:});        % deal values to struct array
end


