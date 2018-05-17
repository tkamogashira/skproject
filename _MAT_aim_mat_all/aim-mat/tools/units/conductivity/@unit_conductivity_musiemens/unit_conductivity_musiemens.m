function nu=unit_conductivity_musiemens

str.name='µS';
str.fullname='microSiemens';

str.converter=unitconvertermultpow(0.000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_conductivity_microsiemens',un);