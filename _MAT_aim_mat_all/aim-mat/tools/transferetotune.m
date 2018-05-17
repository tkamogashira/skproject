% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=transferetotune(tune,art)

% Tonlength: 
% a=0.25
% b=0.5
% c=1
if nargin < 1
    % tunes:
    % Yankee Doodle
    tune='aC5aC5aD5aE5aC5aE5aD5aG4aC5aC5aD5aE5aC5aC5aB4aG4aC5aC5aD5aE5aF5aE5aD5aC5aB4aG4aA4aB4aC5aC5aC5aC5';
    % Frere Jackes
    tune='aC5aD5aE5aC5aC5aD5aE5aC5aE5aF5aG5aE5aF5aG5');
end

if nargin<2
%     art='decreaseoddamplitude';
    art='decreaseoddphase';
%     art='sinus';
%     art='harmonic';
%     art='clicktrain';
end

nr=size(tune,2);
duration=0.25;
sr=16000;
sig=signal(0,sr);

count=1;
notecount=0;
while count < nr-2
    cur=tune(count);
    if cur~='a' & cur~='b' & cur~='c' 
        error('Error in tune');
    else
        if cur=='a'        duration=0.25;end
        if cur=='b'        duration=0.5;end
        if cur=='c'        duration=1;end
    end
    cur1=tune(count+1);
    if cur1=='P';
        fre=0;
        count=count+2;
    else
        cur2=tune(count+2);
        if count<nr-2
            cur3=tune(count+3);
            if strcmp(cur3,'#');
                current=[cur1 cur2 cur3];
                count=count+4;
                notecount=notecount+1;
            else
                current=[cur1 cur2];
                count=count+3;
                notecount=notecount+1;
            end
        else
            current=[cur1 cur2];
            count=count+3;
            notecount=notecount+1;
        end
        fre=note2fre(current);
    end
    freq(notecount)=fre;
end

mifre=min(freq);
for i=1:notecount
    octab(i)=log2(freq(i)/mifre);
end
maxoct=max(octab);
for i=1:notecount
    atten(i)=-(maxoct-octab(i))*20;
    phase(i)=(maxoct-octab(i))*80;
end

for i=1:notecount
    fre=freq(i);
    if fre==0
        ton=signal(duration,sr);
    else
        switch art
        case 'sinus'
            ton=sinus(duration,sr,fre);
        case 'clicktrain'
            ton=clicktrain(duration,sr,fre);
        case 'harmonic'
            bandwidth=1000; %fixed
            df1=256;
            df2=512;
            fc=1000;
            s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''filterprop'',[%f %f %f %f]);',duration,sr,fre,fc,df1,bandwidth,df2);
            eval(sprintf('ton=%s;',s));
        case 'decreaseoddamplitude'
            bandwidth=2000; %fixed
            f0=125;
            df1=256;
            df2=512;
            fc=1000;
            type='decreaseoddamplitude';
            amp=atten(i);
            s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''type'',''%s'',''changeby'',''%f'',''filterprop'',[%f %f %f %f]);',duration,sr,f0,type,amp,fc,df1,bandwidth,df2);
            eval(sprintf('ton=%s;',s));
        case 'decreaseoddphase'
            bandwidth=2000; %fixed
            f0=125;
            df1=256;
            df2=512;
            fc=1000;
            type='decreaseoddphase';
            amp=phase(i);
            s=sprintf('genharmonics(signal(%f,%f),''fundamental'',''%f'',''type'',''%s'',''changeby'',''%f'',''filterprop'',[%f %f %f %f]);',duration,sr,f0,type,amp,fc,df1,bandwidth,df2);
            eval(sprintf('ton=%s;',s));
        end
    end
    ton=rampamplitude(ton,0.02);
    sig=append(sig,ton);
end

a=0;
