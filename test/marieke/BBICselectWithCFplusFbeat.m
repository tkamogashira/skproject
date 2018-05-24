DBB2=DBB([1:216 218:219 221:252 255:298 300:330 332:340]);


SIZE=size(DBB2);

for h=1:SIZE(2)
    disp(sprintf(num2str(h)))
    Ads=dataset(DBB2(h).ds1.filename,DBB2(h).ds1.seqid);
    BBICselectWithCF(h).fbeat=(Ads.fbeat)';
    
end;


assignin('base','BBICselectWithCF',BBICselectWithCF);

