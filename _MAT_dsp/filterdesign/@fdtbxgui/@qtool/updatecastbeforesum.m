function updatecastbeforesum(this)
%UPDATECASTBEFORESUM   Update the cast before sum checkbox.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

h = get(this, 'Handles');

if strcmpi(get(getcomponent(this, 'tag', 'accum'), 'Mode'), 'Full precision')
    enab = 'off';
else
    enab = this.Enable;
end

if isfilterinternals(this) || ...
        this.CurrentTab ~= 3 || ...
        ~strncmpi(this.Arithmetic, 'fixed', 5) || ...
        isa(this.Filter, 'mfilt.abstractcic') || ...
        ~hasaccum(this, this.Filter)
    vis = 'off';
else
    vis = this.Visible;
end

setenableprop(h.castbeforesum, enab);
set(h.castbeforesum, 'Visible', vis);
prop_listener(this, 'castbeforesum');

% -------------------------------------------------------------------------
function b = hasaccum(this, Hd)

if issupported(this)
    info = qtoolinfo(Hd);
    b = true;
    if ~isempty(info)
        if isfield(info, 'accum')
            if isempty(info.accum)
                b = false;
            end
        end
    end
else
    b = false;
end

% [EOF]
