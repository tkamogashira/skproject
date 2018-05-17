function [startindex, endindex, form]=formanttest(x,windowperiod,timestep,fs)

allsecond=(length(x)-1)/fs - windowperiod;
timestepkosuu=floor(allsecond/timestep);
startindex=(0:1:timestepkosuu)*floor(timestep*fs)+1;
endindex=startindex+floor(windowperiod*fs);
form={};
[b, a]=ellip(2,3,6,50/(fs/2),'high');
for k=1:length(startindex)
    x0=(x(startindex(k):endindex(k)))';
%     s1=size(x0)
%     s2=size(hamming( length(x0) ))
    x1=x0.*hamming( length(x0) );
    x1=filter(b,a,x1);
     %%% x1=filter(1,[1 -0.97],x1);
    A=lpc(x1,12);
    rts=roots(A);
    
    rts = rts(imag(rts)>=0);
    angz = atan2(imag(rts),real(rts));
    
    [frqs,indices] = sort(angz.*(fs/(2*pi)));
    bw = -1/2*(fs/(2*pi))*log(abs(rts(indices)));
    formants(1)=0;%%%%%
    nn = 1;
    for kk = 1:length(frqs)
        if (frqs(kk) > 90 && bw(kk) <400)%%%400)
            formants(nn) = frqs(kk);
            nn = nn+1;
        end
    end
    
    form{k,1}=formants;
    
    for q=1:length(formants)
        ff=startindex(k)/fs+windowperiod/2;
        if ff>0.025 & ff<0.5
        plot( ff, formants(q), 'r*');hold on;grid on;
        end;
    end;
    clear formants
end;hold off;
set(gca,'YTick',[0 1000 2000 3000 4000 5000]);
set(gca,'XTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);

