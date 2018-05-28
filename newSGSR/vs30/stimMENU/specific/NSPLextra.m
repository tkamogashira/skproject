function varargout = NSPLextra(enab);
% NSPLextra - enable extra, context-dependent, features of NSPL menu

hh = stimMenuHandles;
hvisi = hh.VisitorButton;

if (nargin==1) & (nargout==1), % tell if enabled
   varargout={~isequal(getstring(hvisi),'hide')};
   return;
elseif (nargin==0) & (nargout>0), % return the values
   varargout = {0, NaN, [], []};
   Rseed = round(UIdoubleFromStr(hh.RandSeedEdit, 1));
   if ~CheckNaNandInf(Rseed), return; end;
   mess = checkRealNumber(Rseed, 61^5-1);
   if ~isempty(mess), 
      UIerror(['Rseed ' mess], hh.RandSeedEdit); 
   else, 
      varargout{2} = Rseed;
      switch UIintFromToggle(hh.PolarityButton), % +|-|IPD
      case 1, pola = 1;
      case 2, pola = -1;
      case 3, pola = 0;
      end % switch/case
      if pola==0,
         IPD = diff(doubleDelay(UIdoubleFromStr(hh.IPDEdit)));  % pos -> ipsi lead
         pola = 1; 
      else,
         IPD = UIdoubleFromStr(hh.IPDEdit,1);
         if ~isequal(0,IPD),
            UIerror(strvcat('IPD must be zero if polarity', ' switch reads + or -'));
            return;
         end
      end
      varargout{3} = pola;
      if nargout>3 ,varargout{4} = IPD; end;
      varargout{1} = 1; % OK
   end
   return;
end

if ~(InLeuven | InUtrecht),
   set(hh.ExtraMenu, 'visible', 'off');
   enab = 0;
elseif nargin<1,
   enab = ~isequal(getstring(hvisi),'hide');
end

if enab,
   visi='on';
   set(hh.EnableRseedMenuItem, 'visible', 'off');
   set(hh.DisableRseedMenuItem, 'visible', 'on');
   UItoggle(hh.NoiseCharButton,'frozen');
   set(hh.NoiseCharButton, 'enable', 'inactive');
   setstring(hvisi, 'show');
else, 
   visi='off';
   set(hh.EnableRseedMenuItem, 'visible', 'on');
   set(hh.DisableRseedMenuItem, 'visible', 'off');
   if ~isequal(getstring(hh.NoiseCharButton),'running'),
      UItoggle(hh.NoiseCharButton,'frozen','running');
   end
   set(hh.NoiseCharButton, 'enable', 'on');
   setstring(hvisi, 'hide');
end

% rseed/polarity stuff for dries
NBTags = {'PolarityButton', 'PolarityPrompt', ...
      'RandSeedEdit', 'RandSeedPrompt', ...
      'DriesFrameTitle', 'DriesFrame'};
NT = length(NBTags);
for ii=NT:-1:1,
   NBtag = NBTags{ii};
   set(getfield(hh,NBtag),'visible',visi);
end

