function [Fex, Dex, Fsu, Dsu, iSeq1, icell] = grapedelay(GG,mc,Nmin, Specials);
% GRAPEDELAY - compute group delay from zwuis data
%   usage: [Fex, Dex, Fsu, Dsu] = grapedelay(GG, mc, Nmin)
%   GG is grape output; mc is optional min conf; Nmin
%   is min # stim components required for estimate.
%   [Dex, Dsup] are estimated group delay in us (!) of 
%   excitation resp. suppression.
%   [Dex, Dsup] will be vectors when GG is.
%   [Fex, Fsu] are weighted frequency averages in kHz of 
%   the corresponding phase delays.
%
%   Specials: '3~b4' = divide iseq=3 into 1-4, 4-end segments
%             '5~i[1 3]' = from iseq=5, ognore components 1 and 3
%             '3~b4/5:i[1 3]' both of the above
%
%   Use ggtoss during grape call to exclude 
%   any components from the analysis

if nargin<1, GG = []; end;
   
if isempty(GG),
   global LastGrapeResult
   GG = LastGrapeResult;
   if isempty(GG), error('No last grape result known'); end;
end; 

if nargin<2, mc = []; end; % default: take min confidence from GG
if nargin<3, Nmin = 3; end; % default: 3
if nargin<4, Specials = ''; end; % default: no special orders
noOutput = isequal('silent', Specials);
if noOutput, Specials = ''; end;

ipiece = 0; % counting the parts over which group delays are evaluated
for ii=1:length(GG),
   [GGelems, Nelem] = localExpandSpecials(GG, ii, Specials);
   for jjj=1:Nelem,
      gg = GGelems(jjj);
      cDelay = gg.CDELAY;
      % weights: zero weights for components below minimum confidence
      if isempty(mc), MC = gg.MINCONF;
      else, MC = mc;
      end
      Wex = gg.sumex; Wex(find(Wex<MC(1))) = 0;
      Nex = sum(Wex>0); % # of significant exc components
      Wsu = gg.sumsu; Wsu(find(Wsu<MC(end))) = 0;
      Nsu = sum(Wsu>0); % # of significant sup components
      warning off; % avoid divide-by-zero complaints
      %==
      ipiece = ipiece + 1;
      Fex(ipiece) = sum(gg.Fcar.*Wex)/sum(Wex);
      Fsu(ipiece) = sum(gg.Fcar.*Wsu)/sum(Wsu);
      warning on;
      % weighted polyfit
      pex = wpolyfit(gg.Fcar, gg.exComponentPhases, Wex,1);
      if Nex<Nmin, pex = nan; end;
      psu = wpolyfit(gg.Fcar, gg.suComponentPhases, Wsu,1);
      if Nsu<Nmin, psu = nan; end;
      Dex(ipiece) = round(1000*(cDelay-pex(1)));
      Dsu(ipiece) = round(1000*(cDelay-psu(1)));
      iSeq1(ipiece) = gg.iSeq(1);
   end
end

% retrieve cell number 
dsdum = dataset(GG(1).FN, GG(1).iSeq(1));
icell = dsdum.icell;
icellStr = num2str(icell);

if ~noOutput,
   fprintf(1,'Fex%s = [', icellStr); fprintf(1, '%6.3f  ', Fex); fprintf(1,'];\n');
   fprintf(1,'Dex%s = [', icellStr); fprintf(1, '%6d  ',   Dex); fprintf(1,'];\n');
   fprintf(1,'Fsu%s = [', icellStr); fprintf(1, '%6.3f  ', Fsu); fprintf(1,'];\n');
   fprintf(1,'Dsu%s = [', icellStr); fprintf(1, '%6d  ', Dsu); fprintf(1,'];\n');
   fprintf(1,'\n');
end

%-------------------------------
function [GGelems, Nelem] = localExpandSpecials(GGelem, ii, Specials);
[GGelems, Nelem] = deal(GGelem(ii),1); % defaults
Specials = ['/' Specials '/'];
% locate special # ii
ispec = strfind(Specials, ['/' num2str(ii) '~']);
if isempty(ispec), return; end
spec = strtok(Specials(ispec+1:end),'/');
jjj = strfind(spec, '~');
spec = spec(jjj+1:end);
switch lower(spec(1)),
case 'i', % ignore certain components by setting theit weights to zero
   iignore = eval(spec(2:end));
   GGelems.sumex(iignore) = 0;
   GGelems.sumsu(iignore) = 0;
case 'b', % break in 2 parts 
   ibreak = eval(spec(2:end));
   Nelem = 2;
   GGelems(2) = GGelems(1);
   GGelems(1).sumex(ibreak+1:end) = 0;
   GGelems(1).sumsu(ibreak+1:end) = 0;
   GGelems(2).sumex(1:ibreak-1) = 0;
   GGelems(2).sumsu(1:ibreak-1) = 0;
end



