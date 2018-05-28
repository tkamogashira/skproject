% BB_QUESTwith2AFC
function Q=BB_QUESTwith2AFC(MM,SD)
time=(1:(1/8192):3);
NoBB=[(sin(2*pi*time*250))' (sin(2*pi*time*250))'];
ISI2s=zeros([(8192*2),2]);

tGuess=20*log10(MM/250);
tGuessSd=20*log10((250+SD)/250)-20*log10(250/250);
pThreshold=0.92;
beta=3.5;
delta=0.01;
gamma=0.5;
q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma);

for k=1:10
    tTest=QuestMode(q);
    Fx=250*(10^(tTest/20));
    BB=[(sin(2*pi*time*250))' (sin(2*pi*time*Fx))'];
    BBinterval=unidrnd(2);
    if BBinterval==1
        Trial=[BB;ISI2s;NoBB];
    else
        Trial=[NoBB;ISI2s;BB];
    end;
    sound(Trial)
    Ans=input('Which is BB? the former (1) or latter (2) ?');
    if Ans==BBinterval
       response=1;
    else
       response=0;
    end;
    disp(['Trial ' num2str(k) ' at ' num2str(tTest) ' dB (' num2str(250*(10^(tTest/20))) ' Hz) has response ' num2str(response) ]);
    q=QuestUpdate(q,tTest,response);
    Q((1:length(q)),k)=q;
end;

t=QuestMean(q);
Ft=250*(10^(t/20));
sd=QuestSd(q);

disp(['Maximum likelihood estimate is ' num2str(t) ' dB (' num2str(Ft) ' Hz)']);
