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


function sig=mtimes(a,b)
% multiplikation mit *
% einfachster Fall: Multipliziere mit konstanter Zahl
% sonst: Multipliziere ein zweites Signal zum Zeitpunkt Null
% a muss ein Signal sein!!!

if isnumeric(b) && isobject(a)
    if size(b)==1
        a.werte=a.werte*b;
        sig=a;
    else
        d1=getnrpoints(a);
        d2=max(size(b));
        if d1>d2 % nimm den kleineren WErt
            dauer=bin2time(a,d2);
        else
            dauer=bin2time(a,d1);
        end
%         if dauer>getmaximumtime(a)
%             dauer=getmaximumtime(a);
%         end
        sig=mult(a,b,0,dauer);
    end
    
elseif isnumeric(a) && isobject(b)
    if size(a)==1
        b.werte=b.werte*a;
        sig=b;
    else
        d1=getnrpoints(b);
        d2=max(size(a));
        if d1>d2 % nimm den kleineren WErt
            dauer=bin2time(b,d2);
        else
            dauer=bin2time(b,d1);
        end            
        sig=mult(b,a,0,dauer);
    end
elseif isobject(a) && isobject(b)
    dauer=getlength(a);
    start=getminimumtime(a);
    sig=mult(a,b,start,dauer);
end
