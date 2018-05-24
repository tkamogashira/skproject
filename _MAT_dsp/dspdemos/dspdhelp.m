function htmlfilename = dspdhelp(whichblks)
% DSPDHELP DSP System Toolbox demo help function.
%   DSPDHELP Returns the path to the HTML help information file
%   corresponding to the demo.

%  This function enables multiple versions of one demo
%  to point to the same doc page.
%
%  REQUIREMENTS:
%     1) The info block calling this function
%        MUST be in the root of the demo model.
%     2) The name of the demo must end with a combination
%        of no more than two items from the following list:
%        _all, _frame, _fixpt, _win or _win32, _color, _intensity.

% Copyright 1995-2013 The MathWorks, Inc.

modelname = get_param(gcb, 'Parent');

% Remove _win32 or _fixpt (or _***) if present (before the ".")
htmlfilename = suffixstrip(modelname);

% Automatically generated HTML files no longer reside in
% toolbox/dsp/dspdemos/html.  The MATLAB 'web' command accounts for this
% situation by calling helpUtils.checkForDemoRedirect to look in 
% matlab/derived/win64/toolbox/dsp/dspdemos/html.
htmlfilename = [matlabroot '/toolbox/' whichblks '/' whichblks ...
    'demos/html/' htmlfilename '.html'];

function htmlfilename=suffixstrip(modelname)
% special treat for aero_radmod_dsp
htmlfilename = regexprep(modelname, 'aero_radmod_dsp.*$', 'aeroradmoddsp');
htmlfilename = regexprep(htmlfilename, '_.*$', '');
% special treat for aero_radmod_dsp
htmlfilename = regexprep(htmlfilename, 'aeroradmoddsp.*$', 'aero_radmod_dsp');
% special treat for 'dspUDPVoip and 'dspUDPEcho
htmlfilename = regexprep(htmlfilename, 'dspUDPVoip.*$', 'dspvoip');
htmlfilename = regexprep(htmlfilename, 'dspUDPEcho.*$', 'dspvoip');
% treat dspprogfirhdl dspmultichannelhdl specially, use _m suffix
htmlfilename = regexprep(htmlfilename, 'dspprogfirhdl', 'dspprogfirhdl_m');
htmlfilename = regexprep(htmlfilename, 'dspmultichannelhdl', 'dspmultichannelhdl_m');


