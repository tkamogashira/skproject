% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function [phase,vectorstrength,strength]=calculatephase(stim,freq,grafix)

% calculates the phase in radian for the stimulus in stim given a frequency
% of freq.
if nargin<3
    grafix=0;
end

vals=getvalues(stim);

nrvals=length(vals);
modphase=time2bin(stim,1/freq);
% vectorstrength=signal(length(modphase),1);
vectorstrength=zeros(modphase,1);
sr=getsr(stim);
for i=1:nrvals
    intphase=mod(i,modphase)+1;
    vectorstrength(intphase)=vectorstrength(intphase)+vals(i);
end

[strength,maxintphase]=max(vectorstrength);
phase=maxintphase/modphase*2*pi;


if grafix
    figure(5423)
    clf
    plot(vectorstrength);
    set(gca,'ylim',[min(vectorstrength)*1.1 max(vectorstrength)*1.1]);
    xlabel('phase')
    phases=get(gca,'xtick');
    phases=phases/modphase*2*pi;
    for i=1:length(phases)
        phasestr(i,:)=sprintf('%2.2f',phases(i));
    end
    set(gca,'xticklabel',phasestr);
    hold on
    plot(maxintphase,strength,'.','Markerfacecolor','r','Markeredgecolor','r','Markersize',25);
    text(maxintphase,strength*1.15,sprintf('Phase: %2.2f',phase),'verticalal','bottom'); 
    text(maxintphase,strength*1.15,sprintf('Freq: %3.3f Hz',freq),'verticalal','top'); 
    
end


return