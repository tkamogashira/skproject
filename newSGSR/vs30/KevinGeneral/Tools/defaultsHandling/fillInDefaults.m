function structOut = fillInDefaults(structIn, defaults)
% FILLINDEFAULTS replaces values of a struct's entries by their defaults.
%
% struct structOut = fillInDefaults(struct structIn, struct defaults)
%
%    structIn:  A structure which can contain 'def' entries. Structures can
%               contain multiple levels.
%    defaults:  Another structure containing default values. All entries of
%               structIn with 'def' value should be present in defaults, with
%               the same struct formatting. If not, a warning is given and
%               the 'def' value persists.
%     Returns:  fillInDefaults searches all cell array fields of structIn, and
%               replaces entries with value 'def' by the value indicated in
%               structure defaults.
%
% Example:
%     >> structIn.a = 5;
%     >> structIn.b.a = {1, 5, 'def'; 3, 7, 9};
%     >> defaults.b.a = 2006;
%     >> A = fillInDefaults(structIn, defaults);
%     >> A.a
%     ans =
%          5
%     >> A.b.a
%     ans =
%         [1]    [5]    [2006]
%         [3]    [7]    [   9]

% Created by: Kevin Spiritus
% Last edited: December 11th, 2006

if ~isstruct(structIn) | ~isstruct(defaults)
    error('Arguments are expected to be structures. Type ''help fillInDefaults'' for more information.');
end

objectFieldNames = fieldnames(structIn);
defaultsFieldNames = fieldnames(defaults);

for objectFieldCounter = 1:size(objectFieldNames)
    studiedFieldName = objectFieldNames{objectFieldCounter};
    fieldPresent = ~isempty(strmatch(studiedFieldName, defaultsFieldNames, 'exact'));
    if ~fieldPresent
        warning(['No default values specified for field ' studiedFieldName '. No action was taken.']); %#ok<WNTAG>
    else
        if isstruct(getfield(structIn, studiedFieldName))
            structIn = setfield(structIn, studiedFieldName, fillInDefaults(getfield(structIn, studiedFieldName), getfield(defaults, studiedFieldName)) );
        else
            structIn = setfield(structIn, studiedFieldName, replaceDef( getfield(structIn, studiedFieldName), getfield(defaults, studiedFieldName) ) );
        end
    end
    structOut = structIn;
end