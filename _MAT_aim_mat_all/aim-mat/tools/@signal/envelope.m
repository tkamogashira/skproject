% method of class @signal
% function env=envelope(sig,[mintime],[maxtime],[mincontrast])
%
% retuns the envelope determined by connecting the maximum points
% when the maxima are seperated by more then the mintime, then connect 
% minima, that lie in the middle
% if the difference between maxima is smaller then maxtime
% look for the next maximum, that is further away
% if mincontrast is given, than the maxima must have at least such a 
% contrast that is the distance in height to its neighbours in % of the whole signal!!
%
%   INPUT VALUES:
%       sig: original @signal
%       mintime: minimum time, that must be between two successive maxima
%       maxtime: maximum time, that must be between two successive maxima
%       mincontrast: minimum contrast between two maxima
% 
%   RETURN VALUE:
%       env: @signal
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function env=envelope(sig,mintime,maxtime,mincontrast)

if nargin < 4
    mincontrast=0;
end
if nargin < 3
    maxtime=0;
end
if nargin < 2
    mintime=0;
end

[maxpos,minpos,maxs,mins]=getminmax(sig);



env=signal(sig);
env=mute(env);
env=setname(env,sprintf('Envelope of: %s',getname(sig)));

if isempty(maxs)
    return
end

threshold=max(sig)*mincontrast;

nr_max=length(maxs);
lastmax=maxpos(1);
lastval=maxs(1);
lastminval=getminimumleftof(lastmax,maxpos,minpos,maxs,mins);
if isempty(lastminval)
    lastminval=0;
end
for i=2:nr_max
    newmax=maxpos(i);
    newval=maxs(i);
    newminval=getminimumleftof(newmax,maxpos,minpos,maxs,mins);
    
    % wenn die maxima zu nah beeinander liegen, dann such das nächste Maximum
    if newmax-lastmax > maxtime
        if newval > lastminval+threshold 
            if newmax-lastmax > mintime
                tmin=getminimumleftof(newmax,maxpos,minpos,maxs,mins);% das ist das Minimum links vom rechten Maximum
                % wenn das Minimum zwischen den Maxima liegt, dann verbinde zwei Linien vom Maximum zum Minimum und weiter
                if tmin>lastmax
                    % erste Gerade
                    tmitte=tmin;
                    x1=time2bin(sig,lastmax);
                    x2=time2bin(sig,tmitte);
                    y1=lastval;
                    y2=gettimevalue(sig,tmitte);
                    line=linspace(y1,y2,x2-x1+1);
                    env=setvalues(env,line,x1);
                    
                    % zweite Gerade
                    x1=time2bin(sig,tmitte);
                    x2=time2bin(sig,newmax);
                    y1=gettimevalue(sig,tmitte);
                    y2=newval;
                    line=linspace(y1,y2,x2-x1+1);
                    env=setvalues(env,line,x1);
                end
                % maxima weit genug zusammen, also werden nur die Maxima verbunden    
            else
                x1=time2bin(sig,lastmax);
                x2=time2bin(sig,newmax);
                y1=lastval;
                y2=newval;
                line=linspace(y1,y2,x2-x1+1);
                env=setvalues(env,line,x1);
            end
            lastmax=newmax;
            lastval=newval;
            lastminval=newminval;
        end
    end
end