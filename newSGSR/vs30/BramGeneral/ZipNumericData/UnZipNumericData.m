function Data = UnZipNumericData(ZipData)
%UNZIPNUMERICDATA uncompresses 16bit unsigned integer data to double precision vector
%   NumData = UNZIPNUMERICDATA(ZipData)

Data = [];

%Parameters nagaan ...
if nargin ~= 1, error('Wrong number of input parameters'); end

if ~isstruct(ZipData) | ~isfield(ZipData, 'SmallNumData') | ~isfield(ZipData, 'LargeNumData'),
    error('Input argument should be structure with SmallNumData and LargeNumData as fields');
end

SmallNumData = double(ZipData.SmallNumData); 
LargeNumData = ZipData.LargeNumData;

iLarge = find(SmallNumData == 65535);
SmallNumData(iLarge) = LargeNumData;

Data = SmallNumData;