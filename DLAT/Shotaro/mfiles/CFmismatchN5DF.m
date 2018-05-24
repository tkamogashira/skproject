%CFmismatch
function DFcombiselect = CFmismatchN5DF(varargin);

N=length(varargin);
M=(1:1:N);
S=[varargin{1}];
for s=2:N
    S=[S varargin{s}];
end;
DFcombiSelect(1)=struct('Fiber1',[],'Fiber2',[],'BF',[],'BestITD',[],'BP',[],'CD',[],'CP',[],...
            'CF1',[],'CF2',[],'DeltaCF',[],'MeanCF',[],'ds1',[],...
            'IPCx',[],'IPCy',[],'ISRx',[],'ISRy',[],'DF1',[],'DF2',[],'DeltaDF',[]);
for q=1:N
    A=[S(q) S(find(M ~= q))];
    for p=1:(N-1)
        
        disp(sprintf(num2str(getfield(A(1),'ID','SeqID'))))
        disp(sprintf(num2str(getfield(A(p+1),'ID','SeqID'))))
        
        [ArgOut,BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy]=EvalFSphase2R(A(p+1),A(p+1),'plotmode','CC');
        DF1=BF;
        [ArgOut,BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy]=EvalFSphase2R(A(1),A(1),'plotmode','CC');
        DF2=BF;
        
        [ArgOut,BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy]=EvalFSphase2R(A(p+1),A(1), 'plotmode', 'ALL');
        Fiber1=[num2str(getfield(A(p+1),'ID','FileName')),' ',num2str(getfield(A(p+1),'ID','SeqID'))];
        Fiber2=[num2str(getfield(A(1),'ID','FileName')),' ',num2str(getfield(A(1),'ID','SeqID'))];
        ds1.filename=[Fiber1,' ', Fiber2];
        ds1.icell=[num2str(getfield(A(p+1),'ID','FileName')),' ',num2str(getfield(A(1),'ID','FileName'))];
        DeltaCF=log(CF2/CF1)/log(2);
        MeanCF=(CF1*CF2)^0.5;
        
        DeltaDF=log(DF2/DF1)/log(2);
        
        if (DeltaDF>=-1/3)&(DeltaDF<=1/3)&(DF1<=DF2)...
                &(min(IPCx)<=DF1)&(min(IPCx)<=DF2)...
                &(max(IPCx)>=DF1)&(max(IPCx)>=DF2)
            SIZE=size(DFcombiSelect);
            DFcombiSelect(SIZE(2)+1)=struct('Fiber1',Fiber1,'Fiber2',Fiber2,'BF',BF,'BestITD',BestITD,...
                'BP',BP,'CD',CD,'CP',CP,...
                'CF1',CF1,'CF2',CF2,'DeltaCF',DeltaCF,'MeanCF',MeanCF,'ds1',ds1,...
                'IPCx',IPCx,'IPCy',IPCy,'ISRx',ISRx,'ISRy',ISRy,'DF1',DF1,'DF2',DF2,'DeltaDF',DeltaDF);
        end;
    end;
end;

if SIZE(2)>=2
    for r=1:(SIZE(2)-1)
        DFcombiselect(r)=DFcombiSelect(r+1);
    end;
    
    for n=1:(SIZE(2)-1)
        x=DFcombiselect(n).IPCx;y=DFcombiselect(n).IPCy;X=DFcombiselect(n).ISRx;Y=DFcombiselect(n).ISRy;
        if (DFcombiselect(n).CP < -0.5)|(DFcombiselect(n).CP >= 0.5)
            DFcombiselect(n).CPr=DFcombiselect(n).CP-round(DFcombiselect(n).CP);
            y=y+(DFcombiselect(n).CPr-DFcombiselect(n).CP);
        else
            DFcombiselect(n).CPr=DFcombiselect(n).CP;
        end;
        
        [YM,YMi]=max(Y);
        DFcombiselect(n).BPr=DFcombiselect(n).CPr+(DFcombiselect(n).CD/1000)*DFcombiselect(n).BF
        ;xb=DFcombiselect(n).BF;yb=DFcombiselect(n).BPr;
        DFcombiselect(n).CF1p=DFcombiselect(n).CPr+(DFcombiselect(n).CD/1000)*DFcombiselect(n).CF1;
        x1=DFcombiselect(n).CF1;y1=DFcombiselect(n).CF1p;
        DFcombiselect(n).CF2p=DFcombiselect(n).CPr+(DFcombiselect(n).CD/1000)*DFcombiselect(n).CF2;
        x2=DFcombiselect(n).CF2;y2=DFcombiselect(n).CF2p;
        
        DFcombiselect(n).DF1p=DFcombiselect(n).CPr+(DFcombiselect(n).CD/1000)*DFcombiselect(n).DF1;
        xd1=DFcombiselect(n).DF1;yd1=DFcombiselect(n).DF1p;
        DFcombiselect(n).DF2p=DFcombiselect(n).CPr+(DFcombiselect(n).CD/1000)*DFcombiselect(n).DF2;
        xd2=DFcombiselect(n).DF2;yd2=DFcombiselect(n).DF2p;
        
        plot(x,y);hold on;
        plot(X(YMi),y(YMi),'ro');
        plot(xb,yb,'m*','MarkerSize',12);
        plot(x1,y1,'k<');plot(x2,y2,'g>');
        
        plot(xd1,yd1,'y<');plot(xd2,yd2,'c>');
        
        xk=(0:10:max(x));
        yk=DFcombiselect(n).CPr+(DFcombiselect(n).CD/1000)*xk;
        line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
        x3=(xb-100:10:xb+100);
        line(x3,(x3-xb)*(DFcombiselect(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
    end;
    assignin('base','DFcombiselect',DFcombiselect);
end;
end


    