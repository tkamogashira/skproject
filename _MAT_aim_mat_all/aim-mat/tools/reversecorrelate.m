% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=reversecorrelate(a,st,von,bis)
% signal muss ein Signal sein
% st muss ein Spiketrain sein
% das Ergebnissignal hat die Länge bis-von

if ~isobject(a)
    disp('error: Signal must be an Object signal')
end

if nargin < 4
    bis=0.01;  %standart: 10 ms nach 0
end

if nargin < 3
    von=-0.05;  %standart: 50 ms vor 0
end


duration=bis-von;   % so lang ist das ErgebnisSignal
sr=getsr(a);
sig=signal(duration,sr); %mache ein neues Signal
nrpoints=getnrpoints(sig);

nr_spikes=length(st);
orglen=GetLength(a);

for i=1:nr_spikes
    spiketime=st(i);
    start=spiketime+von;
    stop=spiketime+bis;
    off=0;
    if start<0
        off=-start;
        start=0;
    end    
    if stop>orglen-1/sr
        stop=orglen-1/sr;
    end
    temp=getpart(a,start,stop);
    sig=add(sig,temp,off);
end

sig=getpart(sig,0,duration);
sig=setstarttime(sig,von);
