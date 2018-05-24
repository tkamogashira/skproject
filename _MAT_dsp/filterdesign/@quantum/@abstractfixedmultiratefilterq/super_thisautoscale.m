function super_thisautoscale(this,s,binptaligned)
%SUPER_THISAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

inputautoscalefl(this,s,binptaligned)

prodfl = getautoscalefl(this,s.Product,true,this.ProductWordLength);
fpprodfl = this.InputFracLength+this.NumFracLength;
if prodfl>fpprodfl,
    prodfl = fpprodfl;
end
    
accumfl = getautoscalefl(this,s.Accumulator,true,this.AccumWordLength);
if (accumfl>prodfl),
    accumfl = prodfl;
end

outfl = getautoscalefl(this,s.Output,true,this.OutputWordLength);
if (this.OutputWordLength>=this.AccumWordLength) && outfl>accumfl,
    outfl = accumfl;
end
this.OutputFracLength = outfl;


if binptaligned,
    fl = min(prodfl,accumfl);
    this.ProductFracLength = fl;
    this.AccumFracLength = fl;
else
    this.ProductFracLength = prodfl;
    this.AccumFracLength = accumfl;
end

updateinternalsettings(this);

this.loggingreport = [];



% [EOF]
