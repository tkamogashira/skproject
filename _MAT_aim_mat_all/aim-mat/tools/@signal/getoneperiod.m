% method of class @signal
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


function per=getoneperiod(signal,risetime)
% returns one period of the signal
% to find out about periodicy, the maxima are searched
% from risetime s after the beginning (because of the rise time)

if nargin < 2
    risetime=0.01;   % default: 10 ms
end

% the maxima are received by the hilbert envelope
h=hilbertenvelope(signal);
maxsi=max(h);
% to get good maxima, we need to define some threshold, when a maximum is a real maximum
% lets take 10 percent...

% [lmax,tmax]=getlocalmaxima(h,maxsi/1000000);    %returns all the local maxima and the corresponding times
[lmax,tmax]=getlocalmaxima(h,maxsi/10);    %returns all the local maxima and the corresponding times
% tmax=getzerocrossings(h,maxsi/100);    %returns all the local maxima and the corresponding times

% zweite Möglichkeit: mache die FFT der Hilberteinhüllenden und schaue nach dem höchsten peak
% geht nicht, da die Auflösung viel zu schlecht ist (96kHz->10 Hz Auflösungsvermögen)

nrmax=size(tmax,2);
if  nrmax < 2   % keine Periodizität
    per=0;
    return;
end

i=1;
% suche in einer Schleife die ersten beiden Maxima hinter der Anstiegszeit
while i < nrmax 
    if tmax(i) > risetime % hinter der Anstiegszeit
        if i<nrmax 
            t1=tmax(i); % der erste Hügel
            t2=tmax(i+1); % der zweite Hügel -> dazwischen ist die Periode
            break;
        end
    end
    i=i+1;
end

dauer=t2-t1; % das ist die Dauer einer Periode
%ich will die Perioden aber nicht über die Maxima haben, weil das doof aussieht, sondern über die Minima
% also muss ich zwischen den zweien den tiefsten Punkt suchen

sr=getSR(signal);
x1=time2bin(signal,t1);
x2=time2bin(signal,t2);
a=1000000;
b=1231231;
werte=getdata(h);
tmin=0;
for i=x1:x2
    c=werte(i);
    if a >= b & b < c
        tmin=bin2time(signal,i);
        break; % das erste reicht uns vollkommen
    end
    a=b;
    b=c;
end

per=getpart(signal,tmin,tmin+dauer);
per=setname(per,sprintf('One Period of Signal \n%s\n Periodlength: %5.2f ms',signal.name,getlength(per)*1000));