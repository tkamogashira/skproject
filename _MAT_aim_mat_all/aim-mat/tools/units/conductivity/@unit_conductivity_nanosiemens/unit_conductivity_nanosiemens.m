function nu=unit_conductivity_nanosiemens

str.name='nS';
str.fullname='nano Siemens';

str.converter=unitconvertermultpow(0.000000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_conductivity_nanosiemens',un);