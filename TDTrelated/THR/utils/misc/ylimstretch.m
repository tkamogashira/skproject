function ylimstretch(span);
% YLIMSTRETCH - symmetrical stretching of y limits to cover given span
%    ylimstretch(DY) realizes a symmtrical adjustment of the y-limits of
%    the current axis in such a way that diff(ylim) becomes DY.
%
%    See also YLIM.

YL = ylim;
M = mean(YL);
YL = YL-M;
YL = M + span*YL/diff(YL);
ylim(YL);
figure(gcf);


