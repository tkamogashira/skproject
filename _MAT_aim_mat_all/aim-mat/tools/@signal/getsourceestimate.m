% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sources=getsourceestimate(sig,sigma)
% usage: sources=getsourceestimate(sig,sigma))
% returns a struct of sources.position and sources.height
% for each maximum in the signal sig.
% it is assumed, that each maximum contributes to the signal with
% a gaussian kernel of the width "sigma"


grafix=0;   % debug

% nrchannels=getnrchannels(cframe);
% smoothwidth=nrchannels/64;
% fresumme=smooth(fresumme,smoothwidth);

finished=0; % it can be finished by: 
% a) after 5 Maxima
% b) the signal is below 30 % of original
how_many_max_maximal=5;
threshold_criterion=0.3;

if nargin < 2
    % wie breit jedes Maximum angenommen wird
    sigma=3;    % this is in the sr of the singal
end

current_max=1;
start_max_hight=max(sig); % so hoch im Moment

if grafix
    plot(sig);
    hold on;
    a=axis;
    a(3)=-start_max_hight*1.1;
    a(4)=start_max_hight*1.1;
    axis(a);
end

cols=['b';'g';'k';'y';'b';'g';'k']; % verschiedene Farben für die unterschiedlichen Dominanzregionen
while ~finished
    [maxpos,minpos,maxs,mins]=getminmax(sig);
    [maxmaxhight,maxmaxpos]=max(sig);
    
    gauss=signal(sig);
    gauss=generategauss(gauss,maxmaxpos,maxmaxhight,sigma);
    sig=sig-gauss;
    
    sources{current_max}.position=maxmaxpos;
    sources{current_max}.height=maxmaxhight;
    sources{current_max}.sigma=sigma;
    
    
    if grafix        
        cur_col=cols(mod(current_max,7)+1,:);
        plot(sig,cur_col);
        axis(a);
        plot(maxmaxpos,maxmaxhight,'r.','MarkerSize',20);
    end
    current_max_hight=max(sig); % so hoch im Moment
    if current_max_hight <= start_max_hight*threshold_criterion
        finished=1;
    end
    
    
    current_max=current_max+1;
    if current_max>how_many_max_maximal
        finished=1;
    end
    
end
if grafix        
    plot(sig,'r');
    axis(a);
end

return







