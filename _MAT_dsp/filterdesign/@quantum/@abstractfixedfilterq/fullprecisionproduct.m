function [prodWL, prodFL] = fullprecisionproduct(q, coeffWL, coeffFL, multWL, multFL)
%FULLPRECISIONPRODUCT   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

prodWL = multWL + coeffWL;
prodFL = multFL + coeffFL;

% [EOF]
