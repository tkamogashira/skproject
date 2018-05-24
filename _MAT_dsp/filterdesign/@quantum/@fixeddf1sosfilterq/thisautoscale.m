function thisautoscale(this,s,binptaligned)
%THISAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

inputautoscalefl(this,s,binptaligned)
outputautoscalefl(this,s,binptaligned)

this.NumStateFracLength = getautoscalefl(this,s.NumStates,true,this.NumStateWordLength);
this.DenStateFracLength = getautoscalefl(this,s.DenStates,true,this.DenStateWordLength);

% Numerator Side
nprodfl = getautoscalefl(this,s.NumProd,true,this.ProductWordLength);
nfpprodfl = this.NumStateFracLength+this.NumFracLength;
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
dfpprodfl = this.DenStateFracLength+this.DenFracLength;
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
