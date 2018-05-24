function z = getstates(Hm,dummy)
%GETSTATES  Get the filter states.
%   S = GETSTATES(Hd) returns the states (the tail of the output matrix) of
%   the overlap-add fft interpolator filter object.
  
%   Author: R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

z = Hm.hiddenstates;


