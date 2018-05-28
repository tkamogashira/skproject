function [data,varnames,casenames] = tblread(filename,delimiter)
%TBLREAD Retrieves tabular data from the file system.
%   [DATA, VARNAMES, CASENAMES] = TBLREAD retrieves
%   data from the file selected with interactively with variable names in
%   the first row, case names in the first column and data starting in  
%   the (2,2) position, using a space as the delimiting character.
%   [DATA, VARNAMES, CASENAMES] = TBLREAD(FILENAME) retrieves
%   data from the file named FILENAME with variable names in the first row,
%   case names in the first column and data starting in the (2,2) position, 
%   using a space as the delimiting character.
%   [DATA, VARNAMES, CASENAMES] = TBLREAD(FILENAME,DELIMITER) retrieves
%   data from a file with variable names in the first row, case names
%   in the first column and data starting in the (2,2) position. FILENAME is 
%   the complete path to the desired file.
%
%   Allowable values of DELIMITER can be any of the following:
%        ' ', '\t', ',', ';', '|' or their corresponding string name 
%        'space', 'tab', 'comma', 'semi', 'bar'; 'space' is the default. 
%   VARNAMES is a string matrix containing the variable names 
%   in the first row.
%   CASENAMES is a string matrix containing the names of each
%   case in the first column.
%   DATA is a numeric matrix with a value for each variable-case
%   pair.

%   B.A. Jones 1-4-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.12 $  $Date: 1998/08/17 22:38:36 $

% set the delimiter
if nargin < 2  
   delimiter = ' ';
else
   switch delimiter
   case {'tab', '\t'}
      delimiter = sprintf('\t');
   case {'space',' '}
      delimiter = ' ';
   case {'comma', ','}
      delimiter = ',';
   case {'semi', ';'}
      delimiter = ';';
   case {'bar', '|'}
      delimiter = '|';
   otherwise
      delimiter = delimiter(1);
      fprintf('TBLREAD does not support the specified delimiter.\n');
      fprintf('We use %c supplied by you as the delimiter.\n',delimiter(1));
      fprintf('It may produce bad result.\n');
   end
end

%%% open file
if nargin == 0
   [F,P]=uigetfile('*');
   filename = [P,F];
end
if isempty(filename)
   [F,P]=uigetfile('*');
   filename = [P,F];
end
  
fid = fopen(filename,'rt');

if fid == -1
   disp('Unable to open file.');
   return
end

lf = sprintf('\n'); % line feed is platform dependant

% now read in the data
[bigM,count] = fread(fid,Inf);
if bigM(count) ~= lf
   bigM = [bigM; lf];
end

charM = char(bigM);
charM = charM(:)';
oldM = [];
a = real(delimiter);

while ~strcmp(charM, oldM)
   oldM = charM;
   charM = strrep(charM,'  ',' ');
   charM = strrep(charM,'__','_');
   if a ~= real(sprintf('\t'))
      charM = strrep(charM,sprintf('\t\t'),sprintf('\t'));
      charM = strrep(charM,sprintf(' \t'),' ');
      charM = strrep(charM,sprintf('\t '),' ');
      charM = strrep(charM,[char(delimiter) sprintf('\t')], char(delimiter));
      charM = strrep(charM,[sprintf('\t') char(delimiter)], char(delimiter));
   else
      charM = strrep(charM,sprintf(' \t'),sprintf('\t'));
      charM = strrep(charM,sprintf('\t '),sprintf('\t'));
   end
   charM = strrep(charM,[char(delimiter) ' '], char(delimiter));
   charM = strrep(charM,[' ' char(delimiter)], char(delimiter));
end
bigM = real(charM');

% find out how many lines are there.
newlines = find(bigM == lf);

% get rid of spaces before line feed.
oldM = [];
while ~strcmp(charM, oldM)
   oldM = charM;
   b = find(bigM(newlines-1)==real(' '));
   bigM(newlines(b)-1) = [];
   newlines = find(bigM == lf);
end

% take the first line out from bigM, and put it to line1.
line1 = bigM(1:newlines(1)-1);
line1 = line1';
bigM(1:newlines(1)) = [];
newlines(1) = [];

% add a delimiter to the beginning and end of the line
if real(line1(1)) ~= a
   line1 = [delimiter, line1];
end
if real(line1(end)) ~= a
   line1 = [line1,delimiter];
end

% determine varnames
idx = find(line1==delimiter);
strlength = diff(idx)-1;
maxl = max(strlength);
nvars = length(idx)-1;
b = ' ';
varnames = repmat(b,nvars, maxl);
for k = 1:nvars;
   varnames(k,1:strlength(k)) = line1(idx(k)+1:idx(k+1)-1);
end

nobs = length(newlines);

delimitidx = find(bigM == a);

% check the size validation
if length(delimitidx) ~= nobs*nvars
   if length(delimitidx) == nobs*(nvars-1)
      varnames(1,:) = [];
      nvars = nvars-1;
   else
      error('Requires the same number of delimiters on each line.');
   end
end
if nvars > 1
   delimitidx = (reshape(delimitidx,nvars,nobs))';
end
fclose(fid);

% now we need to re-find the newlines.
newlines = find(bigM == lf);
startlines = newlines;
startlines(nobs) = [];
startlines = [0;startlines];
clength = delimitidx(:,1) - 1 - startlines;
maxlength = max(clength);
casenames = ' ';
casenames = repmat(casenames, nobs,maxlength);
data = zeros(nobs,nvars);
for k = 1:nobs
    casenames(k,1:clength(k)) = setstr((bigM(startlines(k)+1:startlines(k)+clength(k)))');
    for vars = 1:nvars
       if vars == nvars
            data(k,vars) = str2double(setstr(bigM(delimitidx(k,vars)+1:newlines(k)-1)'));
       else
            data(k,vars) = str2double(setstr(bigM(delimitidx(k,vars)+1:delimitidx(k,vars+1)-1)'));
       end
    end
end
