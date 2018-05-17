
ao=analogoutput('nidaq','Dev1');
chano=addchannel(ao,0:1);
fs=10000;
set(ao,'SampleRate',fs);
%set(ao,'TriggerType','Manual');
% duration=10;
% time=(0:(1/fs):duration);
% f=500;
% data=sin(2*pi*f*time)';
% putdata(ao,[data data]);
putdata(ao,[bn tr]);

ai=analoginput('nidaq','Dev1');
chani=addchannel(ai,0:1);

set(ai,'SampleRate',fs);
set(ai,'SamplesPerTrigger',37000);
set(ai,'Timeout',3.8);

set(ai,'TriggerChannel',chani(2));
set(ai,'TriggerType','Software');
set(ai,'TriggerCondition','Rising');
set(ai,'TriggerConditionValue',0.2);
set(ai,'TriggerRepeat',1);
