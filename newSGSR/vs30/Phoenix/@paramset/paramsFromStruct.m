function S = paramsFromStruct(S, VS, U, DT);
% paramset/paramsFromStruct - get parameters of paramset from struct
%   S = paramsFromStruct(S, VS, U) adds parameters to a paramset S
%   whose names and values are the fieldnames and values od struct VS. 
%   Cellstr array U provides the units of the respective parameters.
%   Datatypes are all real.
%
%   In paramsFromStruct(S, VS, U, DT) respective datatypes are prescribed
%   by cellstr array DT.
%
%   See also paramset, paramset/addParam.

if  nargout<1, 
   error('No output argument using paramsFromStruct. Syntax is: ''S = paramsFromStruct(S,...)''.');
end

if nargin<4, DT = {'real'}; end

if isvoid(S),
   error('Parameters may not be added to a void paramset object.');
end

U = cellstr(U);
DT = cellstr(DT);
FNS = fieldnames(VS);
for ii=1:length(FNS),
   pname = FNS{ii};
   pval = getfield(VS, pname);
   unit = U{min(end,ii)};
   dataType = DT{min(end,ii)};
   S = AddParam(S, pname, pval, unit, dataType);
end







