function thisautoscale(this,s,binptaligned)
%THISAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

inputautoscalefl(this,s,binptaligned)
outputautoscalefl(this,s,binptaligned)

this.StateFracLength = getautoscalefl(this,s.States,true,this.StateWordLength);

% Lattice Side
latprodfl = getautoscalefl(this,s.LatticeProd,true,this.ProductWordLength);
latfdprodfl = this.StateFracLength+this.LatticeFracLength;
if latprodfl>latfdprodfl,
    latprodfl = latfdprodfl;
end

lataccumfl = getautoscalefl(this,s.LatticeAcc,true,this.AccumWordLength);
if (lataccumfl>latprodfl),
    lataccumfl = latprodfl;
end
if binptaligned,
    fl = min(latprodfl,lataccumfl);
    this.LatticeProdFracLength = fl;
    this.LatticeAccumFracLength = fl;
else
    this.LatticeProdFracLength = latprodfl;
    this.LatticeAccumFracLength = lataccumfl;
end

% Ladder Side
ladprodfl = getautoscalefl(this,s.LadderProd,true,this.ProductWordLength);
ladfdprodfl = this.StateFracLength+this.LadderFracLength;
if ladprodfl>ladfdprodfl,
    ladprodfl = ladfdprodfl;
end

ladaccumfl = getautoscalefl(this,s.LadderAcc,true,this.AccumWordLength);
if (ladaccumfl>ladprodfl),
    ladaccumfl = ladprodfl;
end
if binptaligned,
    fl = min(ladprodfl,ladaccumfl);
    this.LadderProdFracLength = fl;
    this.LadderAccumFracLength = fl;
else
    this.LadderProdFracLength = ladprodfl;
    this.LadderAccumFracLength = ladaccumfl;
end

this.loggingreport = [];

% [EOF]
