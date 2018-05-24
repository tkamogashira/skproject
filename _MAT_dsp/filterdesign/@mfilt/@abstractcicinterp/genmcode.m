function h = genmcode(this, varname, place) %#ok
%GENMCODE   Generate an MATLAB code object for this filter.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

if nargin < 2
    varname = 'Hd';
end

h = sigcodegen.mcodebuffer;

params = {'dd', 'nsecs', 'iwl', 'ifl', 'intf'};
values = {sprintf('%d', this.DifferentialDelay), ...
    sprintf('%d', this.NumberOfSections), ...
    sprintf('%d', this.InputWordLength), ...
    sprintf('%d', this.InputFracLength), ...
    sprintf('%d', this.InterpolationFactor)};
descs = {'Differential Delay', 'Number of Sections', 'Input Word Length', ...
    'Input Fraction Length', 'Interpolation Factor'};

h.addcr(h.formatparams(params, values, descs));
h.cr;
h.addcr(sprintf('%s = %s(intf, dd, nsecs, iwl);', varname, class(this)));

h.cradd('set(%s, ''InputFracLength'', ifl, ...', varname);
h.cradd('        ''FilterInternals'', ''%s''', this.FilterInternals);

if strcmpi(this.FilterInternals, 'fullprecision'),
    h.add(');');
elseif strcmpi(this.FilterInternals, 'minwordlengths'),
    h.addcr(', ...');
    h.add('    ''OutputWordLength'', %d);', this.OutputWordLength);
elseif strcmpi(this.FilterInternals, 'specifywordlengths'),
    h.addcr(', ...');
    h.addcr('    ''OutputWordLength'', %d,...', this.OutputWordLength);
    h.add('    ''SectionWordLengths'', %s);', mat2str(this.SectionWordLengths));
elseif strcmpi(this.FilterInternals, 'specifyprecision'),
    h.addcr(', ...');
    h.addcr('    ''OutputWordLength'', %d,...', this.OutputWordLength);
    h.addcr('    ''SectionWordLengths'', %s,...', mat2str(this.SectionWordLengths));
    h.addcr('    ''SectionFracLengths'', %s,...', mat2str(this.SectionFracLengths));
    h.add('    ''OutputFracLength'', %d);', this.OutputFracLength);
end

% [EOF]
