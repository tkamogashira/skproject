function paramsOut = processParams(paramsIn, paramsTemp)
%  PROCESSPARAMS Fits a list of function parameters into a given template.
%  
%  struct paramsOut = processParams(cell array paramsIn, struct paramsTemplate)
%  
%         paramsIn:  A cell array (1x2n), containing pairs of arguments:
%                      1. a parameter name (string),
%                      2. the value of that parameter
%                    If paramsIn is a struct, it's values will be used to
%                    fill out the template.
%   paramsTemplate:  A structure, serving as a template for the params 
%                    structure. If paramsIn contains parameter names that 
%                    are not in this template, an error is thrown.
%          returns:  paramsTemplate is returned. Values are replaced by 
%                    values in paramsIn, all other values remain untouched.
% 
%  Example:
%     >> paramsTemplate.param1 = 'def';
%     >> paramsTemplate.param2 = 'def';
%     >> paramsTemplate.param3 = 'def';
%     >> paramsIn = {'param1', 'value1', 'param2', 2};
%     >> processParams(paramsIn, paramsTemplate)
%     ans = 
%         param1: 'value1'
%         param2: 2
%         param3: 'def'

% Created by: Kevin Spiritus
% Last edited: December 7th, 2006

%% check params
if ~isequal(2, nargin)
    error('processParams takes 2 arguments!');
end

% paramsIn can, for practical reasons be a cell 1x1 array, containing a struct
if isequal([1 1], size(paramsIn)) && iscell(paramsIn)
    if isstruct(paramsIn{1})
        paramsIn = paramsIn{1};
    end
end

%% Handle paramsIn
switch class(paramsIn)
    case 'cell'
        % currently is cell array {'param1', value1, 'param2', value2, ...}
        SParam = size(paramsIn);
        if ~( isequal(1, SParam(1)) | isempty(paramsIn) )%#ok<OR2>
            error('Parameter arguments should be given als a one row.');
        end
         % odd number of params? should be even
         % (property1, value1, property2, value2, ...)
        if ~isequal(0, mod(SParam(2)/2, 1))
            error(['Parameter arguments should be given in pairs: ' ...
                'property1, value1, property2, value2, ...']);
        end
        % param names are strings?
        for i = 1:2:SParam(2)
            if ~ischar(paramsIn{i})
                error('Parameter names should be strings.');
            end
        end

        % not a structure yet: fix it
        paramsInStruct = [];
        for i = 1:2:SParam(2)
            paramsInStruct.(paramsIn{i}) = paramsIn{i+1};
        end
        if isstruct(paramsInStruct)
            paramsInStruct = flatStruct(paramsInStruct);
        end
    case 'struct'
        paramsInStruct = flatStruct(paramsIn);
    otherwise
        error('First argument should be a list of parameters, or a structure.');
end

%% Get the fields from the given parameter lists
if ~isempty(paramsInStruct)
    inFields = fieldnames(paramsInStruct);
else
    inFields = [];
end

%% flatten the paramsTemplate
flatParamsTemp = flatStruct(paramsTemp);
tempFields = fieldnames(flatParamsTemp);

%% cycle through the input parameters
for i = 1:size(inFields, 1)
    % make sure the given parameter is in the template
    inStudiedField = inFields{i};
    % ignore casing
    findParam = strmatch(lower(inStudiedField), lower(tempFields), 'exact');
    if isempty(findParam)
        error(['Parameter ''' inStudiedField ''' was not expected.']);
    else
        tempStudiedField = tempFields{findParam};         % casing
    end

    % introduce shorter notations
    inValue = paramsInStruct.(inStudiedField);
    tempValue = flatParamsTemp.(tempStudiedField);

    if iscell(inValue)
        if isequal(1, length(inValue)) && ischar(inValue{1})
            inValue = inValue{1};
        end
    end   
    
    % if tempValue is a character, the user can pass whatever he wants
    % user can also replace all required input by a string (not scalar!)
    % only check other cases
    if ~ischar(tempValue) && (~ischar(inValue) || iscell(tempValue))
        if ~isequal( size(inValue), size(tempValue) ) && ...
                ~isempty(tempValue) && ~iscell(inValue)
                % make it possible to give just one value if all values should
                % be the same
                inValue = repmat({inValue}, size( tempValue ));
        end

        % compare data format of given parameter to what is expected
        if ~isequal( class( inValue ), class( tempValue ) )
            if isequal('cell', class( tempValue ))
                % when reaching this point, sizes should be ok. If a cell
                % is expected, but an array was entered, just put it in a
                % cell for flexibility.
                inValue = {inValue};
            elseif ~isempty(tempValue) && ~ischar(inValue)
                error(['Parameter ''' inFields{i} ...
                    ''' was expected, but was given in the wrong format.']);
            end
        end
    end

    % everything ok? now copy the data
    % flatParamsTemp.(tempStudiedField) = inValue;
    flatParamsTemp.(tempStudiedField) = inValue;
    
% go the next field in inFields
end

%% Blow up the structure
% Now flatParamsTemp is a flat version of what is expected
% use the template to blow it up again

paramsOut = blowStruct(flatParamsTemp, paramsTemp);
