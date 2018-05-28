function calcType = getCalcType(CLR)
% GETCALCTYPE Gets the calculation type of the corrListResult instance.
%
% calcType = getCalcType(CLR)
%  Returns the type of the calculations for the results stored in of the
%  corrListResult instance CLR. This can be 'RefRow', 'All', 'DeltaDiscern'
%  or 'Within'.

calcType = CLR.calcType;