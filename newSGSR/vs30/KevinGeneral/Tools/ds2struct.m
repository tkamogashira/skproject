function st = ds2struct(ds)

% DS2STRUCT  Convert a dataset object to a struct for export
%   S=  DS2STRUCT(DS) convert dataset object DS to a struct object S.
%   
%   Example - 
%   ds = dataset('A0428', '25-2');
%   S = ds2strcut(ds);
%
%   See also stimSam (make stimulus from dataset object for export)

% MMCL 15/02/2010


st = struct(ds);