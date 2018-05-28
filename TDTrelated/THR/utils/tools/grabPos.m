function grapPos(h);
% grabPos - grab position of figure and display command to position it
%    grabPos displays the position/size of the current figure and displays 
%    it in the form of a command that sets the current figure to this 
%    position/size. This is a tool for arranging multiple, non-overlapping
%    figures to the screen.
%
%    grabPos(h) uses figure handle h instead of gcf.
%
%    See also gcf, set.

if nargin<1, h = gcf; end

set(h,'units', 'normalized');
pp=get(h,'position');
pstr = trimspace(num2str(pp,3));
disp(['set(gcf,''units'', ''normalized'', ''position'', [' pstr '])']);


   
