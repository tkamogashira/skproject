function [Wnew,constr,erridx] = parse_firgrweights(W, WP)
%PARSE_FIRGRWEIGHTS   

%   Author(s): D. Shpak
%   Copyright 2005-2011 The MathWorks, Inc.

%
% Defaults are: unconstrained, single approximation error, linear phase
nbands = length(W);
constr = zeros(nbands,1);
erridx = ones(nbands,1);
Wnew = W;

if isempty(WP)
    return;
end

if nbands ~= length(WP)
    error(message('dsp:parse_firgrweights:InvalidDimensions1'));
end

for i = 1:nbands
    prop = lower(WP{i});
    stop = length(prop);
    j=1;
    while j <= stop
        switch prop(j)
            case 'w'
                % Weight is already correct
            case 'c'
                if (W(i) <= 0.0)
                    error(message('dsp:parse_firgrweights:MustBePositive1'));
                end
                constr(i) = W(i);
                % Default error unweighting to force values toward the constraints
                Wnew(i) = 0.05;
            case 'e'
                eNum = 0;
                while (j < stop)
                    j = j+1;
                    chr = prop(j);
                    if chr >= '0' & chr <= '9'
                        eNum = 10*eNum + str2num(chr);
                    end
                end

                if eNum == 0
                    error(message('dsp:parse_firgrweights:MustBePositive2'));
                end
                erridx(i) = eNum;
            otherwise
                str = strcat('Invalid weight property string ''', prop, '''');
                error(message('dsp:parse_firgrweights:FilterErr', prop));
        end
        j = j + 1;
    end
end

q = sort(erridx);
if q(1) < 1 | fix(q) ~= q | any(diff(q) > 1)
    error(message('dsp:parse_firgrweights:InvalidRange'));
end

eMax = max(erridx);
ok = zeros(eMax,1);
for i=1:nbands
    if constr(i) == 0.0
        ok(erridx(i)) = 1;
    end
end
if any(ok == 0)
    error(message('dsp:parse_firgrweights:InvalidDimensions2'));
end


% [EOF]
