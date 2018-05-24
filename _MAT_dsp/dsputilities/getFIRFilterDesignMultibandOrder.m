function N = getFIRFilterDesignMultibandOrder(N,W0,g0) 
% getFIRFilterDesignMultibandOrder Helper function used to forward Digital 
% FIR Filter Design block to a Digital Filter block. 

% Copyright 2013 The MathWorks, Inc.

% If we have an odd order multiband with high gain at the nyquist
% frequency, fir1 will increase the order of the filter by one.
% Hence we bump the window length by one as well.
if ((rem(N,2) && rem(length(W0),2) && g0 == 1) || ...
        (rem(N,2) && ~rem(length(W0),2) && g0 == 2))
    N = N + 1;
end