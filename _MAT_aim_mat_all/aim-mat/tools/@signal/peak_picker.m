% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function [lowpasssig,maxinfo,mininfo]=peak_picker(sig,options);
% sophisticated peak picker
% the signal is first lowpassfilterd with the frequency given in options
% options comes with:



% frequency with witch the psth is filtered
% options.lowpassfrequency=500;
% search for peaks in the range from to:
% options.search_peak_start_search=0.001; % seach also before the offical latency
% options.search_peak_stop_search=0.025; % seach this time for peaks


% every distinct peak must comply the following conditions:
% a certain activity during the duration of the maximum (a spike count per
% presentation)
if ~isfield(options,'min_count_per_peak')
    options.min_count_per_peak=-inf;% default: no certain activity: all peaks are significant
end
% a certain height of the maximum peak
if ~isfield(options,'min_height_of_heighest_peak')
    options.min_height_of_heighest_peak=0; % default: no certain height: all peaks are significant
end



% return values are the filtered signal and information about the found
% peaks:
% maxinfo.values  % the hights of the found maxima
% maxinfo.times   % where are the found maxima
% maxinfo.contrast % the contrast is the relation between the maximum and the surrounding minima
% maxinfo.qvalue  % how wide the maximum is at half height.
% maxinfo.activity % sum of activity between the adjacent minima

% every found maxima (except the first and the last) is surrounded by two
% minima. Same is true for the found minimas

% do we want some grafical output (for debugging)
grafix=options.grafix;
% define the return values
maxinfo=[];
mininfo=[];


%do the lowpassfiltering    
lowpasssig=lowpass(sig,options.lowpassfrequency);
[atmax,ahmax]=getlocalmaxima(lowpasssig);
[atmin,ahmin]=getlocalminima(lowpasssig);

% restrict to the requiered range
indeces1=find(atmax>options.search_peak_start_search);
indeces2=find(atmax<options.search_peak_stop_search);
indeces=intersect(indeces1,indeces2);
tmax=atmax(indeces);
hmax=ahmax(indeces);
indeces1=find(atmin>options.search_peak_start_search);
indeces2=find(atmin<options.search_peak_stop_search);
indeces=intersect(indeces1,indeces2);
tmin=atmin(indeces);
hmin=ahmin(indeces);




% make an iterated search through all maxima and decide which ones to keep
finished=0;
while ~finished
    % throw out exactly one maximum
    [tmaxnew,tminnew,hmaxnew,hminnew]=try_reduce_maxima(tmax,tmin,hmax,hmin,options);
    if length(tmaxnew)==length(tmax) || length(tmaxnew)==1 || length(tminnew)==1
        finished=1;
    end
    tmax=tmaxnew;    tmin=tminnew;    hmax=hmaxnew;    hmin=hminnew; % new values
%     if grafix
%         plotall(fignum,lowpasssig,tmax,tmin,hmax,hmin);
%         p=0;
%     end
end


if grafix
    fignum=figure;
    set(gcf,'Number','off');
%     set(gcf,'name',sprintf('peak picker (An:%s Un:%s Ex:%s) ',data.unitinfo.an_num,data.unitinfo.un_num,data.unitinfo.ex_num));
    set(gcf,'name',('peak picker'));
    plotall(fignum,lowpasssig,tmax,tmin,hmax,hmin);
end

% if grafix
%     plotall(lowpasssig,tmax,tmin,hmax,hmin);
% end
% now only significant values are left!
% put them in the return structure:

nr_max=length(tmax);
maxinfo.values=hmax;  % the hights of the found maxima
maxinfo.times=tmax;   % where are the found maxima
[highest_peak_height,highest_peak_index]=max(hmax);

for i=1:nr_max
    maxinfo.contrast(i)=getcontrast(i,tmax,tmin,hmax,hmin); % the contrast is the relation between the maximum and the surrounding minima
    maxinfo.qvalue(i)=getquality(i,tmax,tmin,hmax,hmin);  % how wide the maximum is at half height.
    maxinfo.activity(i)=getactivity(i,lowpasssig,tmax,tmin,hmax,hmin,options.latency);  % sum of activity between the adjacent minima
end

nr_min=length(tmin);
mininfo.values=hmin;  % the hights of the found maxima
mininfo.times=tmin;   % where are the found maxima
for i=1:nr_min
    mininfo.contrast(i)=getmincontrast(i,tmax,tmin,hmax,hmin); % the contrast is the relation between the maximum and the surrounding minima
    mininfo.qvalue(i)=getminquality(i,tmax,tmin,hmax,hmin);  % how wide the maximum is at half height.
end

