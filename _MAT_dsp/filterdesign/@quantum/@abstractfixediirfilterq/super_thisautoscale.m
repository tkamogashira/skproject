function super_thisautoscale(this,s,binptaligned)
%SUPER_THISAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

% Numerator Side
nprodfl = getautoscalefl(this,s.NumProd,true,this.ProductWordLength);
nfpprodfl = this.StateFracLength+this.NumFracLength;
if nprodfl>nfpprodfl,
    nprodfl = nfpprodfl;
end

naccumfl = getautoscalefl(this,s.NumAcc,true,this.AccumWordLength);
if (naccumfl>nprodfl),
    naccumfl = nprodfl;
end
if binptaligned,
    fl = min(nprodfl,naccumfl);
    this.NumProdFracLength = fl;
    this.NumAccumFracLength = fl;
else
    this.NumProdFracLength = nprodfl;
    this.NumAccumFracLength = naccumfl;
end

% Denominator Side
dprodfl = getautoscalefl(this,s.DenProd,true,this.ProductWordLength);
dfpprodfl = this.StateFracLength+this.DenFracLength;
if dprodfl>dfpprodfl,
    dprodfl = dfpprodfl;
end

daccumfl = getautoscalefl(this,s.DenAcc,true,this.AccumWordLength);
if (daccumfl>dprodfl),
    daccumfl = dprodfl;
end
if binptaligned,
    fl = min(dprodfl,daccumfl);
    this.DenProdFracLength = fl;
    this.DenAccumFracLength = fl;
else
    this.DenProdFracLength = dprodfl;
    this.DenAccumFracLength = daccumfl;
end
this.loggingreport = [];


% [EOF]
