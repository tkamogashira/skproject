function updatecicinfo(this)
%UPDATECICINFO   Update the CIC Frames

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

h = get(this, 'Handles');

Hd = copy(this.Filter);

switch lower(this.FilterInternals)
    case 'full'
        set(Hd, 'FilterInternals', 'fullprecision');
        ho = getcomponent(this, 'output');
        set(ho, 'WordLength', num2str(Hd.OutputWordLength), ....
            'FracLengths', {num2str(Hd.OutputFracLength)});

        set(h.sectionwordlengths, 'String', num2str(Hd.SectionwordLengths));
        set(h.sectionfraclengths, 'String', num2str(Hd.SectionFracLengths));
    case 'minimum section word lengths'
        set(Hd, 'FilterInternals', 'minwordlengths');
        ho = getcomponent(this, 'output');
        set(ho, 'FracLengths', {num2str(Hd.OutputFracLength)});
        
        set(h.sectionwordlengths, 'String', num2str(Hd.SectionwordLengths));
        set(h.sectionfraclengths, 'String', num2str(Hd.SectionFracLengths));
    case 'specify word lengths'
        set(Hd, 'FilterInternals', 'specifywordlengths');
        ho = getcomponent(this, 'output');
        set(ho, 'FracLengths', {num2str(Hd.OutputFracLength)});

        set(h.sectionwordlengths, 'String', this.SectionwordLengths);
        set(h.sectionfraclengths, 'String', num2str(Hd.SectionFracLengths));
    case 'specify all'
        set(Hd, 'FilterInternals', 'SpecifyPrecision');

        set(h.sectionwordlengths, 'String', this.SectionWordLengths);
        set(h.sectionfraclengths, 'String', this.SectionFracLengths);
end

% [EOF]
