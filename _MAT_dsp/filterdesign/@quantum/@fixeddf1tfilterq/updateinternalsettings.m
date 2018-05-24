function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS Update the fixed-point settings

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

if ~isempty(q.privmultwl),
    % Define denominator product format & update fimath (q.fimath2) object
    [denProdWL, denProdFL] = set_denprodq(q, q.privcoeffwl, q.privcoefffl2, ...
        q.privmultwl,...
        q.privmultfl);

    if length(q.ncoeffs) ~= 2,
        q.ncoeffs = [1 1];
    end

    % Define denominator accumulator format & update fimath
    [denAccWL, denAccFL] = set_denaccq(q,denProdWL,denProdFL,q.ncoeffs(2));

    % Define denominator state format
    set_denstateq(q, denAccWL, denAccFL);

    % Define numerator product format & update fimath (q.fimath) object
    [prodWL, prodFL] = set_numprodq(q, q.privcoeffwl, q.privcoefffl, ...
        q.privmultwl, ...
        q.privmultfl);

    % Define the numerator accumulator format & update fimath (q.fimath) object
    [numAccWL,numAccFL] = set_numaccq(q,prodWL,prodFL,q.ncoeffs(1));

    % Define numerator state format
    set_numstateq(q, numAccWL, numAccFL);

    % Send a quantizestates event
    send_quantizestates(q);

    % Define Output format
    set_outq(q,numAccWL, numAccFL);
end

% [EOF]
