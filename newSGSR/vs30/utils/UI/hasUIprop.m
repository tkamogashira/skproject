function hasit = hasUIprop(figh, tag);
% hasUIprop - chck if figure has given UIprop
%   syntax: hasUIprop(h, tag) 
% 
%   See also getUIprop, setUIprop.

hasit = 1;

try, getUIprop(figh, tag);
catch, hasit = 0;
end
