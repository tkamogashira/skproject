%% Comparison of Spectral Analysis Techniques
% This example shows how to simultaneously display spectral estimates
% computed by the Periodogram, Burg Method, and Modified
% Covariance Method blocks using the Vector Scope block, and compares these
% methods against a reference magnitude FFT method.
%%

% Copyright 2005-2012 The MathWorks, Inc.

open_system('dspsacomp');
set_param('dspsacomp','StopTime','2');
sim('dspsacomp');
%%
bdclose dspsacomp