% now we have all peaks, find out which ones are significant for us
maxinfo.distinct_max=[];
count=1;
height_criterium=options.min_height_of_heighest_peak*highest_peak_height;
count_criterium=options.min_count_per_peak;

for i=1:nr_max
    % it must have a certain contrast
    if maxinfo.contrast(i)>=options.min_contrast_for_distinct_peak
        % and it must have a certain height
        if maxinfo.values(i)>=height_criterium
            if maxinfo.activity(i)>=count_criterium
                maxinfo.distinct_max(count).contrast=maxinfo.contrast(i);
                maxinfo.distinct_max(count).qvalue=maxinfo.qvalue(i);
                maxinfo.distinct_max(count).activity=maxinfo.activity(i);
                maxinfo.distinct_max(count).hmax=hmax(i);
                maxinfo.distinct_max(count).tmax=tmax(i);
                count=count+1;
            end
        end
    end
end


if grafix
    nr_all_max=length(atmax);
    for i=1:nr_all_max
        plot(atmax(i)*1000,ahmax(i),'o','markersize',2,'Markerfacecolor','r','Markeredgecolor','r');
    end
    nr_all_min=length(atmin);
    for i=1:nr_all_min
        plot(atmin(i)*1000,ahmin(i),'o','markersize',2,'Markerfacecolor','g','Markeredgecolor','g');
    end

    % plot a dot for every disticnt maximum found
    for i=1:nr_max
        testmaxpos=maxinfo.times(i);
        testmaxval=maxinfo.values(i);
        contrast=maxinfo.contrast(i);
        count=maxinfo.activity(i);
        plot(testmaxpos*1000,testmaxval,'o','markersize',8,'Markerfacecolor','r','Markeredgecolor','r');
    end
    % plot a dot for every minimum found
    for i=1:length(maxinfo.distinct_max);
        testmaxpos=maxinfo.distinct_max(i).tmax;
        testmaxval=maxinfo.distinct_max(i).hmax;
        contrast=maxinfo.distinct_max(i).contrast;
        count=maxinfo.distinct_max(i).activity;
        text(testmaxpos*1000+1,testmaxval,sprintf('contr %3.3f',contrast),'fontsize',6,'ver','bottom');
        text(testmaxpos*1000+1,testmaxval,sprintf('count %3.3f',count),'fontsize',6,'ver','top');
    end
    for i=1:nr_min
        testminpos=mininfo.times(i);
        testminval=mininfo.values(i);
        plot(testminpos*1000,testminval,'o','markersize',4,'Markerfacecolor','g','Markeredgecolor','g');
    end
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotall(fignum,lowpasssig,tmax,tmin,hmax,hmin);
figure(fignum);
clf
hold on
fill(lowpasssig,'b');
set(gca,'xlim',[0,60]);
for i=1:length(tmax)
    plot(tmax(i)*1000,hmax(i),'Marker','o','MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','r')
end
for i=1:length(tmin)
%     plot(time2bin(lowpasssig,tmin(i)),hmin(i),'Marker','o','MarkerSize',6,'MarkerFaceColor','g','MarkerEdgeColor','g')
end
xlabel('time (ms)');
ylabel('spikes / sweep / bin');
title(' PSTH plus found maxima');
% movegui(nfig,'northwest');
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tmaxnew,tminnew,hmaxnew,hminnew]=try_reduce_maxima(tmax,tmin,hmax,hmin,options)
% throw out the peak with the smallest contrast 
% if removed, the minimum to the right of it is removed too

nr_max=length(tmax);

% find the maximum with the neighbour that is closest in height and throw
% it out!
for i=1:nr_max
    contrastr(i)=getrightcontrast(i,tmax,tmin,hmax,hmin);
end
for i=1:nr_max
    contrastl(i)=getleftcontrast(i,tmax,tmin,hmax,hmin);
end
[mincontrastr,minconindexr]=min(abs(contrastr));    % thats the smallest right 
[mincontrastl,minconindexl]=min(abs(contrastl));    % thats the smallest left

if mincontrastr<mincontrastl
    side='right';
    [mincontrast,minconindex]=min(contrastr);
else
    side='left';
    [mincontrast,minconindex]=min(contrastl);
end

