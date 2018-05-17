function reverseimageF2(FT,FS)

fs=FS(1,1);
ft=(1:1:max(FT)*2);
for n=1:length(ft)
    M=round(ft(n)/fs);
    m=(0:1:(M*2));
    fimage(1,n)=min(abs(ft(n)*ones(1,length(m))-m*fs));
end;

n1=find(ft==FT(1));
n2=find(ft==FT(2));
n3=find(ft==FT(3));
n4=find(ft==FT(4));
plot(ft,fimage,'b');grid on;hold on;
plot(ft(n1),fimage(n1),'ro');grid on;hold on;
plot(ft(n2),fimage(n2),'ro');grid on;hold on;
plot(ft(n3),fimage(n3),'ro');grid on;hold on;
plot(ft(n4),fimage(n4),'ro');grid on;hold on;

xlabel('Signal frequency (Hz)');ylabel('Fimage (Hz)');
%ylim([0 20]);
%xlim([FS-5 FS+5]);  
hold off;
legend(['Fs=' num2str(FS) 'Hz']);
%['Fs=' num2str(FS(1,2)) 'Hz'],['Fs=' num2str(FS(1,3)) 'Hz']);