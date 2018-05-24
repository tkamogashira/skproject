function s = slope;
% slope - estimate slope of curve using mouse clicks
%    slope calls ginput to click twice on the current figure and then
%    returns the slope dy/dx.
%
%    See also ginput.

qq = ginput(2);
xplot(qq(:,1),qq(:,2),'k');
s = diff(qq(:,2))/diff(qq(:,1));
