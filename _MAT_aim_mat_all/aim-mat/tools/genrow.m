% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function res=genrow


s1=signal(0.3,16000); %erster Ton
s2=signal(0.3,16000); % zweiter Ton
s3=signal(0.3,16000); % 
s4=signal(0.3,16000); % 
s5=signal(0.3,16000); % 
s6=signal(0.3,16000); % 


s1=genharmonics(s1,'fundamental','100','min_fre','500','max_fre','3000');
s2=genharmonics(s1,'fundamental','100','min_fre','500','max_fre','3000','type','decreaseoddamplitude','changeby','-2');
s3=genharmonics(s1,'fundamental','100','min_fre','500','max_fre','3000','type','decreaseoddamplitude','changeby','-4');
s4=genharmonics(s1,'fundamental','100','min_fre','500','max_fre','3000','type','decreaseoddamplitude','changeby','-6');
s5=genharmonics(s1,'fundamental','100','min_fre','500','max_fre','3000','type','decreaseoddamplitude','changeby','-8');
s6=genharmonics(s1,'fundamental','100','min_fre','500','max_fre','3000','type','decreaseoddamplitude','changeby','-10');

rms1=rms(s1);
rms2=rms(s2);
rms3=rms(s3);
rms4=rms(s4);
rms5=rms(s5);
rms6=rms(s6);

rmsmax=max([rms1 rms2 rms3 rms4 rms5 rms6]);

s1=RampAmplitude(s1,0.05); % baue eine Rampe
s2=RampAmplitude(s2,0.05); % baue eine Rampe
s3=RampAmplitude(s3,0.05); % baue eine Rampe
s4=RampAmplitude(s4,0.05); % baue eine Rampe
s5=RampAmplitude(s5,0.05); % baue eine Rampe
s6=RampAmplitude(s6,0.05); % baue eine Rampe

s1=s1*(rmsmax/rms1);
s2=s2*(rmsmax/rms2);
s3=s3*(rmsmax/rms3);
s4=s4*(rmsmax/rms4);
s5=s5*(rmsmax/rms5);
s6=s6*(rmsmax/rms6);

signal res;
res=s1;
res=append(res,s2);
res=append(res,s3);
res=append(res,s4);
res=append(res,s5);
res=append(res,s6);
res=setname(res,'five sounds');

