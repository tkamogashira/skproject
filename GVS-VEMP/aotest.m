
ao=analogoutput('nidaq','Dev1');
chan=addchannel(ao,0:1);
fs=10000;
set(ao,'SampleRate',fs);
%set(ao,'TriggerType','Manual');
% duration=10;
% time=(0:(1/fs):duration);
% f=500;
% data=sin(2*pi*f*time)';
% putdata(ao,[data data]);
putdata(ao,[bn tr]);