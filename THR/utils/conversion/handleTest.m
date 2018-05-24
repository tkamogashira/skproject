function mess = handleTest(h, CondStr, Descr);
% handleTest - test if h is a valid graphics object handle and test object type
%     mess = handleTest(h, CondStr, Descr) returns '' when h is a 
%     single handle meeting the condition in string CondStr.
%     Otherwise an appropriate error message based on
%     description Descr.
%
%     Valid CondStr values (case-insensitive, abbreviations allowed):
%            any: h can be any graphics object
%         figure: h must be figure handle
%      uicontrol: h must be uicontrol handle
%           axes: h must be axes handle
%
%     Example
%        axh = figure;
%        handleTest(axh, 'axes', 'The handle you passed');
%          ans =
%          The handle you passed is not a handle of an existing axes object.
%
%     See also numericTest, dimensionTest.

% test if condition string is known & unique
Alltests = {'any' 'figure' 'uicontrol' 'axes'};
[CondStr, errMess] = keywordMatch(CondStr, Alltests, 'condition string');
error(errMess);


mess = numericTest(h, 'nonnegative', [Descr ' is ']);
if ~isempty(mess), return; end

mess = dimensionTest(h, 'singlevalue', Descr);
if ~isempty(mess), return; end

switch CondStr,
case 'any',
    hmess = ([Descr ' is not a handle of existing graphics object.']);
    if ~ishandle(h), mess = hmess; end
case 'figure',
    hmess = ([Descr ' is not a handle of existing figure.']);
    if ~ishandle(h), mess = hmess; end
    if ~isempty(mess), return; end
    if ~isequal('figure', lower(get(h, 'type'))), mess = hmess; end
case 'uicontrol',
    hmess = ([Descr ' is not a handle of existing uicontrol.']);
    if ~ishandle(h), mess = hmess; end
    if ~isempty(mess), return; end
    if ~isequal('uicontrol', lower(get(h, 'type'))), mess = hmess; end
case 'axes',
    hmess = ([Descr ' is not a handle of an existing axes object.']);
    if ~ishandle(h), mess = hmess; end
    if ~isempty(mess), return; end
    if ~isequal('axes', lower(get(h, 'type'))), mess = hmess; end
end




