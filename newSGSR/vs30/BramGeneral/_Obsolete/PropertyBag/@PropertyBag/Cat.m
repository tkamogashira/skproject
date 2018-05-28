function PB = Cat(Dim, PB1, PB2)
%PROPERTYBAG/CAT    concatenation of propertybags.
%   Concatenation of property bags to an array is not
%   allowed.

%B. Van de Sande 13-05-2004

error('Property bags cannot be concatenated.');