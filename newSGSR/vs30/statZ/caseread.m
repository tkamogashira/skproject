function names = caseread(filename)
%CASEREAD Reads casenames from a file.
%   CASEREAD(FILENAME) returns a string matrix of names. FILENAME is 
%   the complete path to the desired file. CASEREAD expects one line per
%   case in the file.
%
%   CASEREAD without inputs displays the File Open dialog box allowing
%   interactive choice of the file.

%   B.A. Jones 2-1-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:02 $

if nargin == 0
   [F,P]=uigetfile('*');
   filename = [P,F];
end
fid = fopen(filename,'r');

if fid == -1
   disp('Unable to open file.');
   return
end

if strcmp(computer,'MAC2')
   lf = setstr(13);
else
   lf = setstr(10);
end

bigM = fread(fid,Inf);
newlines = find(bigM == lf);
nobs = length(newlines);
startlines = newlines;
startlines(nobs) = [];
startlines = [0;startlines];
clength = newlines - startlines;
maxlength = max(clength)-1;
names = ' ';
names = names(ones(nobs,1),ones(maxlength,1));
for k = 1:nobs
    names(k,1:clength(k)-1) = setstr((bigM(startlines(k)+1:startlines(k)+clength(k)-1))');
end

fclose(fid);
