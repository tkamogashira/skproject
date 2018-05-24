function h = actualdesign(this,hs)
%ACTUALDESIGN

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

% Use elliptic design as lower bound estimate of filter order
hm = fdfmethod.elliphalfbandmin;
he = design(hm,hs);
N = order(he);

% Design Nyquist filters until order is met
N = N + 4 - rem(N,4); % Increase order to next multiple of 4
f=fdesign.halfband('N,tw',N,hs.TransitionWidth);

filtstruct = get(this, 'FilterStructure');
desmode = this.DesignMode;

% Try design
[h,notConverging] = iterateOrd(hs,f,filtstruct,desmode);

if notConverging,
    error(message('dsp:fdfmethod:iirhalfbandeqripmin:actualdesign:notConverging'));
end
%--------------------------------------------------------------------------
function [h,notConverging] = iterateOrd(hs,f,filtstruct,desmode)

count = 0;
maxCount = 20;
Ast = 0;
notConverging = false;
% First try to bracket the order required
lowerOrd = f.FilterOrder;
upperOrd = inf;
initOrd  = lowerOrd;
while Ast < hs.Astop && count < maxCount,
    try,
        h = design(f,'iirlinphase',...
            'filterstructure',filtstruct,...
            'DesignMode',desmode);
    catch
        break
    end
    m = measure(h);
    Ast = m.Astop;
    if Ast < hs.Astop,
        lowerOrd = f.FilterOrder;
        lowAst = Ast;
        f.FilterOrder = f.FilterOrder + initOrd;
    else
        upperOrd = f.FilterOrder;
    end
    count = count + 1;
end

if lowerOrd == upperOrd,
    % We're done
    return
end

if isinf(upperOrd),
    f.FilterOrder = lowerOrd + 4;
    % We were unable to bracket the order, try increments of 4
    while lowAst < hs.Astop && count < maxCount,
        try,
        h = design(f,'iirlinphase',...
            'filterstructure',filtstruct,...
            'DesignMode',desmode);
        catch
            count = maxCount;
            break;
        end
        m = measure(h);
        lowAst = m.Astop;
        f.FilterOrder = f.FilterOrder + 4;
        count = count + 1;
    end
else
    N = (lowerOrd+upperOrd)/2;
    if rem(N,4),
        f.FilterOrder = N + 4 - rem(N,4);
    else
        f.FilterOrder = N;
    end

    while lowAst < hs.Astop && count < maxCount,
        h = design(f,'iirlinphase',...
            'filterstructure',filtstruct,...
            'DesignMode',desmode);
        m = measure(h);
        lowAst = m.Astop;
        % Use bisection to determine the min ord
        if lowAst > hs.Astop,
            % Decrease order
            upperOrd = f.FilterOrder;
        else
            % Increase order
            lowerOrd = f.FilterOrder;
        end
        N = (lowerOrd+upperOrd)/2;
        if rem(N,4),
            f.FilterOrder = N + 4 - rem(N,4);
        else
            f.FilterOrder = N;
        end
        count = count + 1;
    end
end
if count == maxCount,
    notConverging = true;
end



% [EOF]
