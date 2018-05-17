function imageF(FT,FS)

ft=FT(1,1);
fs=(FS/2:0.1:FS*2);
for n=1:length(fs)
    M=round(ft/fs(n));
    m=(1:1:(M*2));
    fimage(1,n)=min(abs(ft*ones(1,length(m))-m*fs(n)));
end;
plot(fs,fimage,'r');grid on;hold on;

ft=FT(1,2);
fs=(FS/2:0.1:FS*2);
for n=1:length(fs)
    M=round(ft/fs(n));
    m=(1:1:(M*2));
    fimage(1,n)=min(abs(ft*ones(1,length(m))-m*fs(n)));
end;
plot(fs,fimage,'g');grid on;hold on;

ft=FT(1,3);
fs=(FS/2:0.1:FS*2);
for n=1:length(fs)
    M=round(ft/fs(n));
    m=(1:1:(M*2));
    fimage(1,n)=min(abs(ft*ones(1,length(m))-m*fs(n)));
end;
plot(fs,fimage,'b');grid on;hold on;
xlabel('Sampling frequency (Hz)');ylabel('Fimage (Hz)');
%ylim([0 20]);
xlim([FS-5 FS+5]);  
hold off;