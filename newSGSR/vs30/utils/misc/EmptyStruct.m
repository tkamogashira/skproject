function es = EmptyStruct(varargin)
% EMPTYSTRUCT - creates 0x1 structure with specified fields
%    E = EMPTYSTRUCT('F1', 'F2', ..) creates an empty
%    struct, i.e., size(E)==[0 1] with fields 'F1', 'F2', ...
%
% See also CollectInStruct.

% interleave empty matrices
N = length(varargin);
for ii=1:N,
   varargin{2,ii} = [];
end
varargin = {varargin{:}};
es = struct(varargin{:});
% es contains empty fields, but isn't empty
es(1) = []; % now it is