function xp = selpos(x);
% SELPOS - select positive values from array
xp = x(find(x>0));