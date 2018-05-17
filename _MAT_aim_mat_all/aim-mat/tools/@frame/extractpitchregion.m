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

function fr=extractpitchregion(fr)
% throws out the region to a certain periodicity in the auditory image


global graphix;global starttime;
graphix=0;

% 0 von comps(0-2)
% und dann langsam auf 1 bis comp(3)

zerotime=1;
attacktill=2;
attacktodominant=4;
dominanttime=7;
decaytime=8;

% zerotime=1.5;
% attacktill=2.5;
% attacktodominant=4;
% dominanttime=7;
% decaytime=8;

dominant_scale_factor=1;


nr_ch=getnrchannels(fr);
cfs=getcf(fr);
end_time=getmaximumtime(fr);
sr=getsr(fr);
geslen=getlength(fr);
starttime=getminimumtime(fr);


for i=1:nr_ch
    ch_fre=cfs(i);
    ch=getsinglechannel(fr,i);
    firsttime=-1/ch_fre*zerotime; % up to the second
    secondtime=-1/ch_fre*attacktill;
    thirdtime=-1/ch_fre*attacktodominant;
    sixtime=-1/ch_fre*dominanttime;
    seventime=-1/ch_fre*decaytime;
    
    ch=scalefun(ch,0,firsttime,0,0,'r');
    ch=scalefun(ch,firsttime,secondtime,0,1,'g');
    ch=scalefun(ch,secondtime,thirdtime,1,dominant_scale_factor,'k');
    ch=scalefun(ch,thirdtime,sixtime,dominant_scale_factor,dominant_scale_factor,'y');
    ch=scalefun(ch,sixtime,seventime,dominant_scale_factor,1,'c');
    
    % scale the amplitude of higher cf-channels down
%     cutoff=2000;
%     db_per_octave=6;
%     scaler=getfiltervaluelowpass(ch_fre,cutoff,db_per_octave);    
%     ch=ch*scaler;
%     
%     fr=setsinglechannel(fr,i,ch);
end


function fun=scalefun(fun,fromtime,totime,scaler2,scaler1,col)
    global starttime;global graphix;
    dur=abs(totime)-abs(fromtime);
    nr_points=time2bin(fun,fromtime)-time2bin(fun,totime);
    msig=linspace(scaler1,scaler2,nr_points);
    if fromtime < starttime
        return
    end
    if totime < starttime
        scaler1=scaler2+(scaler2-scaler1)/(fromtime-totime)*(starttime-totime);
        totime=starttime;
        nr_points=time2bin(fun,fromtime)-time2bin(fun,totime);
        msig=linspace(scaler1,scaler2,nr_points);
    end
    if nr_points > 0
        fun=mult(fun,msig,totime,nr_points/getsr(fun));
    end
    if graphix 
        plot(fun,col);hold on;
    end

return


