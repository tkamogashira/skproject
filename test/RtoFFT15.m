% R to FFT15
function FreqAxis=RtoFFT15(R)
for N=1:15
    M((1:204),(1:6000),N)=R((1:204),((6000*N+1):(6000*(N+1))));
end;
clear R;
Md=double(M);
clear M;
for n=1:15
    for c=1:204
        X=fft(Md(c,(1:6000),n),6000,2);
        RFFTMd(c,(1:100),n)=X(1:100);
    end;
end;
clear X;
clear Md;
for nn=1:15
    for cc=1:204
        Y=abs(RFFTMd(cc,(11:100),nn)/100);
        AmpMd(cc,(1:90),nn)=Y/mean(Y);
    end;
end;
clear RFFTMd;
clear Y;
assignin('base','AmpMd',AmpMd);
FreqAxis=(10:99)/3000*0.5*600.615;
assignin('base','FreqAxis',FreqAxis);
end

