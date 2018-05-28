function OUI = initOUIstruct(minFigSize);
% initOUIstruct - initialize OUI struct of paramset object.
%   syntax: initOUIstruct(minFigSize)
%
%   See also paramset, initQueryGroup.

if ~isequal([1 2], size(minFigSize)),
   error('Minimum figure size must be 1x2 vector.')
end

OUI.group = [];
OUI.item = [];
OUI.minFigSize = minFigSize;
OUI.init = {};




