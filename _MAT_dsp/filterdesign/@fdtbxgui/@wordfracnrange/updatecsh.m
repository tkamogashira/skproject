function updatecsh(this)
%UPDATECSH   Update the CSH for the current settings.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

tag = get(this, 'Tag');
h   = get(this, 'Handles');

cshelpcontextmenu([h.wordlength h.wordlength_lbl], ...
    fullfile(sprintf('fdatool_qtool_%swordlength', tag), 'dsp'), 'fdatool');
if isfield(h, 'autoscale')
    cshelpcontextmenu(h.autoscale, ...
        fullfile(sprintf('fdatool_qtool_%sautoscale', tag), 'dsp'), 'fdatool');
end

hc = allchild(this);

for indx = 1:length(this.FracLabels)
    fl = lower(strrep(strrep(this.FracLabels{indx}, '.', ''), ' ', ''));
    h = get(hc(indx), 'Handles');
    cshelpcontextmenu(h.radio(1), ...
        fullfile(sprintf('fdatool_qtool_%s%sfraclength', fl, tag), 'dsp'), 'fdatool');
    cshelpcontextmenu(h.radio(2), ...
        fullfile(sprintf('fdatool_qtool_%s%srange', fl, tag), 'dsp'), 'fdatool');
end

% [EOF]
