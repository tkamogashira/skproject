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


function res=genton(nr_comps,nr_harm,f0,len)

if nargin < 4
    len=0.3;
end

s1=signal(len,16000); %erster Ton

fundamental=f0;
fcs=nr_harm*f0;
bandwidth=(nr_comps-1)*f0;
s=sprintf('sig=genharmonics(s1,''fundamental'',''%f'',''filterprop'',[%f 1 %f 1]);',fundamental,fcs,bandwidth);
eval(s);

sig=scaletomaxvalue(sig,1);
sig=RampAmplitude(sig,0.01); % baue eine Rampe

sig=setname(sig,sprintf('Fundamental:%dHz',round(f0)));
res=sig;