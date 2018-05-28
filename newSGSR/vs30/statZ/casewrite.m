function casewrite(strmat,filename)
%CASEWRITE Writes casenames from a string matrix to a file.
%   CASEWRITE(STRMAT,FILENAME) writes a list of names to a file, one per line. 
%   FILENAME is the complete path to the desired file. If FILENAME does not
%   include directory information, the file will appear in the current directory.
%
%   CASEWRITE without inputs displays the File Open dialog box allowing
%   interactive naming of the file.

%   B.A. Jones 10-1-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.4 $  $Date: 1997/11/29 01:45:03 $

if nargin == 1
   [F,P]=uiputfile('*');
   filename = [P,F];
end
fid = fopen(filename,'w');

if fid == -1
   disp('Unable to open file.');
   return
end

if strcmp(computer,'MAC2')
   lf = setstr(13);
else
   lf = setstr(10);
end

lf = lf(ones(size(strmat,1),1),:);
lines  = [strmat lf]';

fprintf(fid,'%s',lines);
fclose(fid);
