duration=5;
AI=analoginput('contec','AIO000');
addchannel(AI,0);
set(AI,'SampleRate',50000);
actualRate=get(AI,'SampleRate');
samples=round(duration*actualRate);
set(AI,'SamplesPerTrigger',samples);
set(AI,'InputType','SingleEnded');

set(AI,'TriggerType','Software');
set(AI,'TriggerChannel',0);
set(AI,'TriggerCondition','Rising');
set(AI,'TriggerConditionValue',4);%5V trigger
set(AI,'TriggerDelayUnits','Seconds');
set(AI,'TriggerDelay',-0.1);


AO=analogoutput('contec','AIO000');
chan=addchannel(AO,0:1);
%chan=addchannel(AO,0);
%duration=10;
set(AO,'SampleRate',2000);
set(AO,'TriggerType','Manual');
%ActualRate=get(AO,'SampleRate');
%len=ActualRate*duration;
time=(0:(1/2000):10);
data=sin(2*pi*10*time)';
leng=length(data);

data=data(1:(leng-1),:);
putdata(AO,[data data])
%putdata(AO,data)
start(AO)

start(AI);
trigger(AI);
trigger(AO);


