%CFmismatch
function CFcombi = CFmismatchR(varargin);


for p=1:(length(varargin)-1)
    [ArgOut,BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy]=EvalFSphase2R(varargin{1},varargin{p+1}, 'plotmode', 'ALL');
    Fiber1=[num2str(getfield(varargin{1},'ID','FileName')),' ',num2str(getfield(varargin{1},'ID','SeqID'))];
    Fiber2=[num2str(getfield(varargin{p+1},'ID','FileName')),' ',num2str(getfield(varargin{p+1},'ID','SeqID'))];
    ds1.filename=[Fiber1,' ', Fiber2];
    ds1.icell=[num2str(getfield(varargin{1},'ID','FileName')),' ',num2str(getfield(varargin{p+1},'ID','FileName'))];
    DeltaCF=log(CF2/CF1)/log(2);
    MeanCF=(CF1*CF2)^0.5;
    CFcombi(p)=struct('Fiber1',Fiber1,'Fiber2',Fiber2,'BF',BF,'BestITD',BestITD,'BP',BP,'CD',CD,'CP',CP,...
        'CF1',CF1,'CF2',CF2,'DeltaCF',DeltaCF,'MeanCF',MeanCF,'ds1',ds1,...
        'IPCx',IPCx,'IPCy',IPCy,'ISRx',ISRx,'ISRy',ISRy);
    close all;
end;


SIZE=size(CFcombi);
for n=1:SIZE(2)
    x=CFcombi(n).IPCx;y=CFcombi(n).IPCy;X=CFcombi(n).ISRx;Y=CFcombi(n).ISRy;
    if (CFcombi(n).CP < -0.5)|(CFcombi(n).CP >= 0.5)
        CFcombi(n).CPr=CFcombi(n).CP-round(CFcombi(n).CP);
        y=y+(CFcombi(n).CPr-CFcombi(n).CP);
    else
        CFcombi(n).CPr=CFcombi(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    CFcombi(n).BPr=CFcombi(n).CPr+(CFcombi(n).CD/1000)*CFcombi(n).BF
    ;xb=CFcombi(n).BF;yb=CFcombi(n).BPr;
    CFcombi(n).CF1p=CFcombi(n).CPr+(CFcombi(n).CD/1000)*CFcombi(n).CF1;
    x1=CFcombi(n).CF1;y1=CFcombi(n).CF1p;
    CFcombi(n).CF2p=CFcombi(n).CPr+(CFcombi(n).CD/1000)*CFcombi(n).CF2;
    x2=CFcombi(n).CF2;y2=CFcombi(n).CF2p;
        
    if (CFcombi(n).DeltaCF>=-1/3)&(CFcombi(n).DeltaCF<=1/3)...
            &(min(x)<=CF1)&(min(x)<=CF2)...
            &(max(x)>=CF1)&(max(x)>=CF2)
        plot(x,y);hold on;
        plot(X(YMi),y(YMi),'ro');
        plot(xb,yb,'m*','MarkerSize',12);
        plot(x1,y1,'k<');plot(x2,y2,'g>');
        xk=(0:10:max(x));
        yk=CFcombi(n).CPr+(CFcombi(n).CD/1000)*xk;
        line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
        x3=(xb-100:10:xb+100);
        line(x3,(x3-xb)*(CFcombi(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
    end;
end;
assignin('base','CFcombi',CFcombi);
end


    