function S = bnlist(iseq, varargin);
% BNlist - list of BN stimulus parameters

if nargin<1,
   global LastGrapeArg LastGrapeResult
   iseq = LastGrapeArg;
end

global BNLIST_FN
if ischar(iseq),
   if isequal('fn',lower(iseq)),
      BNLIST_FN = varargin{1};
      return;
   end
end

if isempty(BNLIST_FN),
   global SESSION
   [dum BNLIST_FN] = fileparts(SESSION.dataFile); 
end

if iscell(iseq),
   hhh = 0; S = {}; 
   for ii=1:length(iseq),
      if ischar(iseq{ii}), continue; end;
      Si = bnlist(hhh*1e6+iseq{ii}, varargin{:});
      S = {S{:} Si};
      Sep = '----------------------------------------------';
      S = {S{:} Sep};
      hhh = 1;
   end
   S = char(S);
   if nargout<1, disp(S); end;
   return;
end

NoHeader =0;
if any(iseq>1e6),
   iseq = iseq-1e6;
   NoHeader = 1;
end
% remove negative entries frome iseq list
trash = -iseq(find(iseq<0));
iseq = iseq(find(iseq>0));
iseq = setdiff(iseq,trash);

for ii=1:length(iseq),
   qq = dataset(BNLIST_FN, iseq(ii));
   dd(ii) = qq.spar;
end
for ii=1:length(iseq),
   dd(ii).i_____Seq = iseq(ii);
end

if length(varargin)>1, % select only those seqs for which selector has desired value
   sf = varargin{2};
   sval = varargin{3};
   eval(['selectVal = cat(2,dd.' sf ')']);
   dd = dd(find(selectVal==sval));
end

for ii=1:length(dd),
   spl = dd(ii).SPL;
   if size(spl,1)>1,
      dd(ii).SPL = -99;
   else,
      dd(ii).SPL = max(dd(ii).SPL);
   end
end

if length(varargin)>0,
   fn = varargin{1}; % field name indicates param used to sort
   % compile sorted list  according to last arg
   eval(['sortVal = cat(2,dd.' fn ');']);
   [SV, I] = sort(sortVal);
   dd = dd(I);
   new = [1, (diff(SV)>0)];
   comment = '';
   grapeArg = {};
   samsam = [];
   for ii=1:length(I),
      iiseq = dd(ii).i_____Seq; 
      if new(ii), 
         comment = [comment '/' num2str(sortVal(I(ii)))];
         if ~isempty(samsam),
            grapeArg = {grapeArg{:} samsam};
         end
         samsam = iiseq;
      else,
         samsam = [samsam iiseq];
      end
   end
   if ~isempty(samsam),
      grapeArg = {grapeArg{:} samsam};
   end
   comment = [fn '=' comment(2:end)];
end

NearStr = 'LRN';
S = {};
if ~NoHeader,
   S = {'iseq     freq    SPL   N/D/DD     Rseed  Tilt Near'};
end
for ii=1:length(dd),
   pp = dd(ii);
   try, iNE = pp.NoiseEar; catch, iNE = 3; end;
   try, Tilt = pp.Tilt; catch, Tilt = 0; end;
   try, NoiseSPL = pp.NoiseSPL; catch, NoiseSPL = nan; end;
   if exist('new','var'), if new(ii), disp('---------'); end; end;
   Si = sprintf('%4d: %7d  %4d   %2d/%3d/%3.1f  %4d    %d, %d, %d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,d,%d,%d,%d,%d,', ...
      round(pp.i_____Seq), round(pp.MidFreq), round(pp.SPL), pp.Ncomp, pp.MeanSepa, pp.DDfreq, ...
      pp.Rseed, Tilt, 1000+iNE, NoiseSPL);
   S = {S{:} Si};
end
S = char(S);
if nargout<1, disp(S); end;








