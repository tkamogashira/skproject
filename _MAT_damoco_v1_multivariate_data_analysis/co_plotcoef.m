function co_plotcoef(F,pltype,fignum,own_lab,ext_lab,tit)
% DAMOCO Toolbox, function CO_PLOTCOEF, version 17.01.11
% This function helps you to plot your results.
%
%  Forms of call 
%       co_plotcoef(f,pltype,fignum,own_lab,ext_lab,tit)
%       co_plotcoef(f,pltype,fignum)
%       co_plotcoef(f,pltype)
%
%  Input:  F       are Fourier coefficients of the protophase or phase
%                  dynamics
%          pltype  determines the type of the plot:
%                  pltype=0 means that labelling of axes and plot is given
%                  by the user; this also means  that all following
%                  parameters have to be specified;
%                  pltype=1 means phase dynamics, the axes will be
%                  labelled accordingly; the parameters number 4 - 6
%                  have no effect;
%                  pltype >1 means protohase dynamics, the axes will be
%                  labelled accordingly; the parameters number 4 - 6 have
%                  no effect. 
%          fignum  is the number of the graphic window for output; if only
%                  two input parameters are specified (it works only for
%                  pltype > 0), then the new graphic window will be opened.
%
%          own_lab labels the axis, corresponing to the "own" (proto)phase
%          ext_lab labels the axis, corresponing to the "external" (proto)phase
%          tit     is the ploy title
%   Last 3 parameters should be strings
%
or=(max(size(F))-1)/2;  n=-or:or;
F(or+1,or+1)=0;         % The constant term of the coefficients is not plotted, to make the other ones visible
if nargin >2            % New graphic window, if its number is not specified in fignum
    figure(fignum);
else
    figure();
end
imagesc(n,n, abs(F)); axis([-or or -or or]); axis square; colormap jet;
colorbar; 
if pltype==0         % all strings must be specified in the call
    ylabel(own_lab); 
    xlabel(ext_lab); 
    title(tit); 
else
    if pltype==1     % phase dynamics   
        ylabel('n (order_{own})'); 
        xlabel('m (order_{ext})');
        title('Coefficients of phase dynamics: Qcoef_{n,m}');
    else
        ylabel('n (order_{own})'); 
        xlabel('m (order_{ext})');
        title('Coefficients of protophase dynamics: Fcoef_{n,m}');
    end
end
end
