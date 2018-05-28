function [ds1, ds2] = getDSInfo(CLR)
% GETDSINFO Gets the dataset information from the corrListResult instance.
%
% [ds1, ds2] = getDSInfo(CLR)
% Returns the dataset information from the corrListResult instance CLR.

ds1 = CLR.ds1;
ds2 = CLR.ds2;