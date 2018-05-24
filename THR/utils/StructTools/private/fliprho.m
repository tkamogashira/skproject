function ds = fliprho(ds)
%FLIPRHO    flip NRHO-dataset
%   DS = FLIPRHO(DS)

if (nargin ~= 1), error('Wrong number of input parameters.'); end
if ~isa(ds, 'dataset') | ~strcmp(ds.StimType, 'NRHO'), error('Only argument should be NRHO-dataset.'); end

ds = struct(ds);

[ds.Stimulus.IndepVar.Values, i] = sort(ds.Stimulus.IndepVar.Values);
if size(i, 2) > 1, i = i'; end
ds.Data.SpikeTimes = ds.Data.SpikeTimes(flipud(i), :);
ds.Stimulus.IndepVar.Values = sort(-ds.Stimulus.IndepVar.Values);

ds = dataset(ds, 'convert');