% method of class @signal
% function sig=expand(sig,newlength,[value])
%
% makes the signal longer (or shorter) by appending values with the value value
% if time is negative, then expand it to the front by filling the first time with value
%
%   INPUT VALUES:
%       sig: original @signal
%       newlength: the new length of the signal
%       value: value, with wich the new part is filled [0]
% 
%   RETURN VALUE:
%       time: time, when signal is bigger 0 for first time
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=expand(a,newlength,value)

lenalt=getlength(a);
sig=a; % erst mal eine Kopie des Signals
sr=getsr(a);
if newlength < 0 % aha, länger machen mit vorne auffüllen
    lenneu=lenalt-newlength;    % denn die newlength ist ja negativ
    temp=a.werte;

    start=time2bin(a,-newlength);
    stop=time2bin(a,lenneu);
    
    neuevals=ones(1,stop)*value;% erst alle mit den gewünschten Werten belegen
    bla=time2bin(a,lenalt);
    neuevals(start+1:stop)=temp(1:bla); % dann mit dem alten Signal überschreiben

    sig.werte(1:stop)=neuevals(1:stop);
    
else % positive neue Länge
    if lenalt>=newlength    %nothing to do
        return;
    end
    start=time2bin(a,lenalt);
    stop=time2bin(a,newlength);
    sig.werte(start:stop)=value;
end

 