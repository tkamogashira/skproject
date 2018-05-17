function reverseimageF(FT,FS)

fs=FS(1,1);
ft=(1:1:FT*2);
for n=1:length(ft)
    M=round(ft(n)/fs);
    m=(0:1:(M*2));
    fimage(1,n)=min(abs(ft(n)*ones(1,length(m))-m*fs));
end;

%fimage
plot(ft,fimage,'r');grid on;hold on;

fs=FS(1,2);
ft=(1:1:FT*2);
for n=1:length(ft)
    M=round(ft(n)/fs);
    m=(0:1:(M*2));
    fimage(1,n)=min(abs(ft(n)*ones(1,length(m))-m*fs));
end;
%fimage
plot(ft,fimage,'g');grid on;hold on;

fs=FS(1,3);
ft=(1:1:FT*2);
for n=1:length(ft)
    M=round(ft(n)/fs);
    m=(0:1:(M*2));
    fimage(1,n)=min(abs(ft(n)*ones(1,length(m))-m*fs));
end;
%fimage
plot(ft,fimage,'b');grid on;hold on;


xlabel('Signal frequency (Hz)');ylabel('Fimage (Hz)');
%ylim([0 20]);
%xlim([FS-5 FS+5]);  
hold off;
legend(['Fs=' num2str(FS(1,1)) 'Hz'],['Fs=' num2str(FS(1,2)) 'Hz'],['Fs=' num2str(FS(1,3)) 'Hz']);