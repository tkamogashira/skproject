function co_plotcplf(f,pltype,fignum,own_lab,ext_lab,zlab,tit)
% DAMOCO Toolbox, function CO_PLOTCPLF, version 17.01.11
% This function helps you to plot your results.
%
%  Forms of call 
%       co_plotcplf(f,pltype,fignum,own_lab,ext_lab,zlab,tit)
%       co_plotcplf(f,pltype,fignum)
%       co_plotcplf(f,pltype)
%
%  Input:  f       is the function of protophases or phases
%          pltype  determines the type of the plot:
%                  pltype=0 means that labelling of axes and plot is given
%                  by the user; this also means  that all following
%                  parameters have to be specified;
%                  pltype=1 means that f is a function of phases, the axes
%                  will be labelled accordingly; the parameters number 4 - 6
%                  have no effect;
%                  pltype >1 means that f is a function of protohases, the
%                  axes will be labelled accordingly; the parameters number
%                  4 - 6 have no effect.
%          fignum  is the number of the graphic window for output; if only
%                  two input parameters are specified (it works only for
%                  pltype > 0), then the new graphic window will be opened.
%
%          own_lab labels the axis, corresponing to the "own" (proto)phase
%          ext_lab labels the axis, corresponing to the "external" (proto)phase
%          z_lab   labels the vertical axis
%          tit     is the plot title
%   Last 4 parameters should be strings
%
pi2=pi+pi; ngrid=max(size(f)); arg=0:ngrid-1; arg=arg*2*pi/(ngrid-1);
%
if nargin >2        % New graphic window, if its number is not specified in fignum
    figure(fignum);
else
    figure();
end
surf(arg,arg,f); axis([0 pi2 0 pi2 -inf inf]); axis square; colormap jet;

if pltype==0         % all strings must be specified in the call
    ylabel(own_lab); xlabel(ext_lab); zlabel(zlab); title(tit);
else
    if pltype==1     % phase dynamics   
        ylabel('\phi_{own}'); xlabel('\phi_{ext}'); zlabel('q(\phi_{own}, \phi_{ext})');
        title('phase dynamics');
    else
        ylabel('\theta_{own}'); xlabel('\theta_{ext}'); zlabel('f(\theta_{own}, \theta_{ext})');
        title('protophase dynamics');
    end
end
