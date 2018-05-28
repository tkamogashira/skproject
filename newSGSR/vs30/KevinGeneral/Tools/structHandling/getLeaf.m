function argout = getLeaf(inStruct, leafName)
% GETLEAF gets the value of a leaf of a structure.
%
% argout = getLeaf(inStruct, leafName)
% Returns the value of leaf 'leafname' of structure inStruct. getLeaf is
% case insensitive.
%
%   inStruct: A structure with arbitrary depth.
%   leafName: The name of the leaf (end node) of the structure who's value
%             you want.
%
% Example:
%  >> A.a = 4;
%  >> A.b.c = 5;
%  >> A.b.d = 9
%  A = 
%      a: 4
%      b: [1x1 struct]
%  >> getLeaf(A, 'c')
%  ans = 
%       5

if ~isequal(2, nargin)
    error('Expected 2 arguments.');
end

if ~ischar(leafName)
    error('Expected a property name as second parameter.');
end

inFlat = lowerFields( flatStruct(inStruct) );
leafName = lower(leafName);

if ~ismember(leafName, fieldnames(inFlat))
    error('The property you are trying to get does not exist');
end

argout = getfield(inFlat, leafName);