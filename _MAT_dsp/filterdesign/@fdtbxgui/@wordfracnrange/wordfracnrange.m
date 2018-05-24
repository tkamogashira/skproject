function this = wordfracnrange
%WORDFRACNRANGE   Construct a WORDFRACNRANGE object.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

this = fdtbxgui.wordfracnrange;

tags = {'length','range'};
strs = {'Specify length', 'Specify range'};
vals = {'15','1'};

addcomponent(this, siggui.selectorwvalues('1', tags, strs, 'length', '', vals));
addcomponent(this, siggui.selectorwvalues('2', tags, strs, 'length', '', vals));
addcomponent(this, siggui.selectorwvalues('3', tags, strs, 'length', '', vals));

set(this, 'Maximum', 1, 'Abbreviate', 'On');

% Force a call to update the fraclabels in the selectorwvalues.
this.setfraclabels(get(this, 'FracLabels'));

l = [ ...
        handle.listener(allchild(this), 'NewSelection', @ums_listener); ...
        handle.listener(allchild(this), 'UserModifiedSpecs', @ums_listener); ...
    ];
set(l, 'CallbackTarget', this);
set(this, 'UMS_Listeners', l);

% -------------------------------------------------------------------------
function ums_listener(this, eventData)

send(this, 'UserModifiedSpecs');

% [EOF]
