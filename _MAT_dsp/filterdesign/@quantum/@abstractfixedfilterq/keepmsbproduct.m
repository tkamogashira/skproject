function prodFL = keepmsbproduct(q, coeffWL, coeffFL, multWL, multFL, prodWL)
%KEEPMSBPRODUCT   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

if prodWL<multWL + coeffWL,
    % Lose some LSBs
    intLength = (multWL + coeffWL)-(multFL + coeffFL);
    prodFL = prodWL - intLength;
else
    prodFL = multFL + coeffFL;
end


% [EOF]
