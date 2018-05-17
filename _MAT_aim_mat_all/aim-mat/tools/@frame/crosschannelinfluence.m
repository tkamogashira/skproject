% method of class @frame
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/01/17 16:57:46 $
% $Revision: 1.3 $

function ret=crosschannelinfluence(fr,erb)
% usage: ret=crosschannelinfluence(fr,erb)
% calculates the difference of the maxima from one channel to the next
% so many channels are calculated as in erb

if nargin < 2
    erb=1;
end

break_freq=2000;

ret=frame(fr);

vals=getvalues(fr);
vals=zeros(size(vals));

nr_chan=getnrchannels(fr);
cfs=getcf(fr);

for i=1:nr_chan
    chan=getsinglechannel(fr,i);
    [maxpos{i},minpos{i},maxs{i},mins{i}]=getminmax(chan);
end
sig=chan; % KopieKonstruktor

for i=1:nr_chan-erb
    fre=cfs(i);
    t_oszi=1/fre;   % Die Zeitspanne zweier natürlicher peaks in dem Kanal
    
    if fre>break_freq
        break
    end
    
    nr_max=length(maxpos{i});
    difmin=zeros(nr_max,1);
    for k=i+1:i+erb+1
        for j=1:nr_max;
            xx=maxpos{i}(j);
            maxleft=getmaximumleftof(xx+t_oszi/10,maxpos{k},minpos{k},maxs{k},mins{k});
            maxright=getmaximumrightof(xx-t_oszi/10,maxpos{k},minpos{k},maxs{k},mins{k});
            if isempty(maxleft)
                difleft=t_oszi;
            else
                difleft=abs(xx-maxleft);
            end
            if isempty(maxright)
                difright=t_oszi;
            else
                difright=abs(maxright-xx);
            end
            difmin(j)=difmin(j)+min(difleft,difright);
        end
    end
%     difmin=difmin*200;
      difmin=difmin/t_oszi;
      difmin=1-difmin;
      difmin(find(difmin < 0))=0;
    
    sig=buildspikesfrompoints(sig,maxpos{i},difmin);
    vals(i,:)=getvalues(sig)';
end

ret=setvalues(ret,vals);

return



prev_chan=getsinglechannel(fr,1);
[prevmaxpos,prevminpos,prevmaxs,prevmins]=getminmax(prev_chan);
sig=prev_chan;

for i=2:nr_chan
    fre=cfs(i);
    t_oszi=1/fre;   % Die Zeitspanne zweier natürlicher peaks in dem Kanal
    
    if fre>break_freq
        break
    end
    
    now_chan=getsinglechannel(fr,i);
    [nowmaxpos,nowminpos,nowmaxs,nowmins]=getminmax(now_chan);
    difmin=zeros(size(nowmaxpos));
    
    for j=1:length(nowmaxpos);
        xx=nowmaxpos(j);
        difleft=getmaximumleftof(xx+t_oszi/10,prevmaxpos,prevminpos,prevmaxs,prevmins);
        difright=getmaximumrightof(xx-t_oszi/10,prevmaxpos,prevminpos,prevmaxs,prevmins);
        if isempty(difleft)
            difleft=inf;
        else
            difleft=abs(xx-difleft);
        end
        if isempty(difright)
            difright=inf;
        else
            difright=abs(difright-xx);
        end
        difmin(j)=min(difleft,difright);
    end
    difmin=1-(difmin/t_oszi);
    %     sig=buildfrompoints(sig,nowmaxpos,difmin);
    
    sig=buildspikesfrompoints(sig,nowmaxpos,difmin);
    
    vals(i,:)=getvalues(sig)';
    
    prev_chan=now_chan;
    prevmaxpos=nowmaxpos;
    prevminpos=nowminpos;
    prevmaxs=nowmaxs;
    prevmins=nowmins;
    s=0;
end

ret=setvalues(ret,vals);

