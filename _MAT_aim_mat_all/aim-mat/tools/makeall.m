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


fundamental=125;
fc=[500 1000 2000];

% bandwidthtype='linear';
bandwidthtype='linear';
bandwidth_first=2000;
bandwidth_scale=2.2;


phase=[50 80];
amplitude=[-4 -10];


nr_amps=size(amplitude,2);
nr_fre=size(fc,2);
nr_phase=size(phase,2);

bandwidth=bandwidth_first;

for i=1:nr_fre
    fcs=fc(i);

%     name=sprintf('sound(cf=%4.0f,bw=%4.0f)',fcs,bandwidth);
    name=sprintf('PAsdgsdgsound(cf=%4.0f,bw=%4.0f)',fcs,bandwidth);
    s=sprintf('genharmonics(signal(0.5,16000),''fundamental'',''%f'',''filterprop'',[%f 256 %f 512]);',fundamental,fcs,bandwidth);
    ss=sprintf('%s=%s','tsig',s);
    eval(ss);
    tsig=scaletorms(tsig,0.1);
    tsig=rampamplitude(tsig,0.05);
    writetowavefile(tsig,name);    
    return
    
    str_amp='decreaseoddamplitude';
    for j=1:nr_amps
        changeby=amplitude(j);
        name=sprintf('sound(cf=%4.0f,amp=%3.0f,bw=%4.0f)',fcs,changeby,bandwidth);
        s=sprintf('genharmonics(signal(0.5,16000),''fundamental'',''%f'',''type'',''%s'',''changeby'',''%f'',''filterprop'',[%f 256 %f 512]);',fundamental,str_amp,changeby,fcs,bandwidth);
        ss=sprintf('%s=%s','tsig',s);
        eval(ss);
        tsig=scaletorms(tsig,0.1);
        tsig=rampamplitude(tsig,0.05);
        writetowavefile(tsig,name);    
    end
    
    str_amp='decreaseoddphase';
    for j=1:nr_phase
        changeby=phase(j);
        name=sprintf('sound(cf=%4.0f,phase=%3.0f,bw=%4.0f)',fcs,changeby,bandwidth);
        s=sprintf('genharmonics(signal(0.5,16000),''fundamental'',''%f'',''type'',''%s'',''changeby'',''%f'',''filterprop'',[%f 256 %f 512]);',fundamental,str_amp,changeby,fcs,bandwidth);
        ss=sprintf('%s=%s','tsig',s);
        eval(ss);
        tsig=scaletorms(tsig,0.1);
        tsig=rampamplitude(tsig,0.05);
        writetowavefile(tsig,name);    
    end
    
    if strcmp(bandwidthtype,'linear')
        bandwidth=bandwidth_first;
    else
        bandwidth=bandwidth*bandwidth_scale;
    end

end

