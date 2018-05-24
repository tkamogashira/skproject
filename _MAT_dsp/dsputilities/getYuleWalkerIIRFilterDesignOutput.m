function y = getYuleWalkerIIRFilterDesignOutput(N,F,A,outputNum)
% getYuleWalkerIIRFilterDesignOutput Helper function used to forward Digital 
% IIR Filter Design to a Digital Filter block. 

% Copyright 2013 The MathWorks, Inc.

[b,a] = yulewalk(N,F,A);
if outputNum == 1
    y = b;
else
    y = a;
end

end