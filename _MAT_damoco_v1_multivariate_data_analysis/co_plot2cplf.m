function co_plot2cplf(f1,f2,pltype,fignum,xl,yl,zl1,zl2,tit)
% DAMOCO Toolbox, function CO_PLOT2CPLF, version 17.01.11
% This function plots two coupling functions in one graphic
% window.
%
%  Forms of call 
%       co_plot2cplf(f1,f2,pltype,fignum,xl,yl,zl1,zl2,tit)
%       co_plot2cplf(f1,f2,pltype,fignum)
%       co_plot2cplf(f1,f2,pltype)
%
%  Input:  f1,f2   are the functions of protophases or phases
%          pltype  determines the type of the plot:
%                  pltype=0 means that labelling of axes and plot is given
%                  by the user; this also means  that all following
%                  parameters have to be specified;
%                  pltype=1 means that f is a function of phases, the axes
%                  will be labelled accordingly; the parameters number 5-9
%                  have no effect;
%                  pltype >1 means that f is a function of protohases, the
%                  axes will be labelled accordingly; the parameters number
%                  5 - 9 have no effect.
%          fignum  is the number of the graphic window for output; if only
%                  two input parameters are specified (it works only for
%                  pltype > 0), then the new graphic window will be opened.
%
%          xl,yl   labels for x and y axes
%          zl1,zl2 labels for the vertical axes
%          tit     is the plot title
%   Last 5 parameters should be strings
%
pi2=pi+pi; ngrid=max(size(f1)); arg=0:ngrid-1; arg=arg*2*pi/(ngrid-1);
%
if nargin >3 && fignum >0   
    figure(fignum);
else
    figure();   % New graphic window, if its number is not specified in fignum
end
if pltype==1     % phase dynamics
    xl='\phi_{1}'; yl='\phi_{2}'; zl1='q_{1}(\phi_{1}, \phi_{2})';
    zl2='q_{2}(\phi_{2}, \phi_{1})';
    tit=('phase dynamics');
end
if pltype >1     % protophase dynamics
    xl='\theta_{1}'; yl='\theta_{2}'; zl1='f_{1}(\theta_{1}, \theta_{2})';
    zl2='f_{2}(\theta_{2}, \theta_{1})';
    tit=('protophase dynamics');
end
% pltype=0 then all strings must be specified in the call
subplot(1,2,1);
surf(arg,arg,f1'); axis([0 pi2 0 pi2 -inf inf]); axis square; colormap jet;
xlabel(xl); ylabel(yl); zlabel(zl1);
subplot(1,2,2);
surf(arg,arg,f2); axis([0 pi2 0 pi2 -inf inf]); axis square; colormap jet;
xlabel(xl); ylabel(yl); zlabel(zl2);
title(tit);

end
