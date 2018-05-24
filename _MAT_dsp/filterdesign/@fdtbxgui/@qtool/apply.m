function varargout = apply(this)
%APPLY   Apply the settings of the GUI

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

% Perform the apply action

hFilt = get(this, 'Filter');
arith = get(hFilt, 'Arithmetic');

if any(strcmpi(arith, 'fixed')),

    sendstatus(this, 'Quantizing Filter ...');

    h = allchild(this);

    for indx = 1:length(h)
        s.(get(h(indx), 'Tag')) = getsettings(h(indx));
    end

    s.castbeforesum = this.CastBeforeSum;
    if strcmpi(this.Unsigned, 'off')
        s.signed = 'on';
    else
        s.signed = 'off';
    end
    s.normalize     = this.Normalize;
    s.roundmode     = convertroundmode(this);
    s.overflowmode  = this.OverflowMode;

    set(this, 'prevAppliedState', s);

    state2filt(this);
    set(this, 'isApplied', true);

    sendstatus(this, 'Quantizing Filter ... done');

else
    set(this, 'isApplied', true);
    send(this, 'NewSettings');
end


% -------------------------------------------------------------------------
function roundmode = convertroundmode(this)

switch lower(this.Roundmode)
    case 'round'
        roundmode = 'round';
    case 'ceiling'
        roundmode = 'ceil';
    case 'floor'
        roundmode = 'floor';
    case 'zero'
        roundmode = 'fix';
    case 'nearest'
        roundmode = 'nearest';
    case 'nearest (convergent)'
        roundmode = 'convergent';
end

% [EOF]
