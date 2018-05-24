function Hd = createobj(this,coeffs)
%CREATEOBJ

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

h = coeffs{1};
if isa(h,'dfilt.basefilter'),
    Hd = h;
else
    g = coeffs{2};
    d = coeffs{3};

    filtstruct = get(this, 'FilterStructure');

    if isempty(g),
        % Single-section case
        Hd = feval(['dfilt.' filtstruct], h);
    elseif isempty(d),
        % Narrow-band case
        H(1) = feval(['dfilt.' filtstruct], g);
        H(2) = feval(['dfilt.' filtstruct], h);
        Hd = cascade(H);
    else
        % Wideband case
        H(1) = feval(['dfilt.' filtstruct], g);
        H(2) = feval(['dfilt.' filtstruct], h);
        G    = dfilt.delay(length(d)-1);

        % Connect the two branches in parallel
        Hd = parallel(cascade(H),G);
    end
end

    % [EOF]
