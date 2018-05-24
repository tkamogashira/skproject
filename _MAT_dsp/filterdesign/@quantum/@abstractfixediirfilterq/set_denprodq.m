function [prodWL, prodFL] = set_denprodq(q,coeffWL, coeffFL, multWL, multFL)
%SET_DENPRODQ Specify product word and fraction length for the mexfunction.

% This should be a private method.

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

if strcmpi(q.privProductMode, 'FullPrecision'),
    [prodWL, prodFL] = fullprecisionproduct(q, coeffWL, coeffFL, multWL, multFL);
elseif strcmpi(q.privProductMode, 'KeepLSB'),
    prodWL = q.fimath2.ProductWordLength;
    prodFL = keeplsbproduct(q, coeffFL, multFL);
elseif strcmpi(q.privProductMode, 'KeepMSB'),
    prodWL = q.fimath2.ProductWordLength;
    prodFL = keepmsbproduct(q, coeffWL, coeffFL, multWL, multFL, prodWL);
else
    prodWL = q.fimath2.ProductWordLength;
    prodFL = q.fimath2.ProductFractionLength;
end

q.fimath2.ProductMode = 'SpecifyPrecision';
q.fimath2.ProductWordLength = prodWL;
q.fimath2.ProductFractionLength = prodFL;

% [EOF]
