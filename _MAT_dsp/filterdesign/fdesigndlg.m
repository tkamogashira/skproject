function fdesigndlg(vname, type)
%FDESIGNDLG   Filter design dialog.
%   FDESIGNDLG(VARNAME, TYPE) launches the Filter Design dialog to design a
%   filter of type TYPE.  The designed filter is assigned to the variable
%   designated by the string VARNAME in the base workspace.  If a variable
%   with the given name already exists, it is overwritten.  TYPE can be any
%   of the following strings, and is 'lowpass' by default:
%
%   'lowpass'
%   'highpass'
%   'bandpass'
%   'bandstop'
%   'halfband'
%   'nyquist'
%
%   FDESIGNDLG(H) launches the Filter Design dialog to edit the filter in
%   object H.  If the filter H was designed using a filter specification
%   object or a design dialog, the dialog will be populated with the
%   previous design settings.  Otherwise, the dialog will be set up for a
%   lowpass design.
% 
%   EXAMPLES:
%      % Example 1 - Design a new lowpass filter and assign it to variable 'Hlow':
%      fdesigndlg('Hlow','lowpass')
%
%      % Example 2 - Alter the lowpass design that produced the filter Hlow:
%      Hlow = design(fdesign.lowpass);
%      fdesigndlg(Hlow)
%
%      % Example 3 - Design a new highpass filter the alter the design:
%      Hhigh = design(fdesign.highpass);
%      fdesigndlg(Hhigh)
%
%   See also FDATOOL, FVTOOL.

%   Author(s): J. Schickler
%   Copyright 2006-2011 The MathWorks, Inc.

error(nargchk(1,2,nargin,'struct'));

if nargin < 2
    if ischar(vname)
        type = 'lowpass';
    else
        hfd = getfdesign(vname);
        if isempty(hfd)
            type = 'lowpass';
        else
            type = lower(hfd.Response);
        end
    end
end

switch type
    case 'lowpass'
        type = 'FilterDesignDialog.LowpassDesign';
    case 'highpass'
        type = 'FilterDesignDialog.HighpassDesign';
    case 'bandpass'
        type = 'FilterDesignDialog.BandpassDesign';
    case 'bandstop'
        type = 'FilterDesignDialog.BandstopDesign';
    case 'halfband'
        type = 'FilterDesignDialog.HalfbandDesign';
    case 'nyquist'
        type = 'FilterDesignDialog.NyquistDesign';
    case 'hilbert'
        type = 'FilterDesignDialog.HilbertDesign';
    otherwise
        error(message('dsp:fdesigndlg:invalidFilterType', type));
end

hdesigner = feval(type);

l = handle.listener(hdesigner, 'DialogApplied', @(h, ed) dialogapplied);

schema.prop(hdesigner, 'DialogAppliedListener', 'handle.listener');
set(hdesigner, 'DialogAppliedListener', l);

if ischar(vname)
    %     assignin('base', vname, design(hdesigner));
else
    setGUI(hdesigner, vname);
    vname = inputname(1);
end

DAStudio.Dialog(hdesigner);


% -------------------------------------------------------------------------
    function dialogapplied

        assignin('base', vname, design(hdesigner));

    end

end

% [EOF]
