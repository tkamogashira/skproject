%CFmismatch
function CFcombiselect = CFmismatchN4reverse(varargin);

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
        if (DeltaCF>=-1/3)&(DeltaCF<=1/3)...
                &(min(IPCx)<=CF1)&(min(IPCx)<=CF2)...
                &(max(IPCx)>=CF1)&(max(IPCx)>=CF2)...
                &(CF1>CF2)
            SIZE=size(CFcombiSelect);
            CFcombiSelect(SIZE(2)+1)=struct('Fiber1',Fiber1,'Fiber2',Fiber2,'BF',BF,'BestITD',BestITD,...
                'BP',BP,'CD',CD,'CP',CP,...
                'CF1',CF1,'CF2',CF2,'DeltaCF',DeltaCF,'MeanCF',MeanCF,'ds1',ds1,...
                'IPCx',IPCx,'IPCy',IPCy,'ISRx',ISRx,'ISRy',ISRy);
        end;
    end;
end;

if SIZE(2)>=2
    for r=1:(SIZE(2)-1)
        CFcombiselect(r)=CFcombiSelect(r+1);
    end;
    
    for n=1:(SIZE(2)-1)
        x=CFcombiselect(n).IPCx;y=CFcombiselect(n).IPCy;X=CFcombiselect(n).ISRx;Y=CFcombiselect(n).ISRy;
        if (CFcombiselect(n).CP < -0.5)|(CFcombiselect(n).CP >= 0.5)
            CFcombiselect(n).CPr=CFcombiselect(n).CP-round(CFcombiselect(n).CP);
            y=y+(CFcombiselect(n).CPr-CFcombiselect(n).CP);
        else
            CFcombiselect(n).CPr=CFcombiselect(n).CP;
        end;
        
        [YM,YMi]=max(Y);
        CFcombiselect(n).BPr=CFcombiselect(n).CPr+(CFcombiselect(n).CD/1000)*CFcombiselect(n).BF
        ;xb=CFcombiselect(n).BF;yb=CFcombiselect(n).BPr;
        CFcombiselect(n).CF1p=CFcombiselect(n).CPr+(CFcombiselect(n).CD/1000)*CFcombiselect(n).CF1;
        x1=CFcombiselect(n).CF1;y1=CFcombiselect(n).CF1p;
        CFcombiselect(n).CF2p=CFcombiselect(n).CPr+(CFcombiselect(n).CD/1000)*CFcombiselect(n).CF2;
        x2=CFcombiselect(n).CF2;y2=CFcombiselect(n).CF2p;
        
        
        plot(x,y);hold on;
        plot(X(YMi),y(YMi),'ro');
        plot(xb,yb,'m*','MarkerSize',12);
        plot(x1,y1,'k<');plot(x2,y2,'g>');
        xk=(0:10:max(x));
        yk=CFcombiselect(n).CPr+(CFcombiselect(n).CD/1000)*xk;
        line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
        x3=(xb-100:10:xb+100);
        line(x3,(x3-xb)*(CFcombiselect(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
    end;
    assignin('base','CFcombiselect',CFcombiselect);
end;
end


    