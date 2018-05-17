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


function [data,samplerate,endian]=rawfile2wavfile(datafile,samplerate,endian)
% usage: wavdata=rawfile2wavfile(datafile,samplerate,endian)
% input: the name of a datafile and the samplerate
% endian is little or big endian to indicate byte order
% output: the vector of the data
% and the file "datafile" with the extension "wav"

if nargin< 2
    valid=0;
    while ~valid
        strsamplerate=input('please input samplerate (default: 20000)   ','s');
        if isempty(strsamplerate)
            strsamplerate = '20000';
        end
        samplerate=sscanf(strsamplerate,'%f');
        valid=(samplerate>0);
    end
end

if nargin< 3
    valid=0;
    while ~valid
        endian=input('please input endian: (l)ittle or (b)ig  (default: l)   ','s');
        if isempty(endian)
            endian = 'l';
        end
        valid=(size(endian,2)==1) & ((endian=='l') | (endian=='b'));
    end
end

try
    fid=fopen(datafile,'r',endian);
catch
    disp('rawfile2wavfile: could not open file');
    disp(datafile);
    return;
end

data=fread(fid,'integer*2');

% data=data/max(data)*0.9999;
data=data/32768;

[path,name,ext,versn] = fileparts(datafile);
newfilename=sprintf('%s.wav',name);
newname=fullfile(path,newfilename);

wavwrite(data,samplerate,newname);

