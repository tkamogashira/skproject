function super_thisautoscale(this,s,binptaligned)
%THISAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

inputautoscalefl(this,s,binptaligned)
outputautoscalefl(this,s,binptaligned)

this.StateFracLength = getautoscalefl(this,s.States,true,this.StateWordLength);

% Lattice Side
latprodfl = getautoscalefl(this,s.Product,true,this.ProductWordLength);
latfdprodfl = this.StateFracLength+this.LatticeFracLength;
if latprodfl>latfdprodfl,
    latprodfl = latfdprodfl;
end

lataccumfl = getautoscalefl(this,s.Accumulator,true,this.AccumWordLength);
if (lataccumfl>latprodfl),
    lataccumfl = latprodfl;
end
if binptaligned,
    fl = min(latprodfl,lataccumfl);
    this.ProductFracLength = fl;
    this.AccumFracLength = fl;
else
    this.ProductFracLength = latprodfl;
    this.AccumFracLength = lataccumfl;
end

this.loggingreport = [];



% [EOF]

