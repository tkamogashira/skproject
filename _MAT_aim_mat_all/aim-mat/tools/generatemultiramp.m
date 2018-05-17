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


function sig=generatemultiramp(carriers,halflifes,reprate,signal_length)

if nargin < 4
    signal_length=0.128;
end
if nargin < 3
    reprate=62.5;   
end
if nargin < 2
    hlsteps=8;
    halflives=distributelogarithmic(0.064,0.0005,hlsteps);
else
    hlsteps=length(halflifes);
end
if nargin < 1
    carsteps=5;
    carriers=distributelogarithmic(250,4000,carsteps);
else
    carsteps=length(carriers);
end


sr=16000;
% signal_length=0.264-1/sr;
sig=signal(signal_length,sr);

for i=1:hlsteps
    for j=1:carsteps
        current_carrier=carriers(j);
        halflife=halflifes(i);
        sig=generaterampsinus(sig,current_carrier,reprate,1,halflife);
        
        if j==1
            gsig=sig;
        else
            gsig=gsig+sig;
        end
    end
    
    if i==1
        tsig=gsig;
    else
        tsig=append(tsig,gsig);
    end
    
end
% savewave(tsig,'tsig');


sig=tsig;