%  
% function sig=gen_multidamp(carriers,halflifes,reprate,signal_length, sample_fq)
%
%   Generates a superposition of damped sinusiod signals
%
%   INPUT VALUES:
% 		carriers        carrier frequences (vector)
%       halflifes       (vector, same length as carriers)
%       reprate         frequence of envelope
%       signal_length   in seconds !!!
%       sample_fq       sample frequence
%
%   RETURN VALUE:
%		sig             object signal
% 
% (c) 2003-2008, University of Cambridge, Medical Research Council 
% Christoph Lindner   
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=gen_multidamp(carriers,halflifes,reprate,signal_length, sample_fq)

if nargin < 5
    sample_fq=16000;
end
if nargin < 4
    signal_length=0.1;
end
if nargin < 3
    reprate=100;   
end
if nargin < 2
    hlsteps=1;
    halflifes=distributelogarithmic(0.064,0.0005,hlsteps);
    halflifes=0.005;
else
    hlsteps=length(halflifes);
end
if nargin < 1
    carsteps=5;
    carriers=distributelogarithmic(250,4000,carsteps);
else
    carsteps=length(carriers);
end

sr = sample_fq;
% sr=2^14;
% sr=16000;
% signal_length=0.264-1/sr;
sig=signal(signal_length,sr);

for i=1:hlsteps
    for j=1:carsteps
        current_carrier=carriers(j);
        halflife=halflifes(i);
        sig=generatedampsinus(sig,current_carrier,reprate,1,halflife);
        
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