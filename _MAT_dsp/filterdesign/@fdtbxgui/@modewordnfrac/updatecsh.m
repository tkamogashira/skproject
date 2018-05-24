function updatecsh(this)
%UPDATECSH   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

tag = get(this, 'Tag');

h = get(this, 'Handles');

cshelpcontextmenu([h.mode_lbl h.mode], ...
    fullfile(sprintf('fdatool_qtool_%smode', tag), 'dsp'), 'fdatool');

h = get(this.allchild, 'Handles');

cshelpcontextmenu([h.labels(1) h.values(1)], ...
    fullfile(sprintf('fdatool_qtool_%swordlength', tag), 'dsp'), 'fdatool');

for indx = 1:length(this.FracLabels)
    fl = lower(strrep(strrep(this.FracLabels{indx}, '.', ''), ' ', ''));
    cshelpcontextmenu([h.labels(indx+1) h.values(indx+1)], ...
        fullfile(sprintf('fdatool_qtool_%s%sfraclength', fl, tag), 'dsp'), 'fdatool');
end

% [EOF]
