function h = actualdesign(this,hs)
%ACTUALDESIGN

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

Dstop  = convertmagunits(hs.Astop,'db','linear','stop');
TW = hs.TransitionWidth;
B = hs.Band;

% Estimate order based on stopband only
N = firpmord([1/B-TW/2, 1/B+TW/2],[1,0],[Dstop,Dstop]);
if rem(N,2),
    N = N+1;
end

% Design Nyquist filters until order is met
f=fdesign.nyquist(B,'N,tw',N,TW);

if N > 224,
    % This is the highest order that has been found to work for some specs,
    % e.g. fdesign.nyquist(28,.06,110);
    error(message('dsp:fdfmethod:eqripnyqmin:actualdesign:strictSpecs'));
end

[lstwrn,lstid] = lastwarn;

lastwarn('','');
s = warning('off');

% Try design
h = equiripple(f);
notConverging = false;
[wrn,wrnid] = lastwarn;
if strcmp(wrnid,'filterdesign:firnyquist:iterationLimit');
    notConverging = true;
else
    [h,notConverging] = iterateOrd(hs,h,f,notConverging);
end

warning(s);

lastwarn(lstwrn,lstid);

if notConverging,
    error(message('dsp:fdfmethod:eqripnyqmin:actualdesign:notConverging'));
end

%--------------------------------------------------------------------------
function [h,notConverging] = iterateOrd(hs,h,f,notConverging)

m = measure(h);
if m.Astop >= hs.Astop,
    % We meet the spec, try a lower order
    while m.Astop >= hs.Astop && f.FilterOrder > 2,
        f.FilterOrder = f.FilterOrder - 2; % Decrease order to next even
        htemp = equiripple(f);
        [wrn,wrnid] = lastwarn;
        if strcmp(wrnid,'filterdesign:firnyquist:iterationLimit');
            notConverging = true;
            break; % Not converging - exit early
        else
            m = measure(htemp);
            if m.Astop >= hs.Astop,
                % Reduced order meets specs
                h = htemp;
            end
        end
    end
else
    count = 0;
    maxCount = 10;
    Ast = m.Astop;
    while Ast < hs.Astop && count < maxCount,
        f.FilterOrder = f.FilterOrder + 2; % Increase order to next even number
        h = equiripple(f);
        [wrn,wrnid] = lastwarn;
        if strcmp(wrnid,'filterdesign:firnyquist:iterationLimit');
            notConverging = true;
            break; % No converging - exit early
        else
            m = measure(h);
            newAst = m.Astop;
            if newAst < Ast,
                notConverging = true;
                break; % No converging - exit early
            end
            Ast = newAst;
        end
        count = count + 1;
    end
    if count == maxCount,
        notConverging = true;
    end
end


% [EOF]
