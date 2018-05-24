function [accWL, accFL] = fullprecisionaccum(q, accinWL, accinFL, bits2add)
%FULLPRECISIONACCUM   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

accWL = accinWL + bits2add;
accFL = accinFL;


% [EOF]
