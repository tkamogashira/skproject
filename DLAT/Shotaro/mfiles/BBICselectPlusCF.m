DBB2=DBB([1:216 218:219 221:252 255:298 300:330 332:340]);


SIZE=size(DBB2);

for h=1:SIZE(2)
    disp(sprintf(num2str(h)))
    
    BBICselect(h).ds1.filename=DBB2(h).ds1.filename;
    BBICselect(h).ds1.icell=DBB2(h).ds1.icell;
    BBICselect(h).ds1.iseq=DBB2(h).ds1.iseq;
    BBICselect(h).ds1.seqid=DBB2(h).ds1.seqid;
    
    BBICselect(h).ds2.iseq=DBB2(h).ds2.iseq;
    BBICselect(h).ds2.seqid=DBB2(h).ds2.seqid;
    
    BBICselect(h).ThrCF=DBB2(h).thr.cf;
    
    if (BBICselect(h).CP < -0.5)|(BBICselect(h).CP >= 0.5)
        BBICselect(h).CPr=BBICselect(h).CP-round(BBICselect(h).CP);
        
        Dif=BBICselect(h).CPr-BBICselect(h).CP;
        
        size1=size(BBICselect(h).sigpY);
        BBICselect(h).sigpYr=BBICselect(h).sigpY+ones(1,size1(2))*Dif;
        
        size2=size(BBICselect(h).lineY);
        BBICselect(h).lineYr=BBICselect(h).lineY+ones(1,size2(2))*Dif;
        
    else
        BBICselect(h).CPr=BBICselect(h).CP;
        BBICselect(h).sigpYr=BBICselect(h).sigpY;
        BBICselect(h).lineYr=BBICselect(h).lineY;
    end;
    
end;


assignin('base','BBICselectWithCF',BBICselect);

