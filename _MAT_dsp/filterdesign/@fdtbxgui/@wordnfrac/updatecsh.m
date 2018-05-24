function updatecsh(this)
%UPDATECSH   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

tag = get(this, 'Tag');
h   = get(this, 'Handles');

lbl = lower(strrep(strrep(this.Name, '.', ''), ' ', ''));
cshelpcontextmenu([h.wordlength h.wordlength_lbl], ...
    fullfile(sprintf('fdatool_qtool_%s%swordlength', lbl, tag), 'dsp'), 'fdatool');

if isfield(h, 'autoscale');
    cshelpcontextmenu(h.autoscale, ...
        fullfile(sprintf('fdatool_qtool_%sautoscale', tag), 'dsp'), 'fdatool');
end

if isfield(h, 'wordlength2');
    lbl = lower(strrep(strrep(this.WordLabel2, '.', ''), ' ', ''));
    cshelpcontextmenu([h.wordlength2_lbl h.wordlength2], ...
        fullfile(sprintf('fdatool_qtool_%swordlength', lbl), 'dsp'), 'fdatool');
end

for indx = 1:length(this.FracLabels)
    lbl = lower(strrep(strrep(this.FracLabels{indx}, '.', ''), ' ', ''));
    cshelpcontextmenu([h.fraclength(indx) h.fraclength_lbl(indx)], ...
        fullfile(sprintf('fdatool_qtool_%s%sfraclength', lbl, tag), 'dsp'), 'fdatool');
end

% [EOF]
