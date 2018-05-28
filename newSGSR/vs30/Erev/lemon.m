function lemon(varargin);
% lemon - analyze BN data in terms of excitation & suppression


global LEMONGRASS
% first take defaults for LEMONGRASS fields, then overrule if other values are specified
%cdelay:  ms comp. delay (display only)
%mc:      min confidence
%mtdelay: min & max comp delays
%cpdelay: comp phase delay 
pnames = {  'cdelay'   'mc'  'mtdelay' 'cpdelay'};
defpvalues = {1.3        2    [1 4]       nan};
for ii=1:length(pnames),
   if ~isfield(LEMONGRASS, pnames{ii}),
      LEMONGRASS = setfield(LEMONGRASS, pnames{ii}, defpvalues{ii});
   end
end
%-------------------------------------------------
if nargin<1,
   disp(LEMONGRASS);
   return;
end
%-------------------------------------------------
kw = lower(varargin{1});
if ischar(kw),
   val = varargin{2};
   if ~isequal(kw, 'filename'),
      if ischar(val), val = str2num(varargin{2}); end
   end
   LEMONGRASS = setfield(LEMONGRASS, kw, val);
   disp(LEMONGRASS);
   return;
end






%------"real" call, not par setting-------------------------------------------
iSeq = varargin{1};

% local copy LEMONGRASS 
ll = LEMONGRASS;
% read data
CHS = BNhisto(ll.filename, iSeq, 'BNhisto')

% stim params we need (FI == frequency index, counting from zero)
Nspikes = CHS.CHspec(1)
df = CHS.BN.DDfreq; % minimum spacing step of components
CarFI = CHS.BN.Kfreq; % carrier freq index
meanCarFI = mean(CarFI);
BeatFI = round(meanCarFI*log(exp(-CarFI/meanCarFI).'*exp(CarFI/meanCarFI))); % matrix containing beats across all pairs of carriers
CHS.CHspec(1+abs(BeatFI)); % complex spectral  coefficients of histogram































