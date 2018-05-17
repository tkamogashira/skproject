% method of class @signal
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


function t=getzerocrossings(signal,var)
% gets the zero crossings of the signal.
% in Case, the Signal has many zeros and only few 
% bumps, like in a klicktrain, only the last zero is counted
% if var is there, then not real zero, but a value of var is taken

if nargin < 2 
    var=0;
end

werte=getdata(signal);

nr= getnrpoints(signal); % so many points
a=0;
count=1;
sr=getSR(signal);
for i=1:nr
    b=werte(i);
    if a <= var & b > var
        t(count)=bin2time(signal,i);
        count=count+1;
    end
    % shift the last values
    a=b;
end
