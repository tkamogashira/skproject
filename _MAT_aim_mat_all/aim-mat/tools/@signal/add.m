% method of class @signal
% function sigresult=add(sig1,sig2,[start_time],[duration])
%   INPUT VALUES:
%       sig1:       first @signal
%       sig2:       second @signal or struct
%       start_time: start time for the addition. [default: 0]
%       duration:   duration of the signal, that is added [default: getlength(sig2)]
%   RETURN VALUE:
%       sigresult:  @signal that is the sum of signals sig1 and sig2`
%       the resulting signal can be longer then sig1 or sig2, when start_time
%       and duration is according. sig2 can be a signal-object or an struct
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function sig=add(a,b,start_time,dauer)

if nargin < 4
    if isobject(b)
        dauer=getlength(b);
    end
end
if nargin < 3
    start_time=0;
end

% wenn ein Spaltenvektor hinaufaddier werden soll
if isnumeric(b)
    sr=GetSR(a);
    nr=size(b)
    if nr>1
        temp=signal(b,sr);  % erzeuge ein neues Signal aus den Werten
        sig=add(a,temp);    % und lasse dann die beiden Signale zusammenaddieren
    else
        sig=a+b;
    end
    return;
end



% das resultierede Signal kann länger sein als die Ausgangssignale
% erst feststellen, wie lang das nachher sein soll
laenge1=getlength(a);
laenge2=getlength(b); %so lang ist das zweite Signal
if laenge2<dauer
    disp('error: the signal is shorter then the duration');
    return;
end

sr1=getsr(a);
sr2=getsr(b);
if sr1~=sr2
    error('signal::add::error: samplerates differ - not implemented yet');
end

lneu=start_time+dauer;    % so lang wird das neue Signal
if lneu<laenge1 % oder es ist nicht länger als vorher
    lneu=laenge1;
end

binl1=time2bin(a,lneu+getminimumtime(a));
binl2=time2bin(a,laenge1+getminimumtime(a));    %achtung, sonst rundungsfehler
if binl1 > binl2 % wenn das neue Signal länger wird
    temp=signal(lneu,sr1,a.name,a.unit_x,a.unit_y,a.start_time);
    % kopiere zuerst das alte Signal
    start=1;
    stop=time2bin(a,laenge1+getminimumtime(a));
    temp.werte(start:stop)=a.werte(start:stop);
    % rekursiver Aufruf, denn nun ist das Signal lang genug
    sig=add(temp,b,start_time,dauer);
    return;
end

% normalfall: Das Ergebnissignal ist nun höchstens genauso lang
sig=a;  %kopieren des alten Signals in das Rückgabesignal
start1=time2bin(a,start_time)+1;
% stop1=time2bin(a,start_time+dauer-1/sr1);
stop1=time2bin(a,start_time+dauer);
start2=1;
stop2=time2bin(a,dauer+getminimumtime(a));

% do some error checking:
if stop2-start2 == stop1-start1
    sig.werte(start1:stop1)=sig.werte(start1:stop1)+b.werte(start2:stop2);
else
    if start1>1
        stop1=start1+stop2-start2;
        sig.werte(start1:stop1)=sig.werte(start1:stop1)+b.werte(start2:stop2);
    else
      
        disp('signal::add problem with adding - havent added')
    end
end

return;




