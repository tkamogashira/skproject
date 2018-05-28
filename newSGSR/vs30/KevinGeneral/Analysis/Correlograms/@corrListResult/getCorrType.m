function corrType = getCorrType(CLR)
% GETCORRTYPE Gets the correlation type of the corrListResult instance
%
% corrType = getCorrType(CLR)
% Returns the type of the corrListResult instance CLR ('sum', 'dif' or
% simply 'cor'). 

corrType = CLR.corrType;