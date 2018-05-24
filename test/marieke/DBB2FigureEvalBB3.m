DBB2=DBB([1:216 218:219 221:252 255:298 300:330 332:340]);


BBICselectBB3(1)=struct('Filename',[],'Seqid',[],'ThrCF',[],'DomF',[],'RateBF',[],'sigpX',[],'sigpY',[],'lineX',[],'lineY',[],'CD',[],'CP',[],...
    'sigmX',[],'sigmY',[],'pLinReg',[],'Mserr',[],'allX',[],'allY',[],'VSBF',[]);

SIZE=size(DBB2);

for h=1:SIZE(2)
    disp(sprintf(num2str(h)))
   
    ds=dataset(DBB2(h).ds1.filename,DBB2(h).ds1.seqid);
    [ArgOut,ThrCF,DomF,RateBF,sigpX,sigpY,lineX,lineY,CD,CP,sigmX,sigmY,pLinReg_,Mserr_,allX,allY,VSBF] = EvalBB3(ds);
    BBICselectBB3(h).Filename=DBB2(h).ds1.filename;
    BBICselectBB3(h).Seqid=DBB2(h).ds1.seqid;
    BBICselectBB3(h).ThrCF=DBB2(h).thr.cf;
    BBICselectBB3(h).DomF=DomF;
    BBICselectBB3(h).RateBF=RateBF;
    BBICselectBB3(h).sigpX=sigpX;
    BBICselectBB3(h).sigpY=sigpY;
    BBICselectBB3(h).lineX=lineX;
    BBICselectBB3(h).lineY=lineY;
    BBICselectBB3(h).CD=CD;
    BBICselectBB3(h).CP=CP;
    BBICselectBB3(h).sigmX=sigmX;
    BBICselectBB3(h).sigmY=sigmY;
    BBICselectBB3(h).pLinReg=pLinReg_;
    BBICselectBB3(h).Mserr=Mserr_;
    BBICselectBB3(h).allX=allX;
    BBICselectBB3(h).allY=allY;
    BBICselectBB3(h).VSBF=VSBF;
    
    %BBICselectBB3(h)=struct('DomF',DomF,'RateBF',RateBF,'sigpX',sigpX,'sigpY',sigpY,'lineX',lineX,'lineY',lineY,'CD',CD,'CP',CP,...
        %'sigmX',sigmX,'sigmY',sigmY,'pLinReg_',pLinReg_,'Mserr_',Mserr_);
    
    
    
    close all
    clear ds;
end;
assignin('base','BBICselectBB3',BBICselectBB3);

