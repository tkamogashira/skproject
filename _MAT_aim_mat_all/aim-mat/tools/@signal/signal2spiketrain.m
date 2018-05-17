% method of class @signal
% function st=signal2spiketrain(sig)
%   INPUT VALUES:
%       sig:       original @signal
%   RETURN VALUE:
% 		st: @spiketrain
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function st=signal2spiketrain(sig)
% translates a signal in an spiketrain

nr=getnrpoints(sig);
vals=getvalues(sig);

%spks=zeros(1000,1);

count=1;
for i=1:nr
    if vals(i)>0
        for j=1:vals(i)
            %st=addspike(st,vals(i));
            spks(count)=bin2time(sig,i);
            count=count+1;
        end
    end
end


st=spiketrain(spks);



