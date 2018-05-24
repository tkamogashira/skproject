function varargout = multiSort(isort, varargin)
% multisort - sort multiple arrays together
%   [out1, out2,...] = multisort(iSort, in1, in2,...) applies index array
%   iSort to in1, in2, ... and returns the sorted outputs, that is:
%     out1 = in1(isort)
%     out2 = in2(isort)
%     ...
%
%   See also sortAccord.

for ii = 1:nargin-1,
    varargout{ii} = varargin{ii}(isort);
end
    
