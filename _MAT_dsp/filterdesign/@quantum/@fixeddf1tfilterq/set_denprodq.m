function [prodWL, prodFL] = set_denprodq(q,coeffWL, coeffFL, multWL, multFL)
%SET_DENPRODQ Specify product word and fraction length for the mexfunction.

% This should be a private method.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(q.ProductMode, 'FullPrecision'),
    [prodWL, prodFL] = fullprecisionproduct(q, coeffWL, coeffFL, multWL, multFL);
elseif strcmpi(q.ProductMode, 'KeepLSB'),
    prodWL = q.ProductWordLength;
    prodFL = keeplsbproduct(q, coeffFL, multFL);
elseif strcmpi(q.ProductMode, 'KeepMSB'),
    prodWL = q.ProductWordLength;
    prodFL = keepmsbproduct(q, coeffWL, coeffFL, multWL, multFL, prodWL);
else
    prodWL = q.ProductWordLength;
    prodFL = q.DenProdFracLength;
end

if ~isempty(prodWL),
    q.fimath2.ProductMode = 'SpecifyPrecision';
    q.fimath2.ProductWordLength = prodWL;
    q.fimath2.ProductFractionLength = prodFL;
end

% [EOF]
