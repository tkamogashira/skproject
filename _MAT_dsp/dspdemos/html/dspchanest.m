%% Nonstationary Channel Estimation Using Recursive Least Squares
% This example shows how to track the time-varying weights of a
% nonstationary channel using the Recursive Least Squares (RLS) algorithm.
%
% The channel is modeled using a time-varying fifth-order FIR filter.
% The RLS filter and the unknown, nonstationary channel process the same
% input signal. The output of the channel with noise added is the
% desired signal. From this signal the RLS filter attempts to estimate the
% FIR coefficients that describe the channel. All that is known _a priori_ is
% the FIR length.
%
% When you run the model, a plot is
% made of each weight over time, with the "true" filter weights drawn in
% yellow, and the estimates of those weights in magenta. Each of the five
% weights is plotted on a separate axis.
%
%% Exploring the Example
% RLS is an efficient, recursive algorithm that converges to a good
% estimate of the FIR coefficients of the channel if the algorithm is
% properly initialized. Experiment with the value of the tunable
% *Forgetting factor* parameter in the RLS Filter block.
% A good initial guess is
% _(2N-1)/2N_ where _N_ is the number of weights. The *Forgetting factor*
% is used to indicate how fast the algorithm "forgets" previous samples. A
% value of 1 specifies an infinite memory. Smaller values allow the
% algorithm to track changes in the weights faster. However, a value that
% is too small will cause the estimates to be overly influenced by the
% channel noise.
%
open_system('dspchanest');
set_param('dspchanest','StopTime','900');
sim('dspchanest');
%%
bdclose dspchanest
%
%% References
% For more information on the Recursive Least Squares algorithm,
% see S. Haykin, *Adaptive Filter Theory*, 3rd Ed., Prentice Hall, 1996.
%%
% Copyright 2007-2012 The MathWorks, Inc.

