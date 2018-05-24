function AA=DFall(varargin)
S=[varargin{1}];
N=length(varargin);
for s=2:N
    S=[S varargin{s}];
end;

for z=1:length(varargin)
    disp(sprintf((inputname(z))))
    AA=[num2str(getfield(S(z),'ID','SeqID'))];
    [ArgOut,BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy]=EvalFSphase2R(S(z),S(z),'plotmode','CC');
    
    Fiber1=[num2str(getfield(S(z),'ID','FileName')),' ',num2str(getfield(S(z),'ID','SeqID'))];
    DFall(z)=struct('Fiber1',Fiber1,'DF',BF);
    
end;
assignin('base','DFall',DFall);
end    



    