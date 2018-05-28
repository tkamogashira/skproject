function structOut = fillStruct(tempStruct, valueStruct)
% FILLSTRUCT fill tempStruct with values from valueStruct
%
% struct structOut = fillStruct(struct tempStruct, struct valueStruct)
%
%   tempStruct: a structure that will be filled with values. This structure
%               need not be flat.
%  valueStruct: a structure containing the values for tempStruct. This
%               structure has to be flat. Not all values need to be used.
%
% Example:
%   >> valueStruct.a = 1; valueStruct.b = 2; valueStruct.c = 3; 
%   >> valueStruct.d = 43; valueStruct.e = 5;
%   >> tempStruct.a = 'dummy'; tempStruct.level2.c = 'dummy';
%   >> tempStruct.level3.d = 'dummy';
%   >> structOut = fillStruct(tempStruct, valueStruct)
%   structOut = 
%       a: 1
%       level2: [1x1 struct]
%       level3: [1x1 struct]
%   >> structOut.level2
%   ans = 
%       c: 3
%   >> structOut.level3
%   ans = 
%       d: 43

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006


%% Parameter checking
if ~isFlat(valueStruct)
    error('valueStruct must be flat. Type ''help fillStruct'' for more information.');
end

%% Start filling, recursively
FN = fieldnames(tempStruct);
for i=1:size(FN)
    if isstruct( tempStruct.(FN{i}) )
        tempStruct = setfield(tempStruct, FN{i}, ...
            fillStruct(tempStruct.(FN{i}), valueStruct) );
    else
        tempStruct = setfield( tempStruct, FN{i}, valueStruct.(FN{i}) );
    end
end

structOut = tempStruct;
