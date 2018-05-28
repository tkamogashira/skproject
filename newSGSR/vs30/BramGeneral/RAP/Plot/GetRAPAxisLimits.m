function Limits = GetRAPAxisLimits(Ax, Limits, Data, Margin)
%GetRAPAxisLimits    get limits for RAP plot
%   Limits = GetRAPAxisLimits(Ax, Limits, Data, Margin)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 12-02-2004

%The standard MATLAB auto-scaling function is overruled. Instead for the
%ordinate (Y) the minimum in auto-scaling mode is taken to be zero, except if
%the minimum is negative.
%Then a percentage is subtracted from that minimum and the result is set as the
%lower limit.
%The upper limit is the maximum value to be plotted incremented by a given percent.
%For the abcissa the limits are taken as the minimum and maximum values to be plotted.

if strcmpi(Ax, 'x') %Abcissa ...
    if isinf(Limits(1))
        Limits(1) = min(Data)*(1-Margin);
    end
    if isinf(Limits(2))
        Limits(2) = max(Data)*(1+Margin);
    end
    
    if isequal(Limits(1), Limits(2))
        Limits = [Limits(1)-0.5, Limits(2)+0.5];
    end
elseif strcmpi(Ax, 'y') %Ordinate ...
    if isinf(Limits(1))
        Limits(1) = min([0, Data])*(1+Margin);
    end
    if isinf(Limits(2))
        Limits(2) = max(Data)*(1+Margin);
    end
 
    if isequal(Limits(1), Limits(2)) %Only if all zero datapoints ...
        Limits = [-Margin, Margin];
    end    
end
