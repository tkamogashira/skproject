function fraclabels = setfraclabels(this, fraclabels)
%SETFRACLABELS   PreSet function for the 'fraclabels' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

hs = getcomponent(this, '-class', 'siggui.selectorwvalues');

if isempty(hs), return; end

fstr = getfracstr(this);

for indx = 1:length(fraclabels)
    strs = {...
        sprintf('%s %s:', getTranslatedString('dsp:fdtbxgui:fdtbxgui', fraclabels{indx}),...
        getTranslatedString('dsp:fdtbxgui:fdtbxgui',sprintf('%s length',fstr))), ...
        sprintf('%s %s (+/-):', getTranslatedString('dsp:fdtbxgui:fdtbxgui', fraclabels{indx}),...
        getString(message('dsp:fdtbxgui:fdtbxgui:range')))};
    set(hs(indx), 'Strings', strs)
end

% [EOF]

