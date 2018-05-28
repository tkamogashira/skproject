function result = checkXYVectors(XIn, YIn)
% CHECKXYVECTORS Check whether (XIn, YIn) contain a valid set of vectors
%
% result = checkXYVectors(XIn, YIn)
%  XIn and YIn should contain an equal amount of vectors. They can be 2x2
%  arrays with vectors of equal lengths, or cell columns with vectors of
%  differing lengths. 
%  The vectors should be in pairs though, so XIn{i} should have the same
%  length as YIn{i}. 

%% check size and class
SizeX = size(XIn);
SizeY = size(YIn);
if ~isequal(SizeX, SizeY) | SizeX < 1 | SizeY < 1 | ~isequal(2, ndims(XIn)) | ~isequal(class(XIn), class(YIn))
    result = 0;
    return;
end

switch class(XIn)
    case 'cell'
        % cell array should have one column
        if ~isequal(1, SizeX(2)) | ~(SizeX(1) > 0)
            result = 0;
            return;
        end
        for i=1:SizeX(1) % check recursively
            if ~checkXYVectors(XIn{i}, YIn{i})
                result = 0;
                return;
            end
        end
    case 'double'
        % ok
    otherwise
        result = 0;
        return;
end


% if it gets here, things should be ok
result = 1;