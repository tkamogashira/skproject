function ComData = datasetcom2(varargin);
for i=1:length(varargin)
    for k=1:length(varargin)
        if k>i
            M(i,k)=1;
        else
            M(i,k)=0;
        end;
    end;
end;
[x,y]=find(M>0);N=[x';y'];assignin('base','N',N);
for p=1:size(N,2)
    [ArgOut,BF,BP,CD,CP,CF1,CF2]=EvalFS6(varargin{N(1,p)},varargin{N(2,p)}, 'plotmode', 'ALL');
    Fiber1=[num2str(getfield(varargin{N(1,p)},'ID','FileName')),' ',num2str(getfield(varargin{N(1,p)},'ID','SeqID'))];
    Fiber2=[num2str(getfield(varargin{N(2,p)},'ID','FileName')),' ',num2str(getfield(varargin{N(2,p)},'ID','SeqID'))];
    ds1.filename=[Fiber1,' ', Fiber2];
    ds1.icell=[num2str(getfield(varargin{N(1,p)},'ID','FileName')),' ',num2str(getfield(varargin{N(2,p)},'ID','FileName'))];
    DeltaCF=abs(log(CF2/CF1)/log(2));
    MeanCF=(CF1*CF2)^0.5;
    ComData(p)=struct('Fiber1',Fiber1,'Fiber2',Fiber2,'BF',BF,'BP',BP,'CD',CD,'CP',CP,'CF1',CF1,'CF2',CF2,'DeltaCF',DeltaCF,'MeanCF',MeanCF,'ds1',ds1);
    close all;
end;
assignin('base','ComData',ComData);
end


    