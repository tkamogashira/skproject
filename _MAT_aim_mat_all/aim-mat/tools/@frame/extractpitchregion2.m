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

dominant_scale_factor=1;

graphix=0;

nr_ch=getnrchannels(fr);
cfs=getcf(fr);
end_time=getmaximumtime(fr);
sr=getsr(fr);
geslen=getlength(fr);
starttime=getminimumtime(fr);

for i=1:nr_ch
    ch_fre=cfs(i);
    ch=getsinglechannel(fr,i);
    
%     firstfre=-1/ch_fre*1; % up to the second
%     firstbin=time2bin(ch,firstfre);
%     firsttime=firstbin/sr-geslen;

% set all values below the first harmonic to 0
    firsttime=-1/ch_fre*1; % up to the second
    if graphix clf;plot(ch);hold on;end
    ch=setvalues(ch,0,time2bin(ch,firsttime));
    if graphix plot(ch,'r');end
    
    % scale all values between the first and second from 0 to 1
    secondtime=-1/ch_fre*2;
    dur=abs(secondtime)-abs(firsttime);
    nr_points=time2bin(ch,firsttime)-time2bin(ch,secondtime);
    msig=linspace(1,0,nr_points);
    ch=mult(ch,msig,secondtime,nr_points/sr);
    if graphix plot(ch,'g');end

% scale all values between the second and third from 1 to dominant_scale_factor
    thirdtime=-1/ch_fre*3;
    dur=abs(thirdtime)-abs(secondtime);
    nr_points=time2bin(ch,secondtime)-time2bin(ch,thirdtime);
    msig=linspace(dominant_scale_factor,1,nr_points);
    ch=mult(ch,msig,thirdtime,nr_points/sr);
    if graphix plot(ch,'k');end

% scale all values between the third and six by dominant_scale_factor
    sixtime=-1/ch_fre*6;
    dur=abs(sixtime)-abs(thirdtime);
    nr_points=time2bin(ch,thirdtime)-time2bin(ch,sixtime);
    msig=ones(1,nr_points)*dominant_scale_factor;
    if sixtime < starttime
        sixtime=starttime;
        nr_points=time2bin(ch,thirdtime)-time2bin(ch,sixtime);
        msig=ones(1,nr_points)*dominant_scale_factor;
    end
    ch=mult(ch,msig,sixtime,nr_points/sr);
    if graphix plot(ch,'y');end

% scale all values between the six and seven from dominant_scale_factor to 1
    seventime=-1/ch_fre*7;
    dur=abs(seventime)-abs(sixtime);
    nr_points=time2bin(ch,sixtime)-time2bin(ch,seventime);
    msig=linspace(1,dominant_scale_factor,nr_points);
    if seventime < starttime
        seventime=starttime;
        nr_points=time2bin(ch,sixtime)-time2bin(ch,seventime);
        msig=linspace(1,dominant_scale_factor,nr_points);
    end
    if nr_points > 0
        ch=mult(ch,msig,seventime,nr_points/sr);
    end
    if graphix plot(ch,'c');end


    % scale the amplitude of higher cf-channels down
    cutoff=2000;
    db_per_octave=6;
    scaler=getfiltervalue(ch_fre,cutoff,db_per_octave);    
    ch=ch*scaler;

    
    
    
    
    fr=setsinglechannel(fr,i,ch);
    
end



