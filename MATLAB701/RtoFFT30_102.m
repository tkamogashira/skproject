% R to FFT30_102
function FreqAxis=RtoFFT30_102(R)
for N=1:30
    M((1:204),(1:6000),N)=R((1:204),((6000*N+1):(6000*(N+1))));
end;
clear R;
Md=double(M);
clear M;
for n=1:30
    for c=1:204
        X=fft(Md(c,(1:6000),n),6000,2);
        RFFTMd(c,(1:100),n)=X(1:100);
    end;
end;
clear Md;
clear X;
for nn=1:30
    for cc=1:204
        AmpMd(cc,(1:90),nn)=abs(RFFTMd(cc,(11:100),nn)/100);
    end;
end;
clear RFFTMd;
clear Y;
for n2=1:30
    for c2=1:102
        Z=AmpMd((2*c2-1),(1:90),n2).^2+AmpMd((2*c2),(1:90),n2).^2;
        AmpMd2(c2,(1:90),n2)=Z/mean(Z);
    end;
end;
clear Z;
assignin('base','AmpMd2',AmpMd2);
FreqAxis=(10:99)/3000*0.5*600.615;
assignin('base','FreqAxis',FreqAxis);
end