testmaxpos=tmax(minconindex);
% if mincontrast<options.min_contrast_for_distinct_peak
if mincontrast<options.min_contrast_for_peak
    switch side
        case 'right'
            [testminpos,testminval,indexmin]=getminimumrightof(testmaxpos,tmax,tmin,hmax,hmin);
        case 'left'
            [testminpos,testminval,indexmin]=getminimumleftof(testmaxpos,tmax,tmin,hmax,hmin);
    end
    
    % remove the minimum right of the maximum
    tmaxnew=mysetdiff(tmax,tmax(minconindex));
    hmaxnew=mysetdiff(hmax,hmax(minconindex));
    if indexmin>0 && indexmin <length(tmin)
        tminnew=mysetdiff(tmin,tmin(indexmin));
        hminnew=mysetdiff(hmin,hmin(indexmin));
    else
        tminnew=tmin;
        hminnew=hmin;
    end
    return % only remove one!
end

% if still here, then nothing happend
tmaxnew=tmax;    tminnew=tmin;     hmaxnew=hmax;    hminnew=hmin;

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret=mysetdiff(values,singleval)
% the same as setdiff, but without the sorting
ret=[];
for i=1:length(values)
    if singleval~=values(i)
        ret=[ret values(i)];
    end
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function contrast=getcontrast(peaknumber,tmax,tmin,hmax,hmin)
% return the contrast of the peak with the number
testmaxpos=tmax(peaknumber);
testmaxval=hmax(peaknumber);
[leftminpos,leftminval]=getminimumleftof(testmaxpos,tmax,tmin,hmax,hmin);
[rightminpos,rightminval]=getminimumrightof(testmaxpos,tmax,tmin,hmax,hmin);
if isempty(leftminpos) && isempty(rightminpos)  % if both are empty, its difficult
    contrast=0;
elseif isempty(leftminpos)  % if only the left is empty, take the right instead
    contrast=(testmaxval-rightminval)/(testmaxval+rightminval);
elseif isempty(rightminpos)  % if only the right is empty, take the left instead
    contrast=(testmaxval-leftminval)/(testmaxval+leftminval);
else
    mean_min_val=mean([leftminval rightminval]);
    contrast=(testmaxval-mean_min_val)/(testmaxval+mean_min_val);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function contrast=getrightcontrast(peaknumber,tmax,tmin,hmax,hmin)
% return the contrast with the right minimum of the peak with the number
testmaxpos=tmax(peaknumber);
testmaxval=hmax(peaknumber);
% [leftminpos,leftminval]=getminimumleftof(testmaxpos,tmax,tmin,hmax,hmin);
[rightminpos,rightminval]=getminimumrightof(testmaxpos,tmax,tmin,hmax,hmin);
% if isempty(leftminpos) && isempty(rightminpos)  % if both are empty, its difficult
%     contrast=0;
% elseif isempty(leftminpos)  % if only the left is empty, take the right instead
%     contrast=(testmaxval-rightminval)/(testmaxval+rightminval);
if isempty(rightminpos)  % if only the right is empty, take the left instead
    contrast=inf;
else
    %     mean_min_val=mean([leftminval rightminval]);
    contrast=(testmaxval-rightminval)/(testmaxval+rightminval);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function contrast=getleftcontrast(peaknumber,tmax,tmin,hmax,hmin)
% return the contrast with the right minimum of the peak with the number
testmaxpos=tmax(peaknumber);
testmaxval=hmax(peaknumber);
[leftminpos,leftminval]=getminimumleftof(testmaxpos,tmax,tmin,hmax,hmin);
% [rightminpos,rightminval]=getminimumrightof(testmaxpos,tmax,tmin,hmax,hmin);
% if isempty(leftminpos) && isempty(rightminpos)  % if both are empty, its difficult
%     contrast=0;
% elseif isempty(leftminpos)  % if only the left is empty, take the right instead
%     contrast=(testmaxval-rightminval)/(testmaxval+rightminval);
if isempty(leftminpos)  % if only the right is empty, take the left instead
    contrast=inf;
else
    %     mean_min_val=mean([leftminval rightminval]);
    contrast=(testmaxval-leftminval)/(testmaxval+leftminval);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function contrast=getmincontrast(troughnumber,tmax,tmin,hmax,hmin)
% return the contrast of the peak with the number
testminpos=tmin(troughnumber);
testminval=hmin(troughnumber);
[leftmaxpos,leftmaxval]=getmaximumleftof(testminpos,tmax,tmin,hmax,hmin);
[rightmaxpos,rightmaxval]=getmaximumrightof(testminpos,tmax,tmin,hmax,hmin);
if isempty(leftmaxpos) && isempty(rightmaxpos)  % if both are empty, its difficult
    contrast=0;
elseif isempty(leftmaxpos)  % if only the left is empty, take the right instead
    contrast=(testminval-rightmaxval)/(testminval+rightmaxval);
elseif isempty(rightmaxpos)  % if only the right is empty, take the left instead
    contrast=(testminval-leftmaxval)/(testminval+leftmaxval);
