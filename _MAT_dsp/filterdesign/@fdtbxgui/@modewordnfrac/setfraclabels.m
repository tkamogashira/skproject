function fraclabels = setfraclabels(this, fraclabels)
%SETFRACLABELS   PreSet function for the 'fraclabels' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

h = getcomponent(this, '-class', 'siggui.labelsandvalues');

if ~isempty(h),
    lbls = get(h, 'Labels');
    lbls = lbls(1);
    str  = getfracstr(this);
    for indx = 1:length(fraclabels),
        lbls{indx+1} = sprintf('%s %s length:', fraclabels{indx}, str);
    end
    set(h, 'Labels', lbls);
    set(h, 'HiddenValues', [length(lbls)+1:h.Maximum]);
end

% [EOF]
