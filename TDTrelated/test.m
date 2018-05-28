%PA5

%PA5=actxcontrol('PA5.x',[5 5 26 26]);
%invoke(PA5,'ConnectPA5','USB');
%invoke(PA5,'SetAtten',50);

RP2=actxcontrol('RPco.x',[5 5 26 26]);
invoke(RP2,'ConnectRP2','USB',1);
invoke(RP2,'ClearCOF');
invoke(RP2,'LoadCOF','test.rcx');
invoke(RP2,'Run');
Status=invoke(RP2,'GetStatus')
Fs=invoke(RP2,'GetSFreq')

while 1
    freq=input('Enter freq (0 to quit):');
    if freq
        invoke(RP2,'SetTagVal','Freq',freq);
    else
        break;
    end
    invoke(RP2,'SoftTrg',1);
end