function FARM2RAP(FN, dsID, sdir);
% FARM2RAP - converts sequence of idf/spk datafile to rap format
%   FARM2RAP(FN, dsID, sdir) converts dataset dsID from filename FN 
%   to RAP format. The converted data are written to directory sdir.
%   Default sdir is the current dir.
%   
%   Example:
%     farm2rap('D0121','6-4', 'C:\data');
%
%   This results in the converted data being written to file
%   named: C:\data\D0121-6-4-SPL.rap.

if nargin<3,
   sdir = cd;
end

if ~isequal(7,exist(sdir)),
   error(['Nonexisting directory ''' sdir '''.']);
end

[nseq, isOld] = id2iseq(FN,dsID,1);
if ~isOld,
   warning('Non-Farmington data. ');
   return
end
fullID = id2iseq,
fullName = [sdir '\' fullID '.rap'],

[rapHeader rfileName xname vchan]= IDF2rapheadernewStyle(FN,nseq, fullID);
if isempty(rapHeader), return; end;
rapHeader = strvcat(rapHeader, ' '); % empty line
endline =  '--------------------------------------------';

fid = fopen(fullName, 'wt');

textwrite(fid, rapHeader);
spikesToRap(FN,nseq, vchan, xname, 'NONE', fid);
textwrite(fid, endline);

fclose(fid);