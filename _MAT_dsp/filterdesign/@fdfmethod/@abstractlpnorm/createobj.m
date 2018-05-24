function Hd = createobj(this, coeffs)
%CREATEOBJ   Create the object from the coefficients

%   Author(s): J. Schickler
%   Copyright 2006 The MathWorks, Inc.

struct = get(this, 'FilterStructure');

Hd = feval(['dfilt.' struct], coeffs{:});

% If the user has specified either the scaling norm, scale the filter.
norm = get(this, 'SOSScaleNorm');
opts = get(this, 'SOSScaleOpts');
if ~isempty(norm) 
    if isempty(opts)
        opts = scaleopts(Hd);
        opts.NumeratorConstraint  = 'unit';
        opts.ScaleValueConstraint = 'none';
        this.SOSScaleOpts = opts;
    end

    % We cannot use 'auto' because it relies on the FDESIGN object
    % being attached to the DFILT>
    if strcmpi(opts.sosReorder, 'auto')
        opts.sosReorder = getsosreorder(this);
    end

    scale(Hd, norm, opts);
end

% [EOF]
