function LineNr = ExtractRAPErrLineNr(ErrToken)
%ExtractRAPErrLineNr    extracts error line number from ERR token
%   LineNr = ExtractRAPErrLineNr(ErrToken)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 04-02-2004

LineNr = ErrToken{3};