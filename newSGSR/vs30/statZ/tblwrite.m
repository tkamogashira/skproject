function tblwrite(data,varnames,casenames,filename,delimiter)
%TBLWRITE Writes data in tabular form to the file system.
%   TBLWRITE(DATA, VARNAMES, CASENAMES, FILENAME,DELIMITER) writes
%   a space delimited file with variable names in the first row,
%   case names in the first column and data in columns under each
%   variable name. FILENAME is the complete path to the desired file.
%   VARNAMES is a string matrix containing the variable names. 
%   CASENAMES is a string matrix containing the names of each observation.
%   DATA is a numeric matrix with a value for each variable-observation
%   pair.
%   DELIMITER can be any of the following: ' ', '\t', ',', ';', '|' or their
%   corresponding string names 'space', 'tab', 'comma', 'semi', 'bar'. If
%   it is not given, the default is set to be ' ' (space).

%   B.A. Jones 10-4-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1998/07/21 15:04:41 $

if nargin < 5
   delimiter = '   ';
else
   switch delimiter
   case {'tab', '\t'}
      delimiter = sprintf('\t');
   case 'space'
      delimiter = ' ';
   case 'comma'
      delimiter = ',';
   case 'semi'
      delimiter = ';';
   case 'bar'
      delimiter = '|';
   otherwise
      delimiter = delimiter(1);   
   end
end

ld = length(delimiter);
lc = size(casenames,2);

eval('isempty(filename);','filename=[];');
if nargin < 4 | isempty(filename)
   [F,P]=uiputfile('*');
   filename = [P,F];
end

[nobs, nvars] = size(data);

[ncasenames, maxl] = size(casenames);

for i = 1:ncasenames
   j = maxl;
   while (casenames(i,j) == ' ')
      j = j-1;
      if j == 0, break, end
   end
   if (j > 0)
      a = findstr(casenames(i,1:j), ' ');
      casenames(i,a) = '_';
   end
end

[nvarnames, maxl] = size(varnames);

for i = 1:nvarnames
   j = maxl;
   while (varnames(i,j) == ' ')
      j = j-1;
      if j == 0, break, end
   end
   if (j > 0)
      a = findstr(varnames(i,1:j), ' ');
      varnames(i,a) = '_';
   end
end
      
lv = maxl;

if nvars ~= nvarnames
   error('Requires the number of variable names to equal the number of data columns.');
end

eval('isempty(casenames);','casenames=[];');
if nargin < 3 | isempty(casenames)
   digits = floor(log10(nobs))+1;
   caseformat = ['%',int2str(digits),'d'];
   casenames = (reshape(sprintf(caseformat,(1:nobs)),digits,nobs))';
end

marker1 = delimiter(ones(nvars,1),:);

varnames = [marker1 varnames]';
varnames = varnames(:)';
marker1 = setstr(32);
marker1 = marker1(ones(1,lc));
varnames = [marker1 varnames];

if strcmp(computer,'MAC2')
   lf = setstr(13);
else
   lf = setstr(10);
end

varnames = [varnames(:)' lf];

for rows = 1:nobs
   sr = [casenames(rows,:) delimiter];
   for cols = 1:nvars
      s = num2str(data(rows,cols));
      sr = [sr s];
      if cols ~= nvars
         ps = max(0,lc+cols*(ld+lv)+ld-length(sr));
         if isequal(delimiter,'   ')
            sr = [sr delimiter(ones(1,ps))];
         else
            sr = [sr delimiter];
         end
      end
   end
   if rows == 1
      maxl = length(sr);
      l = length(sr);
      lines = sr;
   else
      blank = ' ';
      l = length(sr);
       deltal = l - maxl;
      if deltal > 0
           lines = [lines blank(ones(rows-1,1),ones(deltal,1))];
        maxl = l;
      elseif deltal < 0
         sr = [sr blank(1,ones(-deltal,1))];
      end
      lines = [lines;sr];
   end
end
lines = [lines lf(ones(nobs,1),1)];
  
fid = fopen(filename,'w');

if fid == -1
   disp('Unable to open file.');
   return
end

fprintf(fid,'%s',varnames);
fprintf(fid,'%s',lines');
fclose(fid);
