function outStruct = lowerFields(inStruct)
% LOWERFIELDS returns the given structure, with all fieldnames in lowercase
%
% outStruct = lowerFields(inStruct)
% Returns inStruct with lowered fieldnames. Can also be used with struct
% arrays.
%
%   inStruct: A structure array, with random depth.
%
% Example:
%  >> inStruct.FiElD = 97;
%  >> inStruct.FiieEElD.C = 'konIjn';
%  >> inStruct.FiieEElD.zoT = 666
%  inStruct =
%       FiElD: 97
%    FiieEElD: [1x1 struct]
%  >> outStruct = lowerFields(inStruct)
%  outStruct =
%       field: 97
%    fiieeeld: [1x1 struct]
%  >> outStruct.fiieeeld
%  ans =
%          c: 'konIjn'
%        zot: 666

if nargin ~= 1 | ~isstruct(inStruct)
    error('Only argument should be structure');
end

inFields = fieldnames(inStruct);
if isempty(inFields) % a struct without fields
    outStruct = inStruct;
    return;
end

emptiness = repmat({[]}, 1, length(inFields)); % just empty arrays, will be used later
fieldNames = lower(inFields); 
for structCount=1:length(inStruct)
    % Create an empty structure with the lowercase fieldnames
    outStruct(structCount) = cell2struct(emptiness, fieldNames, 2);
    for i=1:length(inFields)
        inField = getfield(inStruct(structCount),inFields{i});
        if ~isstruct( inField )
            outStruct(structCount) = setfield( outStruct(structCount), fieldNames{i}, inField );
        else % field is a structure again: recurse
            outStruct(structCount) = setfield( outStruct(structCount), fieldNames{i}, lowerFields( inField ));
        end
    end
end