%PA5

%PA5=actxcontrol('PA5.x',[5 5 26 26]);
%invoke(PA5,'ConnectPA5','USB');
%invoke(PA5,'SetAtten',50);

RP2=actxcontrol('RPco.x',[5 5 26 26]);
invoke(RP2,'ConnectRP2','USB',1);
invoke(RP2,'ClearCOF');
invoke(RP2,'LoadCOF','test3.rcx');
invoke(RP2,'Run');
Status=invoke(RP2,'GetStatus')
Fs=invoke(RP2,'GetSFreq')
invoke(RP2,'SoftTrg',2)

freq=input('Enter freq (0 to quit):');
invoke(RP2,'SetTagVal','Freq',freq);

invoke(RP2,'SoftTrg',1);
resulttone=invoke(RP2,'ReadTagV','resulttone',0,100);
%indexcount=invoke(RP2,'ReadTagV','indexcount',0,1000);
s=size(resulttone,2);%si=size(indexcount,2);
plot([1:1:s],resulttone,'b');hold on;
%plot([1:1:si],indexcount,'ro');
hold off;
assignin('base','resulttone',resulttone);
%assignin('base','indexcount',indexcount);    