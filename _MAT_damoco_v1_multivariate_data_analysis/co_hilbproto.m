function [theta,minampl]= co_hilbproto(x,fignum,x0,y0,ntail)
% DAMOCO Toolbox, function CO_HILBPROTO, version 17.01.11
%
% Form of call: [theta,minampl]= co_hilbphase(x,fignum,x0,y0,ntail)
%               [theta,minampl]= co_hilbphase(x,fignum,x0,y0)
%               [theta,minampl]= co_hilbphase(x,fignum,x0)
%               [theta,minampl]= co_hilbphase(x,fignum)
%               [theta,minampl]= co_hilbphase(x)
%               theta          = co_hilbphase(...)
%
% INPUT:  x      is scalar timeseries,
%         x0,y0  are coordinates of the origin (by default x0=0, y0=0)
%         ntail  is the number of points at the ends to be cut off,
%                by default ntail=1000
% Output: theta is the protophase in 0,2pi interval
%         minamp is the minimal instantaneous amplitude over the average
%         instantaneous amplitude
%
if nargin < 5, ntail=1000; end
if nargin < 4, y0=0.0;     end
if nargin < 3, x0=0;       end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ht=hilbert(x); ht=ht(ntail+1:end-ntail);
ht=ht-mean(ht);  % subtracting the mean value    
if (nargin>1) && (fignum>0)  % plot to check whether the origin is evolved
    figure(fignum); plot(ht); hold on; plot(x0,y0,'ro'); hold off; 
    xlabel('signal'); ylabel('HT(signal)'); axis square; 
    title('Hilbert embedding');
end
ht=ht-x0-1i*y0;    theta=angle(ht); ampl=abs(ht); 
minampl=min(ampl); avampl=mean(ampl);
minampl=minampl/avampl;
if minampl<0.05
    disp('WARNING: the phase may be not well-defined!')
end
theta=mod(theta,2*pi);  % phase is in 0,2pi interval
theta=theta(:);         % to ensure that theta is a column vector
end
