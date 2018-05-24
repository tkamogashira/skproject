function [prodWL, prodFL] = set_prodq(q,coeffWL, coeffFL, multWL, multFL)
%SET_PRODQ Specify product word and fraction length for the mexfunction.

% This should be a private method.

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

if strcmpi(q.privProductMode, 'FullPrecision'),
    [prodWL, prodFL] = fullprecisionproduct(q, coeffWL, coeffFL, multWL, multFL);
elseif strcmpi(q.privProductMode, 'KeepLSB'),
    prodWL = q.fimath.ProductWordLength;
    prodFL = keeplsbproduct(q, coeffFL, multFL);
elseif strcmpi(q.privProductMode, 'KeepMSB'),
    prodWL = q.fimath.ProductWordLength;
    prodFL = keepmsbproduct(q, coeffWL, coeffFL, multWL, multFL, prodWL);
else
    prodWL = q.fimath.ProductWordLength;
    prodFL = q.fimath.ProductFractionLength;
end

q.fimath.ProductMode = 'SpecifyPrecision';
q.fimath.ProductWordLength = prodWL;
q.fimath.ProductFractionLength = prodFL;

% [EOF]
