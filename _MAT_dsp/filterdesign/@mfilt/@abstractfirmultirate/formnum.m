function num = formnum(this,polym,ncoeffs)
%FORMNUM   Form numerator from polyphase matrix.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

if nargin < 3
    ncoeffs = this.ncoeffs;
    if nargin < 2
        polym = this.PolyphaseMatrix;
    end
end

num = double(polym);
num = num(:).';
% Remove trailing zeros
num = num(1:ncoeffs);

% [EOF]
