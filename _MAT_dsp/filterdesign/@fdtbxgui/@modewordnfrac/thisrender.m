function thisrender(this, varargin)
%THISRENDER   Render the mode, word and frac object.

%   Author(s): J. Schickler
%   Copyright 1999-2011 The MathWorks, Inc.
%     

pos  = parserenderinputs(this, varargin{:});
hFig = get(this, 'FigureHandle');
sz   = gui_sizes(this);

isfontlarge = 0;
if (ispc && sz.fontsize > 8) || (~ispc && sz.fontsize > 10)
    isfontlarge = 1;
end

if isempty(pos), pos = [10 10 200 200]*sz.pixf; end

poppos = [pos(1)-sz.hfus/2 pos(2)+pos(4)-sz.uh-2*sz.vfus pos(3)+sz.hfus sz.uh+2*sz.vfus];

rendercontrols(this, poppos, 'mode', sprintf('%s mode', this.Name));


% Reposition the width of the popup.
poppos = getpixelpos(this, 'mode');

poppos(1) = poppos(1)-5*sz.pixf;
poppos(3) = poppos(3)+5*sz.pixf;

setpixelpos(this, 'mode', poppos);

h = getcomponent(this, '-class', 'siggui.labelsandvalues');

ht = sz.uh*3+sz.vfus*4-3*sz.pixf;
lnvpos = [pos(1)+sz.hfus/2 pos(2)+pos(4)-ht-sz.uh-3*sz.vfus pos(3)-sz.hfus ht];

lblwidth = lnvpos(3)-28*sz.pixf;

render(h, hFig, lnvpos, lblwidth);

l = [ ...
        this.WhenRenderedListeners(:); ...
        handle.listener(this, this.findprop('Name'), 'PropertyPostSet', ...
        @name_listener); ...
        handle.listener(this, this.findprop('ModeAvailable'), ...
        'PropertyPostSet', @modeavailable_listener); ...
    ];
set(l, 'CallbackTarget', this);
set(this, 'WhenRenderedListeners', l);

updatecsh(this);

% -------------------------------------------------------------------------
function name_listener(this, eventData) %#ok

h = get(this, 'Handles');
set(h.mode_lbl, sprintf('%s %s:',...
    getTranslatedString('dsp:fdtbxgui:fdtbxgui',this.Name),...
    getTranslatedString('dsp:fdtbxgui:fdtbxgui','mode')));

% -------------------------------------------------------------------------
function modeavailable_listener(this, eventData) %#ok

visible_listener(this);

% [EOF]
