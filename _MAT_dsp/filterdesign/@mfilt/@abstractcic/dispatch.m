function Hd = dispatch(Hb)
%DISPATCH Returns DFILT for analysis.

%   Author: P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

Hd = Hb.Filters;

if isempty(Hd),
    % Get the R
    rcf = Hb.privRateChangeFactor;
    idx = find(rcf == 1); 
    
    if length(idx) <= 1,
        rcf(idx) = []; 
        R = rcf;
    else
        R = 1;  % Handle the case when R = 1 (see g229761)
    end

    b = 1;
    temp=ones(1,R*Hb.DifferentialDelay); % uniform-coefficient (boxcar) filter
    for n = 1:Hb.NumberOfSections,
        b = conv(b,temp);
    end
    Hd = lwdfilt.symfir(b);
    set(Hb,'Filters',Hd);
end

% [EOF]
