function [grapeArg, comment] = ICBNlist(iseq, varargin);
% ICBNlist - list of BN stimulus parameters: IC case

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
      icbnlist(isi, varargin{:});
      disp('----------------------------------')
   end
   return
end

for ii=1:length(iseq),
   qq(ii) = emptydataset(dataset(BNLIST_FN,iseq(ii)));
end

EEE='BLR'; % zwuis ear
for ii=1:length(qq),
   ds = qq(ii);
   sp = ds.stimparam;
   Zear = EEE(4-sp.NoiseEar);
   tlt = sp.Tilt; 
   if length(tlt)>1, tlt = 999; end
   fprintf(1,'%4d %5d  %2d/%d/%d  T%3d   %s   Z/N= %2d/%2ddB \n', ...
      iseq(ii), sp.MidFreq, sp.Ncomp, sp.MeanSepa, ...
      sp.DDfreq, tlt, Zear, round(sp.SPL(1)), round(sp.NoiseSPL));
end

