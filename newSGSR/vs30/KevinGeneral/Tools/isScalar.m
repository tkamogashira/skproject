function result = isScalar(VAR)
% ISSCALAR Returns 1 if VAR has size [1 1].
% This function has the same functionality as isscalar in Matlab 7. Matlab
% 6 though does not standardly provide isscalar. 
% In your code, call isscalar instead of isScalar. Matlab 6 will
% automatically use isScalar, since it is not case sensitive. Matlab 7 will
% automatically use the native function.

if isequal([1 1], size(VAR))
    result = 1;
else
    result = 0;
end
