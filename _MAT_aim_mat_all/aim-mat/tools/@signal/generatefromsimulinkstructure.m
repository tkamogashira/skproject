% method of class @signal
% function sig=generatefromsimulinkstructure(sig,struct)
%   INPUT VALUES:
%       sig: original @signal with length and samplerate 
%       struct: struct, that is exported from simulink
% 
%   RETURN VALUE:
%       sig:  @signal 
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=generatefromsimulinkstructure(sig,struct)

%sr=struct.time(2)-struct.time(1);
sr=1;
len=length(struct.signals(1).values)*sr;
vals=struct.signals(1).values;

if size(vals,1)>1 & size(vals,2) > 1
    vals=vals(end,:);
end

sig=signal(size(vals,2),1/sr);
sig=setvalues(sig,vals);

%sig=signal(vals);
%sig=setsr(sig,1/sr);
sig=setname(sig,struct.blockName);

