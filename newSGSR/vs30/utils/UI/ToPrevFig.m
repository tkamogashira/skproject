function ToPrevFig();
% tries to bring previous figure on figstack to the foreground

figh = get(0,'children');
if length(figh)<2, return; end;
figure(figh(2));