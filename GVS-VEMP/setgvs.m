ao=analogoutput('nidaq','Dev1');
chan=addchannel(ao,0:1);

set(ao,'SampleRate',Fs);
set(ao,'TriggerType','Manual');
% duration=10;
% time=(0:(1/fs):duration);
% f=500;
% data=sin(2*pi*f*time)';
% putdata(ao,[data data]);
putdata(ao,[bn tr]);