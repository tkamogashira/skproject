% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function cdat=coolregion(current_frame,cdat,peak)

% Ich geh von einer Colormap aus, die Farben pro Wert zwischen 0 und 1
% unterschiedlich darstellt. 0=schwarz, und dann z.B zirkeln wie in prism



fre_val=peak.spektral_profile.position;
int_val=peak.interval_profile.position;

% current_frame_handle=peak.current_frame_handle;

vals=getvalues(current_frame);
% cdat=get(current_frame_handle,'cdata');
% erst mal alle erhaltenen Werte auf Null setzen
ca=cdat;

% wie weit die spektrale Summe runterskaliert werden muss, damit die Zahlen vernünftigt werden
norm_spektralhight=1.5/1e5;
fresumme=getfrequencysum(current_frame);
fresumme=fresumme*norm_spektralhight;
gauss=signal(fresumme);
maxmaxpos=fre_val;
maxmaxhight=1;
sigma=peak.spektral_profile.sigma;
gauss=generategauss(gauss,maxmaxpos,maxmaxhight,sigma);


from_fre=fre_val-sigma;
to_fre=fre_val+sigma;
maxbin=length(cdat);
minbin=1;
maxchan=getnrchannels(current_frame);
minchan=1;

from_fre=min(from_fre,maxchan);
from_fre=max(from_fre,minchan);
to_fre=max(to_fre,minchan);
to_fre=min(to_fre,maxchan);
sr=getsr(current_frame);

for i=from_fre:to_fre
    sig=getsinglechannel(current_frame,i);
    [maxpos,minpos,maxs,mins]=getminmax(sig);

    % Die Intervalle zwischen den Minima links und rechts vom Maximum werden eingefärbt
    from_int=getminimumleftof(int_val,maxpos,minpos,maxs,mins);
    to_int=getminimumrightof(int_val,maxpos,minpos,maxs,mins);
%     frombin=displaytime2bin(current_frame,from_int);
%     tobin=displaytime2bin(current_frame,to_int);
    frombin=time2bin(from_int,sr);
    tobin=time2bin(to_int,sr);
    frombin=min(frombin,maxbin);
    frombin=max(frombin,minbin);
    tobin=max(tobin,minbin);
    tobin=min(tobin,maxbin);
    
    tob=floor(maxbin-frombin);
    fromb=floor(maxbin-tobin+1);
    
%     ca(fromb:tob,i)=getbinvalue(gauss,i)*peak.spektralhight;
    ca(fromb:tob,i)=peak.source_color;
%     ca(fromb:tob,i)=floor(rand(1)*10);
end

cdat=ca;