else
    mean_max_val=mean([leftmaxval rightmaxval]);
    contrast=(testminval-mean_max_val)/(testminval+mean_max_val);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function peakheight=getpeakheight(peaknumber,tmax,tmin,hmax,hmin)
testmaxpos=tmax(peaknumber);
testmaxval=hmax(peaknumber);
[leftminpos,leftminval]=getminimumleftof(testmaxpos,tmax,tmin,hmax,hmin);
[rightminpos,rightminval]=getminimumrightof(testmaxpos,tmax,tmin,hmax,hmin);
if isempty(leftminpos) && isempty(rightminpos)  % if both are empty, its difficult
    peakheight=testmaxval;
elseif isempty(leftminpos)  % if only the left is empty, take the right instead
    peakheight=testmaxval-rightminval;
elseif isempty(rightminpos)  % if only the right is empty, take the left instead
    peakheight=testmaxval-leftminval;
else
    mean_min_val=mean([leftminval rightminval]);
    peakheight=testmaxval-mean_min_val;
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function troughheight=gettroughheight(troughnumber,tmax,tmin,hmax,hmin)
testminpos=tmin(troughnumber);
testminval=hmin(troughnumber);
[leftmaxpos,leftmaxval]=getminimumleftof(testminpos,tmax,tmin,hmax,hmin);
[rightmaxpos,rightmaxval]=getminimumrightof(testminpos,tmax,tmin,hmax,hmin);
if isempty(leftmaxpos) && isempty(rightmaxpos)  % if both are empty, its difficult
    troughheight=abs(testminval);
elseif isempty(leftmaxpos)  % if only the left is empty, take the right instead
    troughheight=abs(testminval-rightmaxval);
elseif isempty(rightmaxpos)  % if only the right is empty, take the left instead
    troughheight=abs(testminval-leftmaxval);
else
    mean_min_val=mean([leftmaxval rightmaxval]);
    troughheight=abs(testminval-mean_min_val);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function quality=getquality(peaknumber,tmax,tmin,hmax,hmin);  % how wide the maximum is at the height of its surrounding minima
testmaxpos=tmax(peaknumber);
testmaxval=hmax(peaknumber);
[leftminpos,leftminval]=getminimumleftof(testmaxpos,tmax,tmin,hmax,hmin);
[rightminpos,rightminval]=getminimumrightof(testmaxpos,tmax,tmin,hmax,hmin);
if isempty(leftminpos) && isempty(rightminpos)  % if both are empty, its difficult
    quality=0;
elseif isempty(leftminpos)  % if only the left is empty, take the right instead
    quality=0;
elseif isempty(rightminpos)  % if only the right is empty, take the left instead
    quality=0;
else
    diff_min_val=abs(leftminpos-rightminpos);
    quality=testmaxval/diff_min_val;
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function quality=getminquality(troughknumber,tmax,tmin,hmax,hmin);  % how wide the maximum is at the height of its surrounding maxima
testminpos=tmin(troughknumber);
testminval=hmin(troughknumber);
[leftmaxpos,leftmaxval]=getmaximumleftof(testminpos,tmax,tmin,hmax,hmin);
[rightmaxpos,rightmaxval]=getmaximumrightof(testminpos,tmax,tmin,hmax,hmin);
if isempty(leftmaxpos) && isempty(rightmaxpos)  % if both are empty, its difficult
    quality=0;
elseif isempty(leftmaxpos)  % if only the left is empty, take the right instead
    quality=0;
elseif isempty(rightmaxpos)  % if only the right is empty, take the left instead
    quality=0;
else
    diff_min_val=abs(leftmaxval-rightmaxval);
    quality=testminval/diff_min_val;
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function activity=getactivity(peaknumber,sig,tmax,tmin,hmax,hmin,latency);  % sum of activity between the adjacent minima
testmaxpos=tmax(peaknumber);
testmaxval=hmax(peaknumber);
[leftminpos,leftminval]=getminimumleftof(testmaxpos,tmax,tmin,hmax,hmin);
[rightminpos,rightminval]=getminimumrightof(testmaxpos,tmax,tmin,hmax,hmin);
if isempty(leftminpos) && isempty(rightminpos)  % if both are empty, its difficult
    activity=0;
elseif isempty(leftminpos)  % if only the left is empty, take the right instead
    activity=0; % take the activity from the start of the signal instead
    sr=1000/getsr(sig);
    activity=sum(sig,latency,rightminpos)/sr;

elseif isempty(rightminpos)  % if only the right is empty, take the left instead
    activity=0;
else
    sr=1000/getsr(sig);
    activity=sum(sig,leftminpos,rightminpos)/sr;
end
return
