%% Time-Delay Estimation
% This example shows how to adaptively estimate the time delay for a noisy
% input signal using the LMS adaptive FIR algorithm. The peak in the
% filter taps vector indicates the time-delay estimate.
%
% For details, see S. Haykin, *Adaptive Filter Theory*, 3rd Ed., Prentice-Hall 1996.
%%

% Copyright 2005-2012 The MathWorks, Inc.

open_system('lmsadtde');
set_param('lmsadtde','StopTime','1');
sim('lmsadtde');
%%
bdclose lmsadtde
