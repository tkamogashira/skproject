
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