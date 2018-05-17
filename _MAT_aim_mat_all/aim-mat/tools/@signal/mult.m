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


function sig=mult(a,b,start_time,dauer)
%wenn b ein Vektor ist, werden die Werte einfach multipliziert
% wenn b eine Struct ist, dann werden sie adäquat multipliziert

if(~isobject(a))
    disp('error: only works on signals');
end
if nargin < 4
    if isobject(b)
        dauer=GetLength(b);
    end
end
if nargin < 3
    start_time=0;
end

% wenn ein Spaltenvektor multipliziert werden soll
if isnumeric(b)
    sr=getsr(a);
    nr=max(size(b));
    if nr>1
        temp=signal(b,sr);  % erzeuge ein neues Signal aus den Werten
        sig=mult(a,temp,start_time,dauer);    % und lasse dann die beiden Signale zusammenaddieren
    else
        if nargin <3
            sig=a*b;            % einfache Zahl
        else    % with starttime and duration
            start=time2bin(a,start_time)+1;    % +1, because a signal starts at the first bin
            stop=time2bin(a,start_time+dauer);
            sig=a;
            sig.werte(start:stop)=sig.werte(start:stop)*b;
        end
    end
    return;
end


% das resultierede Signal kann länger sein als die Ausgangssignale
% erst feststellen, wie lang das nachher sein soll
laenge1=getlength(a);
laenge2=getlength(b); %so lang ist das zweite Signal
sr1=getsr(a);
sampletime=1/sr1;
sr2=getsr(b);

if laenge2<dauer
    disp('error: the signal is shorter then the duration');
    return;
end

if sr1~=sr2
    disp('error: samplerates differ - not implemented yet');
    return;
end

lneu=start_time+dauer;    % so lang wird das neue Signal
if lneu<laenge1 % oder es ist nicht länger als vorher
    lneu=laenge1;
end

if fround(lneu,10)-fround(laenge1,10) % wenn das neue Signal länger wird
    temp=signal(lneu,sr1,a.name,a.unit_x,a.unit_y,a.start_time);
    % kopiere zuerst das alte Signal
    start=1;
    stop=time2bin(a,laenge1);
    temp.werte(start:stop)=a.werte(start:stop);
    % rekursiver Aufruf, denn nun ist das Signal lang genug
    sig=mult(temp,b,start_time,dauer);
    return;
end

% normalfall: Das Ergebnissignal ist nun höchstens genauso lang
sig=a;  %kopieren des alten Signals in das Rückgabesignal
start1=time2bin(a,start_time)+1;    % +1, because a signal starts at the first bin
stop1=time2bin(a,start_time+dauer);
start2=1;
stop2=time2bin(b,dauer);
sig.werte(start1:stop1)=sig.werte(start1:stop1).*b.werte(start2:stop2);

return;




