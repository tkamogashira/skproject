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


function [h_min,h_max,t_min,t_max]=getminmax(sig,distance)
% usage: function [h,t]=getminmax(sig,distance)
% returns the height and lows in locations and time of all local maxima in the signal
% in case of continuus maxima, the last value of the series is taken
% distance is the minimum percent value, that must be between 
% successive minima and maxima
% the distance must be in percent from the maximum minus the minimum value
% of the signal to count as a maximum

h_max=[];
t_max=[];
h_min=[];
t_min=[];

if nargin < 2 
    distance=0; % take alle maxima
end


mmax=max(sig);
mmin=min(sig);
threshold=(mmax-mmin)*distance;


werte=getdata(sig);
nr= getnrpoints(sig); % so many points

a=-inf;
b=-inf;
count_min=0;
count_max=0;

sr=getsr(sig);
last_t=0;

next_is_minimum=1;  % can be both
next_is_maximum=1;

for i=1:nr
    c=werte(i);
    
    % lokales Minimum
    if a > b & b <= c
        curr_min=b;

        if count_max > 0 % das erste Minimum
            last_max=h_max(count_max);
        else        
            last_max=+inf;
        end

        % wenn ein Minimum auftaucht, das klar eines ist, aber das Maximum
        % dazwischen fehlte, dann wird das letzte Minimum ignoriert!
        if (last_max - curr_min) > threshold & next_is_maximum & count_min > 0
            count_min=count_min-1;
            next_is_minimum=1;
        end        

        if (last_max - curr_min) > threshold  & next_is_minimum
            count_min=count_min+1;
            next_is_minimum=0;  % the next must be a maximum!
            next_is_maximum=1;

            h_min(count_min) = curr_min;
            t_min(count_min) = bin2time(sig,i-1);
        end
    end
    
    % lokales Maximum
    if a < b & b >= c 
        curr_max=b;

        if count_min > 0 % das erste Maximum
            last_min=h_min(count_min);
        else        
            last_min=-inf;
        end

        % wenn ein Maximum auftaucht, das klar eines ist, aber das Minimum
        % dazwischen fehlte, dann wird das letzte Maximum ignoriert!
        if (curr_max - last_min) > threshold & next_is_minimum & count_max > 0
            count_max=count_max-1;
            next_is_maximum=1;
        end        
        

        if (curr_max - last_min) > threshold & next_is_maximum
            count_max=count_max+1;
            next_is_minimum=1;  % the next must be a minimum
            next_is_maximum=0;

            h_max(count_max) = curr_max;
            t_max(count_max) = bin2time(sig,i-1);
        end
    end
    
    
    % shift the last values
    a=b;
    b=c;
end
