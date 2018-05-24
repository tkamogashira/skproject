function this = qtool(Hd)
%QTOOL   Construct a QTOOL object.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

error(nargchk(1,1,nargin,'struct'));

this = fdtbxgui.qtool;

hc = fdtbxgui.wordfracnrange;
set(hc, 'AutoScaleAvailable', 'On', 'Maximum', 3, 'Tag', 'coeff', ...
    'AutoScaleDescription', 'Best-precision fraction lengths');

hi = fdtbxgui.wordfracnrange;
set(hi, 'Maximum', 1, 'Tag', 'input', 'Name', 'Input', 'Abbreviate', 'Off', ...
    'FracLabels', {'Input'}, 'AutoScaleAvailable', 'Off');

ho = fdtbxgui.wordfracnrange;
set(ho, 'AutoScaleAvailable', 'On', 'Maximum', 1, 'Tag', 'output', ...
    'Name', 'Output', 'Abbreviate', 'Off', 'FracLabels', {'Output'});

hsi = fdtbxgui.wordnfrac;
set(hsi, 'Maximum', 1, 'Tag', 'sectioninput', 'Name', 'Section input', ...
    'FracLabels', {'Section input'});

hso = fdtbxgui.wordnfrac;
set(hso, 'Maximum', 1, 'Tag', 'sectionoutput', 'Name', 'Section output', ...
    'FracLabels', {'Section output'});

hp = fdtbxgui.modewordnfrac;
set(hp, 'Tag', 'product', 'Name', 'Product', 'WordLength', '32', ...
    'FracLengths', {'30', '30'});

ha = fdtbxgui.modewordnfrac;
set(ha, 'Tag', 'accum', 'Name', 'Accum.', 'WordLength', '40', ...
    'FracLengths', {'30', '30'}, 'Mode', 'Keep MSB');

hs = fdtbxgui.wordnfrac;
set(hs, 'Maximum', 2, 'Tag', 'state', 'Name', 'State', 'MaxWord', 2);

hm = fdtbxgui.wordnfrac;
set(hm, 'Maximum', 1, 'Tag', 'multiplicand', 'Name', 'Multiplicand', ...
    'FracLabels', {'Multiplicand'}, 'Abbreviate', 'On', 'AutoScaleAvailable', 'Off');

hts = fdtbxgui.modewordnfrac;
set(hts, 'tag', 'tapsum', 'Name', 'Tap sum', 'WordLength', '17', ...
    'FracLabels', {'Tap sum'}, 'FracLengths', {'15'}, 'Mode', 'Keep MSB');

addcomponent(this, [hc hi ho hsi hso hp ha hs hm hts]);

set(this, 'Filter', Hd);

l = [ ...
        handle.listener(allchild(this), 'UserModifiedSpecs', @usermodifiedspecs_listener); ...
        handle.listener(this, [this.findprop('CastBeforeSum') this.findprop('Normalize') ...
        this.findprop('Unsigned') this.findprop('RoundMode') this.findprop('OverflowMode') ...
        this.findprop('SectionWordLengthMode') this.findprop('SectionWordLengths') ...
        this.findprop('FilterInternals')], ...
        'PropertyPostSet', @usermodifiedspecs_listener); ...
    ];
set(l, 'CallbackTarget', this);
set(this, 'Listeners', l, 'TabAlignment', 'Right');

% -------------------------------------------------------------------------
function usermodifiedspecs_listener(this, eventData)

set(this, 'isApplied', false);

if isrendered(this) && isa(this.Filter, 'mfilt.abstractcic')
    updatecicinfo(this);
end

% [EOF]
