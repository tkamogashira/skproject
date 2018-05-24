DBB2=DBB([1:216 218:219 221:252 255:298 300:330 332:340]);


BBICselect(1)=struct('ThrCF',[],'DomF',[],'RateBF',[],'sigpX',[],'sigpY',[],'lineX',[],'lineY',[],'CD',[],'CP',[],'BestITD',[]);

SIZE=size(DBB2);

for h=1:SIZE(2)
    disp(sprintf(num2str(h)))
   
    ds=dataset(DBB2(h).ds1.filename,DBB2(h).ds1.seqid);
    [ArgOut,ThrCF,DomF,RateBF,sigpX,sigpY,lineX,lineY,CD,CP,BestITD] = EvalBB2(ds);
    BBICselect(h)=struct('ThrCF',ThrCF,'DomF',DomF,'RateBF',RateBF,'sigpX',sigpX,'sigpY',sigpY,'lineX',lineX,'lineY',lineY,'CD',CD,'CP',CP,'BestITD',BestITD);
    close all
    clear ds;
end;
assignin('base','BBICselect',BBICselect);

