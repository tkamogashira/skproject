function Data = ZipNumericData(NumData)
%ZIPNUMERICDATA compresses double precision vector to 16bit unsigned integer
%   ZipData = ZIPNUMERICDAT(NumData)

Data = struct([]);

%Parameters nagaan ...
if nargin ~= 1, error('Wrong number of input parameters'); end

if ~isnumeric(NumData) | (ndims(NumData) ~= 2) | ~any(size(NumData) == 1),
    error('Input argument should be numeric vector');
end

%Compressie ...
iLarge = find(NumData >= 65535);
LargeNumData = NumData(iLarge);
NumData(iLarge) = 65535;
SmallNumData = uint16(NumData);

Data = CollectInStruct(SmallNumData, LargeNumData);
