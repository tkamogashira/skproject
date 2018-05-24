function this = modewordnfrac
%MODEWORDNFRAC   Construct a MODEWORDNFRAC object.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

this = fdtbxgui.modewordnfrac;

h = siggui.labelsandvalues('Maximum', 3);

addcomponent(this, h);

set(this, ...
    'Name', 'Product', ...
    'FracLabels', {'Num.', 'Den.'}, ...
    'WordLength', '16', ...
    'FracLengths', {'15', '15'}, ...
    'Mode', 'Full Precision');

l = handle.listener(allchild(this), 'UserModifiedSpecs', @ums_listener);
set(l, 'CallbackTarget', this);
set(this, 'UMS_Listener', l);

% -------------------------------------------------------------------------
function ums_listener(this, eventData)

send(this, 'UserModifiedSpecs');

% [EOF]
