function C = GenericCellFun(Fun, CellArg, varargin);
% GenericCellFun - generalized Cellfun
%   C = GenericCellFun(Fun, CellArg, varargin) calls Fun(CellArg{ii}, varargin{:}) 
%   one by one (ii is counter) and puts the return values in cell array C
%
%   Example
%     genericCelFun(@str2num, {'a' '2' '45'; 'pi' '2' '45'}')
%     ans = 
%    
%          []    [3.1416]
%        [ 2]    [     2]
%        [45]    [    45]
%
%   Note: this function might be obsolete, because Matlab's CELLFUN has
%   been generalized in the mean time.
%   
%
%   See also Cellfun.

C = {};
sz = size(CellArg);
% CellArg = reshape(CellArg, [1 numel(CellArg)]);
for ii=1:numel(CellArg),
    c = feval(Fun, CellArg{ii}, varargin{:});
    C = {C{:}, c};
end
C = reshape(C, sz);



