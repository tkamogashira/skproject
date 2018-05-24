%% Noise Canceler (RLS)
% This example shows how to subtract noise from an input signal using the
% Recursive Least Squares (RLS) algorithm. The RLS adaptive filter uses the
% reference signal on the Input port and the desired signal on the Desired
% port to automatically match the filter response in the Noise Filter
% block. As it converges to the correct filter, the filtered noise should
% be completely subtracted from the "Signal+Noise" signal, and the "Error
% Signal" should contain only the original signal.
%
% For details, see S. Haykin, *Adaptive Filter Theory*, 3rd Ed., Prentice-Hall 1996.
%%

% Copyright 2005-2012 The MathWorks, Inc.

open_system('rlsdemo');
%%
set_param('rlsdemo','StopTime','1000');
sim('rlsdemo');
%%
bdclose rlsdemo
