function hidetab(this, tab)
%HIDETAB   Hide the tab.

%   Author(s): J. Schickler
%   Copyright 1999-2010 The MathWorks, Inc.

h = get(this, 'Handles');

if any(tab == 1)
    hc = getcomponent(this, 'tag', 'coeff');
    set(hc, 'Visible', 'Off');
    set([h.unsigned h.normalize h.normalize_extra h.coeffdivider], 'Visible', 'Off');
end

if any(tab == 2)
    set([h.inputdivider h.outputdivider h.sectiondivider], 'Visible', 'Off');
    hi = getcomponent(this, 'tag', 'input');
    ho = getcomponent(this, 'tag', 'output');
    hsi = getcomponent(this, 'tag', 'sectioninput');
    hso = getcomponent(this, 'tag', 'sectionoutput');
    set([hi ho hsi hso], 'Visible', 'Off');
end

if any(tab == 3)
    set([h.roundmode h.roundmode_lbl h.overflowmode h.overflowmode_lbl ...
        h.castbeforesum  h.modedivider h.proddivider h.accumdivider ...
        h.statedivider h.sectionwordlengths_lbl h.sectionwordlengths ...
        h.sectionfraclengths_lbl h.sectionfraclengths], 'Visible', 'Off');
    hp = getcomponent(this, 'tag', 'product');
    ha = getcomponent(this, 'tag', 'accum');
    hs = getcomponent(this, 'tag', 'state');
    hm = getcomponent(this, 'tag', 'multiplicand');
    hts = getcomponent(this, 'tag', 'tapsum');
    set([hp ha hs hm hts], 'Visible', 'Off');
end

% [EOF]
