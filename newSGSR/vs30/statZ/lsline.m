function h = lsline
% LSLINE Add least-squares fit line to scatter plot.
%   LSLINE superimposes the least squares line on each line object
%   in the current axis (Except LineStyles '-','--','.-'.)
% 
%   H = LSLINE returns the handle to the line object(s) in H.
%   
%   See also POLYFIT, POLYVAL.   

%   B.A. Jones 2-2-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:48 $

lh = findobj(get(gca,'Children'),'Type','line');
if nargout == 1, 
   h = [];
end
count = 0;
for k = 1:length(lh)
    xdat = get(lh(k),'Xdata');
    ydat = get(lh(k),'Ydata');
    datacolor = get(lh(k),'Color');
    style = get(lh(k),'LineStyle');
    if ~strcmp(style,'-') & ~strcmp(style,'--') & ~strcmp(style,'-.')
       count = count + 1;
       beta = polyfit(xdat,ydat,1);
       newline = refline(beta);
       set(newline,'Color',datacolor);
       if nargout == 1
           h(count) = newline;    
       end
   end
end
if count == 0
   disp('No allowed line types found. Nothing done.');
end
