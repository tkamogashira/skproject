function equalYlim(fh);
% equalYlim - equalize y-limits of subplots of figure

if nargin<1, fh=gcf; end
sh = findobj(fh, 'type', 'axes');

if length(sh)<2, return; end;
YYY = [inf -inf];
for ch=sh(:).'
   YL = get(ch, 'Ylim');
   YYY(1) = min(YYY(1), YL(1));
   YYY(2) = max(YYY(2), YL(2));
end
for ch=sh(:).'
   set(ch, 'Ylim', YYY);
end


