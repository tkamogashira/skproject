function [Fex, Dex, Fsu, Dsu, iSeq, Lprb, Lsup] = suppDelay(GG,mc,Nmin, Lprb, Lsup);
% SUPPDELAY - compute group delay from suppression zwuis data
%   usage: [Fex, Dex, Fsu, Dsu, Lprb, Lsup] = grapedelay(GG, mc, Nmin, Lprb, Lsup)
%   GG is grape output; mc is optional min conf; Nmin
%   is min # stim components required for estimate.
%   [Dex, Dsup] are estimated group delay in us (!) of 
%   excitation resp. suppression.
%   [Dex, Dsup] will be vectors when GG is.
%   [Fex, Fsu] are weighted frequency averages in kHz of 
%   the corresponding phase delays.
%
%   Use ggtoss during grape call to exclude 
%   any components from the analysis

if nargin<1, GG = []; end;
if nargin<2, mc = []; end;
if nargin<3, Nmin = 4; end;
if nargin<4, Lprb = []; end
if nargin<5, Lsup = []; end

[Fex, Dex, Fsu, Dsu, iSeq, icell] = grapedelay(GG,mc,Nmin, 'silent');

N = length(Fex);
keep = ones(1,N);

for ii=1:N,
   if ~isnan(Dsu(ii)), % true suppr
      try, % to store these results next door
         if isequal(iSeq(ii), iSeq(ii-1)), % left neighbor
            if keep(ii-1), % only store with stable neighbor
               Fsu(ii-1) = Fsu(ii);
               Dsu(ii-1) = Dsu(ii);
               keep(ii) = 0;
            end
         end
      end % try
      try, % to store these results next door - other neighbor
         if keep(ii) & isequal(iSeq(ii), iSeq(ii+1)), % right neighbor
            if keep(ii+1), % only store with stable neighbor
               Fsu(ii+1) = Fsu(ii);
               Dsu(ii+1) = Dsu(ii);
               keep(ii) = 0;
            end
         end
      end 
   end
end
% mark for deletion those elements that only contain NaNs
for ii=1:N,
   if isnan(Dex(ii)) & isnan(Dsu(ii)),
      keep(ii) = 0;
   end
end
% '===================================='
% throw away those elements that have been moved
ikeep = find(keep);
[Fex, Dex, Fsu, Dsu, iSeq] = deal(Fex(ikeep), Dex(ikeep), Fsu(ikeep), Dsu(ikeep), iSeq(ikeep));

if isempty(Lprb) | isempty(Lsup), % display parameter list so user can specify Lprb Lsup at next call to suppdelay
   supplist(iSeq);
end

if isempty(Lprb), Lprb = nan*Fex; end
if isempty(Lsup), Lsup = nan*Fex; end

icellStr = num2str(icell);
qq{1} = [sprintf('Fex%s = [', icellStr), sprintf('%6.3f  ', Fex), sprintf('];')]; 
qq{2} = [sprintf('Dex%s = [', icellStr), sprintf('%6d  ',   Dex), sprintf('];')]; 
qq{3} = [sprintf('Fsu%s = [', icellStr), sprintf('%6.3f  ', Fsu), sprintf('];')];
qq{4} = [sprintf('Dsu%s = [', icellStr), sprintf('%6d  ', Dsu), sprintf('];')];
qq{5} = [sprintf('iSeq%s= [', icellStr), sprintf('%6d  ', iSeq), sprintf('];')];
qq{6} = [sprintf('Lpr%s = [', icellStr), sprintf('%6d  ', Lprb), sprintf('];')];
qq{7} = [sprintf('Lsu%s = [', icellStr), sprintf('%6d  ', Lsup), sprintf('];')];
for ii=1:length(qq),
   evalin('caller', qq{ii}); 
   disp(qq{ii});
end
disp(' ');

% share GG with caller
if isempty(GG),
   global LastGrapeResult
   GG = LastGrapeResult;
end
global SuppDelay____global
SuppDelay____global = GG;
cmd = ['global SuppDelay____global; GG' icellStr ' = SuppDelay____global;'];
evalin('caller', cmd); 
clear global SuppDelay____global





