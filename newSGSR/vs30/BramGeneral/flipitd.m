function ds = flipitd(ds)
%FLIPITD    flip NITD-dataset
%   DS = FLIPITD(DS)

%Attention! Only works for IDF/SPK-datasets ...

if (nargin ~= 1), error('Wrong number of input parameters.'); end
if ~isa(ds, 'dataset') | ~any(strcmp(ds.StimType, {'NTD', 'NITD'})), error('Only argument should be NITD-dataset.'); end

ds = struct(ds);

[ds.Stimulus.IndepVar.Values, i] = sort(ds.Stimulus.IndepVar.Values);
if size(i, 2) > 1, i = i'; end
ds.Data.SpikeTimes = ds.Data.SpikeTimes(flipud(i), :);
ds.Stimulus.IndepVar.Values = sort(-ds.Stimulus.IndepVar.Values);

ds = dataset(ds, 'convert');