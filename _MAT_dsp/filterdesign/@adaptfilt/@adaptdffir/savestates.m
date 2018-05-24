function savestates(h,W,X,ntr,L)
%SAVESTATES Save final state after filtering.

%   Author(s): S.C. Douglas
%   Copyright 1999-2002 The MathWorks, Inc.

h.privCoefficients = W;              %  save final coefficient vector
h.privStates = X(1:L-1);       %  save final filter States
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr;    %  update and save total number of iterations
