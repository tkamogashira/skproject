function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if length(q.ncoeffs) == 2,

    % Define numerator product format & update fimath object
    [numProdWL, numProdFL] = set_numprodq(q, q.privcoeffwl, q.privcoefffl, ...
        max(q.privinwl,q.privoutwl), ...
        q.privinfl);

    % Define numerator accumulator format & update fimath
    set_numaccq(q,numProdWL,numProdFL,q.ncoeffs(1));

    % Define denominator product format & update fimath (q.fimath2) object
    [denProdWL, denProdFL] = set_denprodq(q,q.privcoeffwl,...
        q.privcoefffl2, ...
        max(q.privinwl,q.privoutwl), ...
        q.privoutfl);

    % Define denominator accumulator format & update fimath (q.fimath2) object
    set_denaccq(q,denProdWL,denProdFL,q.ncoeffs(2));

end

% [EOF]
