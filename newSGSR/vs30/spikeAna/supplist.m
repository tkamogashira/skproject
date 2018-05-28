function [grapeArg, comment] = supplist(iseq, varargin);
% BNlist - list of BN stimulus parameters: suppression case

global BNLIST_FN

if nargin>0,
   if ischar(iseq),
      if isequal('fn',lower(iseq)),
         BNLIST_FN = varargin{1};
         return;
      end
   end
end

if isempty(BNLIST_FN),
   fff = input('DataFile: ', 's');
   if isempty(fff), return; end
   bnlist('fn', fff);
end

if nargin<1,
   global LastGrapeArg
   iseq = LastGrapeArg;
end

if iscell(iseq), % separate cell elements
   for ii=1:length(iseq),
      isi = iseq{ii};
      if ~isnumeric(isi), continue; end; % skip 'grs()'-like stuff
      supplist(isi, varargin{:});
      disp('----------------------------------')
   end
   return
end

for ii=1:length(iseq),
   qq(ii) = emptydataset(dataset(BNLIST_FN,iseq(ii))); 
end

for ii=1:length(qq),
   ds = qq(ii);
   sp = ds.stimparam;
   fprintf(1,'%4d %24s   %5d  %d/%d/%d \n', ...
      iseq(ii), sp.TiltStr, sp.MidFreq, sp.Ncomp, sp.MeanSepa, sp.DDfreq);
end

