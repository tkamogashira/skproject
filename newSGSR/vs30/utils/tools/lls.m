function DirList = lls(mask)
% LLS - LS with slightly intelligent, i.e., non-DOS, wildcard
if nargin<1,
   mask = '';
end
Pmask = mask;
if exist(Pmask, 'dir') % directory
   Pmask = [Pmask '\'];
elseif isempty(findstr(Pmask,'.')) % file, arbitrary extension
   if ~isempty(Pmask),
      if ~isequal(Pmask(end),'\')
         Pmask = [Pmask '.*'];
      end
   end
end

SEP = findstr(Pmask, filesep);
if isempty(SEP)
   DirStr = '';
   FileMask = Pmask;
else
   lastSlash = SEP(end);
   DirStr = Pmask(1:lastSlash);
   FileMask = Pmask((lastSlash+1):end);
end

DL = '';
qq = dir(DirStr);
for ii=1:length(qq)
   % get filename
   fn = qq(ii).name;
   % matches wildcard?
   if MatchWildCard(fn, FileMask) ...
         & ~isequal(fn,'.') & ~isequal(fn,'..') % remove pedantic '.' and '..' ls output
      DL = strvcat(DL,qq(ii).name);
   end
end

if ~isempty(DL)
   DL(:,1) = upper(DL(:,1));
   DL = sortrows(DL);
end

if nargout>0
   DirList = DL;
elseif isempty(DL)
   disp([mask ' not found.']);
else
   disp(' ');
   local_coldisp(DL);
   disp(' ');
end

%-------------------
function local_coldisp(s)
colDis = 5;
maxWidth = 88;
[N width] = size(s);
Ncol = min(1+floor(maxWidth/(width+colDis)), N);
NinCol = floor(N/Ncol);
rr = rem(N,NinCol);
s = strvcat(s,repmat(' ',rr,width));
s = [s, repmat(' ',N+rr,colDis)];
colRange = 1:NinCol;
ds = '';
for icol=1:Ncol
   offset = (icol-1)*NinCol;
   ds = [ds, s(offset+colRange,:)];
end
disp(ds);
