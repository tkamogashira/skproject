function Hd = dispatch(Hm)
%DISPATCH Returns the contained DFILT objects.

%   Author: R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Validate the cascade first
validateratechangefactors(Hm);

% We generate the filters on the fly
% Form matrix of rate change factors
m = [];
Hmstages = nstages(Hm);
for n = 1:Hmstages,
    m = [m;get(Hm.Stage(n),'privRateChangeFactor')];
end

% Look for interpolators, include first decimator or src
indx = min(find(m(:,2) > 1));

% If index is empty, we have only interpolators
if isempty(indx),
    indx = Hmstages;
end

% Form array of equivalent dfilts
for n = 1:indx,
    [b,a] = tf(Hm.Stage(n));
    % Compute equivalent interpolation factor
    Leq = prod(m(n+1:indx,1));
    % Upsample but remove trailing zeros
    bup = upsample(b,Leq); bup = bup(1:max(find(bup ~= 0)));
    aup = upsample(a,Leq); aup = aup(1:max(find(aup ~= 0)));
    h(n) = dfilt.df1(bup,aup);
end

% Find last decimator or dfilt
indx2 = max(find(m(:,2) >= 1 & m(:,1) == 1));

% If no more decimators we are done
if ~isempty(indx2),
    % Add remaining decimators
    for n = indx+1:indx2,
        [b,a] = tf(Hm.Stage(n));
        % Compute equivalent decimation factor
        Meq = prod(m(indx:n-1,2));
        % Upsample but remove trailing zeros
        bup = upsample(b,Meq); bup = bup(1:max(find(bup ~= 0)));
        aup = upsample(a,Meq); aup = aup(1:max(find(aup ~= 0)));
        h(n) = dfilt.df1(bup,aup);
    end

    % Now add possible remaining interpolators
    indx3 = min(find(m(indx2:end,1) > 1))+indx2-1;

    if ~isempty(indx3),
        % Add remaining interpolators
        for n = indx3:Hmstages,
            [b,a] = tf(Hm.Stage(n));
            % Compute equivalent interpolation factor
            Leq = prod(m(n+1:Hmstages,1));
            % Upsample but remove trailing zeros
            bup = upsample(b,Leq); bup = bup(1:max(find(bup ~= 0)));
            aup = upsample(a,Leq); aup = aup(1:max(find(aup ~= 0)));
            h(n) = dfilt.df1(bup,aup);
        end
    end
end


Hd = cascade(h);


% [EOF]
