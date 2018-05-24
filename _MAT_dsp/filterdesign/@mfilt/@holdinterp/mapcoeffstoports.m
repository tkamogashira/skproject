function [out coeffnames variables] = mapcoeffstoports(this,varargin)
%MAPCOEFFSTOPORTS 

%   Copyright 2009 The MathWorks, Inc.

coeffnames = [];
variables = [];
[out idx] = parse_mapcoeffstoports(this,varargin{:});

if ~isempty(idx), 
    error(message('dsp:mfilt:holdinterp:mapcoeffstoports:InvalidParameter', class( this )));
end


% [EOF]
