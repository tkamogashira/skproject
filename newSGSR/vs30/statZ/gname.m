function hh=gname(cases,line_handle)
%GNAME  Labels plotted points with their case names or case number.
%   GNAME('CASES') displays the graph window, puts up a
%   cross-hair, and waits for a mouse button or keyboard key to be
%   pressed.  Position the cross-hair with the mouse and click once
%   near each point that you want to label. When you are done,
%   press the return or enter key and the labels will appear at each 
%   point that you clicked. CASES is a string matrix. Each row of
%   CASES is the case name of a point. 
%
%   GNAME with no arguments labels each case with its case number. 
%   
%   HH = GNAME('CASES',LINE_HANDLE) returns a vector of handles
%   to the text objects on the plot. Use the scalar,LINE_HANDLE, to
%   identify the correct line if there is more than one line object 
%   on the plot.
%
%   See also TEXT, GINPUT.

%   B.A.Jones, 1-31-95.
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:35 $

[az el] = view;
if az ~= 0 | el ~= 90
   error('View must be two-dimensional.');
end

units = get(gca,'defaulttextunits');
set(gca,'defaulttextunits','data');
bmf = get(gcf,'WindowButtonMotionFcn');
bdf = get(gcf,'WindowButtonDownFcn');
set(gcf,'WindowButtonMotionFcn','');
set(gcf,'WindowButtonDownFcn','');

[x,y] = ginput;

if nargin < 2
  line_handle = findobj(gca,'type','line');
  
  if max(size(line_handle) > 1)
     error('Allows only one line handle.');
  end
end 
    
xdat = get(line_handle,'Xdata')';
xrange = diff(get(gca,'Xlim'));
ydat = get(line_handle,'Ydata')';
yrange = diff(get(gca,'Ylim'));

eval('isempty(cases);','cases=[];');
if nargin < 1 | isempty(cases)
   nobs = length(xdat);
   digits = floor(log10(nobs))+1;
   cases = (reshape(sprintf(['%',int2str(digits),'d'],(1:nobs)),digits,nobs))';
end

d = zeros(length(xdat),length(x));
for k = 1:length(x)
   xd = (xdat - x(k))/xrange;
   yd = (ydat - y(k))/yrange;
   d(:,k) = sqrt(xd.*xd + yd.*yd);
end
[junk,idx] = min(d);
h = text(x,y,cases(idx,:),'VerticalAlignment','baseline');
set(h,'units',units);

set(gca,'defaulttextunits',units);
set(gcf,'WindowButtonMotionFcn',bmf);
set(gcf,'WindowButtonDownFcn',bdf);

if nargout > 0
   hh = h;
end
