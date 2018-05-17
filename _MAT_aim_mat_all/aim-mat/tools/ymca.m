% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=ymca()

f1=494;
f2=587.3;
f3=659.25;
d1=0.25;
d2=0.5;
d3=1;
sr=16000;


tune='ccdec';



% clicktrain
% c1=clicktrain(d1,sr,f1);
% c2=clicktrain(d1,sr,f2);
% c3=clicktrain(d2,sr,f2);
% c4=clicktrain(d3,sr,f3);
% c5=clicktrain(d1,sr,f3);

% sinus
% c1=sinus(d1,sr,f1);
% c2=sinus(d1,sr,f2);
% c3=sinus(d2,sr,f2);
% c4=sinus(d3,sr,f3);
% c5=sinus(d1,sr,f3);

% harmonic
c1=signal(d1,sr);
c2=signal(d1,sr);
c3=signal(d2,sr);
c4=signal(d3,sr);
c5=signal(d1,sr);


bandwidth=1000; %fixed
df1=256;
df2=512;
fc=1000;
% 
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d1,sr,f1,fc,df1,bandwidth,df2);
% eval(sprintf('c1=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d1,sr,f2,fc,df1,bandwidth,df2);
% eval(sprintf('c2=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d2,sr,f2,fc,df1,bandwidth,df2);
% eval(sprintf('c3=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d3,sr,f3,fc,df1,bandwidth,df2);
% eval(sprintf('c4=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d1,sr,f3,fc,df1,bandwidth,df2);
% eval(sprintf('c5=%s;',s));

f0=125;
a=3;
s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d1,sr,f0,a*f1,df1,bandwidth,df2);
eval(sprintf('c1=%s;',s));
s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d1,sr,f0,a*f2,df1,bandwidth,df2);
eval(sprintf('c2=%s;',s));
s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d2,sr,f0,a*f2,df1,bandwidth,df2);
eval(sprintf('c3=%s;',s));
s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d3,sr,f0,a*f3,df1,bandwidth,df2);
eval(sprintf('c4=%s;',s));
s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',d1,sr,f0,a*f3,df1,bandwidth,df2);
eval(sprintf('c5=%s;',s));

% f0=125;
% a=3;
% type='decreaseoddamplitude';
% amp1=0;
% amp2=-4;
% amp3=-8;
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d1,sr,f0,fc,df1,bandwidth,df2,type,amp1);
% eval(sprintf('c1=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d1,sr,f0,fc,df1,bandwidth,df2,type,amp2);
% eval(sprintf('c2=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d2,sr,f0,fc,df1,bandwidth,df2,type,amp2);
% eval(sprintf('c3=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d3,sr,f0,fc,df1,bandwidth,df2,type,amp3);
% eval(sprintf('c4=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d1,sr,f0,fc,df1,bandwidth,df2,type,amp3);
% eval(sprintf('c5=%s;',s));

% f0=125;
% a=3;
% type='decreaseoddphase';
% phase1=0;
% phase2=40;
% phase3=70;
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d1,sr,f0,fc,df1,bandwidth,df2,type,phase1);
% eval(sprintf('c1=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d1,sr,f0,fc,df1,bandwidth,df2,type,phase2);
% eval(sprintf('c2=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d2,sr,f0,fc,df1,bandwidth,df2,type,phase2);
% eval(sprintf('c3=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d3,sr,f0,fc,df1,bandwidth,df2,type,phase3);
% eval(sprintf('c4=%s;',s));
% s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f],''type'',''%s'',''changeby'',''%f'');',d1,sr,f0,fc,df1,bandwidth,df2,type,phase3);
% eval(sprintf('c5=%s;',s));



c1=rampamplitude(c1,0.02);
c2=rampamplitude(c2,0.02);
c3=rampamplitude(c3,0.02);
c4=rampamplitude(c4,0.02);
c5=rampamplitude(c5,0.02);
sig=c1;
sig=append(sig,c2);
sig=append(sig,c1);
sig=append(sig,c2);
sig=append(sig,c1);
sig=append(sig,c3);
sig=append(sig,c4);
sig=append(sig,c3);
sig=append(sig,c5);
sig=append(sig,c2);
