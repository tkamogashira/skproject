% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function str=getchange(sig,start1,stop1,start2,stop2,grafix)
% returns some information how the signal changes in the time at start1 and
% stop1 in reference to start2 and stop2
% this is used to define onset and offset effects of psths
% sig=signal
% start1= start of the part of the signal that has the effect
% stop1= stop of the part of the signal that has the effect
% start2= start of the part of the signal that is used as reference
% stop2= stop of the part of the signal that is used as reference

if nargin<6
    grafix=0;
end

referencesig=getpart(sig,start2,stop2);
meanreference=mean(getvalues(referencesig));
% variability=std(getvalues(referencesig));

searchsig=getpart(sig,start1,stop1);
meansearchsig=mean(getvalues(searchsig));

if meanreference~=0
    str.ampeffect=meansearchsig/meanreference;
else
    str.ampeffect=0;
end

str.ampeffectstr=getsignificantstring(getvalues(searchsig),meanreference);

if grafix==1
%      oldgraph=gcf;
%     figure(234234098)
%     clf
    hold on
%     set(gcf,'num','off')
%     set(gcf,'name','changes in signal');
    fill(sig,'b');
    fill(referencesig,'r')
    fill(searchsig,'g')
    
    
    x0=getminimumtime(sig)*1000;
    x1=getmaximumtime(sig)*1000;
    line([x0 x1],[meanreference meanreference],'color','r')
    line([x0 x1],[meansearchsig meansearchsig],'color','g')
    set(gca,'xlim',[x0 x1]);
%     set(gca,'ylim',[0 max(sig)*1.3]);
    set(gca,'ylim',[min(0,min(sig)*1.3) max(sig)*1.3]);
    x=(getmaximumtime(sig)*1000-getminimumtime(sig)*1000)/2;
    x=(stop1*1000-start1*1000)/2;
    y=max(sig);
    text(x,y,sprintf('effect: %3.2f (%s)',str.ampeffect*100,str.ampeffectstr),'vert','botto','hor','left')
    legend('Signal','reference','interesting bit');
%     text(x,y,,'vert','top','hor','left')
%     figure(oldgraph);
end

function sigstr=getsignificantstring(vals1,meanvals)
cv=ver('stats');
if length(cv)==0
    sigstr='no stats box';
return
end
if sum(vals1)>0
    if ttest(vals1,meanvals,0.001,1)
        sigstr='*** more';
    elseif ttest(vals1,meanvals,0.01,1)
        sigstr='** more';
    elseif ttest(vals1,meanvals,0.05,1)
        sigstr='* more';
    elseif ttest(vals1,meanvals,0.001,-1)
        sigstr='*** less';
    elseif ttest(vals1,meanvals,0.01,-1)
        sigstr='** less';
    elseif ttest(vals1,meanvals,0.05,-1)
        sigstr='* less';
    else
        sigstr='not significant';
    end
else
    sigstr='cant determine';
end
