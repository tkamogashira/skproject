%CFmismatch
function CFcombi = CFmismatchN2(varargin);

N=length(varargin);
M=(1:1:N);
S=[varargin{1}];
for s=2:N
    S=[S varargin{s}];
end;
CFcombiSelect(1)=struct('Fiber1',[],'Fiber2',[],'BF',[],'BestITD',[],'BP',[],'CD',[],'CP',[],...
            'CF1',[],'CF2',[],'DeltaCF',[],'MeanCF',[],'ds1',[],...
            'IPCx',[],'IPCy',[],'ISRx',[],'ISRy',[]);
for q=1:N
    A=[S(q) S(find(M ~= q))];
    for p=1:(N-1)
        [ArgOut,BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy]=EvalFSphase2R(A(1),A(p+1), 'plotmode', 'ALL');
        Fiber1=[num2str(getfield(A(1),'ID','FileName')),' ',num2str(getfield(A(1),'ID','SeqID'))];
        Fiber2=[num2str(getfield(A(p+1),'ID','FileName')),' ',num2str(getfield(A(p+1),'ID','SeqID'))];
        ds1.filename=[Fiber1,' ', Fiber2];
        ds1.icell=[num2str(getfield(A(1),'ID','FileName')),' ',num2str(getfield(A(p+1),'ID','FileName'))];
        DeltaCF=log(CF2/CF1)/log(2);
        MeanCF=(CF1*CF2)^0.5;
        CFcombi(p)=struct('Fiber1',Fiber1,'Fiber2',Fiber2,'BF',BF,'BestITD',BestITD,'BP',BP,'CD',CD,'CP',CP,...
            'CF1',CF1,'CF2',CF2,'DeltaCF',DeltaCF,'MeanCF',MeanCF,'ds1',ds1,...
            'IPCx',IPCx,'IPCy',IPCy,'ISRx',ISRx,'ISRy',ISRy);
        if (CFcombi(p).DeltaCF>=-1/3)&(CFcombi(p).DeltaCF<=1/3)...
                &(min(CFcombi(p).IPCx)<=CFcombi(p).CF1)&(min(CFcombi(p).IPCx)<=CFcombi(p).CF2)...
                &(max(CFcombi(p).IPCx)>=CFcombi(p).CF1)&(max(CFcombi(p).IPCx)>=CFcombi(p).CF2)...
                &(CFcombi(p).CF1<=CFcombi(p).CF2)
            SIZE=size(CFcombiSelect);
            CFcombiSelect(SIZE(2)+1)=struct('Fiber1',CFcombi(p).Fiber1,'Fiber2',CFcombi(p).Fiber2,'BF',CFcombi(p).BF,'BestITD',CFcombi(p).BestITD,...
                'BP',CFcombi(p).BP,'CD',CFcombi(p).CD,'CP',CFcombi(p).CP,...
                'CF1',CFcombi(p).CF1,'CF2',CFcombi(p).CF2,'DeltaCF',CFcombi(p).DeltaCF,'MeanCF',CFcombi(p).MeanCF,'ds1',CFcombi(p).ds1,...
                'IPCx',CFcombi(p).IPCx,'IPCy',CFcombi(p).IPCy,'ISRx',CFcombi(p).ISRx,'ISRy',CFcombi(p).ISRy);
        end;
    end;
end;
for n=1:SIZE(2)
    x=CFcombiSelect(n).IPCx;y=CFcombiSelect(n).IPCy;X=CFcombiSelect(n).ISRx;Y=CFcombiSelect(n).ISRy;
    [YM,YMi]=max(Y);
    CFcombiSelect(n).BPr=CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*CFcombiSelect(n).BF;xb=CFcombiSelect(n).BF;yb=CFcombiSelect(n).BPr;
    CFcombiSelect(n).CF1p=CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*CFcombiSelect(n).CF1;x1=CFcombiSelect(n).CF1;y1=CFcombiSelect(n).CF1p;
    CFcombiSelect(n).CF2p=CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*CFcombiSelect(n).CF2;x2=CFcombiSelect(n).CF2;y2=CFcombiSelect(n).CF2p;
    plot(x,y);hold on;
    plot(X(YMi),y(YMi),'ro');
    plot(xb,yb,'m*','MarkerSize',12);
    plot(x1,y1,'k<');plot(x2,y2,'g>');
    line(x,CFcombiSelect(n).CP+(CFcombiSelect(n).CD/1000)*x,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);line(x3,(x3-xb)*(CFcombiSelect(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
end;
assignin('base','CFcombiSelect',CFcombiSelect);
end


    