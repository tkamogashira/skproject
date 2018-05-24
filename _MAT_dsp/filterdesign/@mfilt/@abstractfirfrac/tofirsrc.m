function Hm = tofirsrc(this)
%TOFIRSRC   Convert to a sample-rate converter.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

Hm = mfilt.firsrc;

set(Hm, ...
    'FilterStructure', 'Direct-Form FIR Polyphase Sample-Rate Converter', ...
    'RateChangeFactors', this.RateChangeFactors, ...
    'Numerator', this.Numerator);

% [EOF]
