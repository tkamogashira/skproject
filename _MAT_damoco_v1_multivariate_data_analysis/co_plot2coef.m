function co_plot2coef(F1,F2,pltype,fignum,own_lab_1,ext_lab_1,tit_1,own_lab_2,ext_lab_2,tit_2)
% DAMOCO Toolbox, function CO_PLOT2COEF, version 17.01.11
% The purpose of this function is to help you plot your results.
%
%       Forms of call 
%       co_plot2coef(F1,F2,pltype,fignum,own_lab_1,ext_lab_1,tit_1,own_lab_2,ext_lab_2,tit_2)
%       co_plot2coef(F1,F2,pltype,fignum)
%       co_plot2coef(F1,F2,pltype)
%
%
% This function can be called in 3 modes:
%                                 pltype=0      :       specify all parameters
%                                 pltype=1      :       default phase dynamics
%                                 pltype=2      :       default protophase dynamics
%
%       If co_plot2coef is called with pltype = 1 or pltype = 2, then 
%       the axes correspond to phases or protophases, respectively. 
%       Correspondingly, the absolute values of the Fourier
%       coefficients of the phase dynamics  Qcoef1_n,m and  Qcoef2_n,m.
%       or of the protophase dynamics Fcoef1_n,m  and Fcoef2_n,m are
%       plotted.
%       The axes are labeled by order of Fourier coefficients n_own
%       and m_ext, where 'own' and 'ext' correspond to the own and
%       external (proto)phases. 
%   
%       If co_plot2coef is called with pltype=0, then the axes are
%       labelled manually and all further parameters should be specified. 
%       Specification must be in string format: for example: 'phase dynamics'.
%
%       F1, F2          coefficients of two (proto)phases dynamics to be plotted
%       pltype          type of plot
%       fignum          number of the graphic window
%       own_lab_1       the label for the 'own' (proto)phase of the 1st oscillator  
%       ext_lab_1       the label for the 'external' (proto)phase of the 1st oscillator   
%       tit_1           the titel of the plot for the 1st oscillator
%       own_lab_2       the label for the 'own' (proto)phase of the 2nd oscillator  
%       ext_lab_2       the label for the 'external' (proto)phase of the 2nd oscillator   
%       tit_2           the titel of the plot of the 2nd oscillator   
or=(max(size(F1))-1)/2; 
n=-or:or;
F1(or+1,or+1)=0;         % The constant term of the coefficients is not plotted, to make the other ones visible
F2(or+1,or+1)=0;  
if nargin >3            % New graphic window, if its number is not specified in fignum
    figure(fignum);
else
    figure();
end
AF1 = abs(F1);
AF2 = abs(F2);
MAX=max(max([AF1 AF2]));
subplot(1,2,1)
imagesc(n,n, AF1); axis([-or or -or or]); axis square; colormap jet
caxis([0 MAX])
subplot(1,2,2)
imagesc(n,n, AF2); axis([-or or -or or]); axis square; colormap jet
caxis([0 MAX])
%colorbar('Southoutside')
colorbar('location','southoutside','outerposition',[0.25 0.066 0.5 0.11]);

if pltype==0         % all strings must be specified in the call
    subplot(1,2,1)
    ylabel(own_lab_1); 
    xlabel(ext_lab_1); 
    title(tit_1); 
    subplot(1,2,2)
    ylabel(own_lab_2); 
    xlabel(ext_lab_2); 
    title(tit_2);
else
    if pltype==1     % phase dynamics   
        subplot(1,2,1)
        ylabel('n (order_{own})'); 
        xlabel('m (order_{ext})');
        title('Phase dynamics: Qcoef-1_{n,m}');
        subplot(1,2,2)
        ylabel('n (order_{own})'); 
        xlabel('m (order_{ext})');
        title('Phase dynamics: Qcoef-2_{n,m}');
    else
        subplot(1,2,1)
        ylabel('n (order_{own})'); 
        xlabel('m (order_{ext})');
        title('Protophase dynamics: Fcoef-1_{n,m}');
        subplot(1,2,2)
        ylabel('n (order_{own})'); 
        xlabel('m (order_{ext})');
        title('Protophase dynamics: Fcoef-2_{n,m}');
    end
end

