function  Whi = getFIRFilterDesignMultibandWhi(Whi)
% getFIRFilterDesignMultibandWhi Helper function used to forward Digital 
% FIR Filter Design block to a Digital Filter block. 

% Copyright 2013 The MathWorks, Inc.

if (Whi == 0)
    Whi = 'DC-0';
else
    Whi = 'DC-1';
end