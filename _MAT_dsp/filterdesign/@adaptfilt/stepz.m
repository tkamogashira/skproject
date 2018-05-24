%STEPZ  Instantaneous adaptive filter step response.
%   [H,T] = STEPZ(Hd) returns the instantaneous step response H of the
%   adaptive filter Hd. The length of column vector H is the length of the
%   instantaneous impulse response. The vector of time samples at which H
%   is evaluated is returned in vector T.
%
%   [H,T] = STEPZ(Hd) returns a matrix H if Hd is a vector.  Each column of
%   the matrix corresponds to each filter in the vector. 
%
%   STEPZ(Hd) display the step response in the Filter Visualization Tool
%   (FVTool).
%
%   For additional parameters, see SIGNAL/STEPZ.
%  
%   See also ADAPTFILT/IMPZ, ADAPTFILT/FREQZ.

%   Author: P. Costa
%   Copyright 1999-2002 The MathWorks, Inc.

% Help for the p-coded STEPZ method of ADAPTFILT classes.
