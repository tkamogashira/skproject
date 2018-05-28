function [iSeq, isIDF] = ID2iseq(FN, IDstr, storeIDstr, dontPush)
% ID2iseq - convert PXJ-style ID string to sequence number and old/new style flag
persistent lastIDstr

if nargin>2
   if isequal('useLut', storeIDstr),
      [iSeq, isIDF] = localID2iseq(FN, IDstr); % new style - have to clean up old-style stuff
      return;
   end
end

if nargin==0
   iSeq = lastIDstr;
   lastIDstr = '';
   return;
end

if nargin<4
    dontPush=0;
end

FN = FullFileName(FN, datadir, 'log');
if ~exist(FN,'file')
   error(['Log file ''' FN ''' not found.']); 
end

if length(findstr(IDstr,'-'))==1
   IDstr = [IDstr '-']; % append a '-' to avoid confusing '1-14' with '1-1' etc
end
if length(findstr(IDstr,'-'))<2
   error('Not a valid ID string: IDstr must contain at least two dashes.');
end
IDline = '';
fid = fopen(FN,'rt');
idstr = ['<' IDstr];
while 1
   lin = fgetl(fid);
   if ~ischar(lin)
       break;
   end
   if ~isempty(findstr(lin,'>')),
      lin = strtok(lin,'>');
      if ~isempty(findstr(lin,idstr))
         IDline = trimspace(lin);
         break;
      end
   end
end
fclose(fid);

if isempty(IDline),
   if dontPush
       iSeq = NaN; return;
   else
       error(['ID '''  IDstr ''' not found in datafile ' FN]);
   end
end

[IDline, fullIDstr] = strtok(IDline,'<');
fullIDstr = trimspace(fullIDstr(2:end));

if nargin==3,
   lastIDstr = fullIDstr; % remember for plots etc
else
   lastIDstr = '';
end

firstParen = min(findstr(IDline,'('));
IDline = IDline(1:firstParen-1);
isIDF = isempty(findstr(IDline,'SGSR'));
lastq = max(findstr(IDline,'q'));
IDline = trimspace(IDline(lastq+1:end));
iSeq = str2num(IDline);

%===================================================
function  [iSeq, isIDF] = localID2iseq(FN, IDstr)
% modern version using LUT
if length(find(IDstr=='-'))<2
    IDstr = [IDstr '-'];
end
iSeq = nan;
lut = log2lut(FN);
ii = strmatch(IDstr, {lut.IDstr});
if isempty(ii)
    error(['ID "' IDstr '" not found in datafile "' FN '"']);
end
iSeq = lut(ii(end)).iSeq;
isIDF = (iSeq<0);
