function CD = greenwood(F)
%GREENWOOD  greenwood-formula
%   CD = GREENWOOD(F) converts frequency F(Hz) to cochlear distance CD(mm)

%B. Van de Sande 27-03-2003

%Greenwood-formula for cochlear distance ...
CD = (1/0.084)*(log10(F/456+0.8));
