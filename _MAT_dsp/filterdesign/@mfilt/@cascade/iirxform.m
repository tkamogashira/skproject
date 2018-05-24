function [Ht, anum, aden] = iirxform(Ho,fun,varargin)
%IIRXFORM IIR Transformations

%   Author(s): R. Losada
%   Copyright 2005-2011 The MathWorks, Inc.


% This should be private
error(message('dsp:mfilt:cascade:iirxform:invalidStructure', get( Ho, 'FilterStructure' )));


% [EOF]
