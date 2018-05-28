function result = isFlat(inStruct)
% ISFLAT checks wether a structure is flat or not
%
% boolean result = isFlat( struct inStruct )
%
%     inStruct: the structure being investigated
%
%      returns: 1 if inStruct is flat, 0 if not

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006

result = 1;
FN = fieldnames(inStruct);
for i=1:size(FN)
   result = result * ~isstruct( getfield(inStruct, FN{i} ) ); 
end