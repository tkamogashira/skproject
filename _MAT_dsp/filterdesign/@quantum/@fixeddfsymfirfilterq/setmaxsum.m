function setmaxsum(this, Hd)
%SETMAXSUM   Set the maxsum.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

n = order(Hd);
if rem(n,2),
    this.maxsum = sum(abs(Hd.Numerator(1:ceil(this.ncoeffs/2))));
else
    if n==0,
        this.maxsum = max(abs(Hd.Numerator));
    else
        this.maxsum = norm(Hd, 'l1')/2;
    end
end
updateinternalsettings(this);

% [EOF]
