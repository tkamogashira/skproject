%% Adaptive Filter Convergence
% This example shows the convergence path taken by different adaptive
% filtering algorithms. The plot is a sequence of points of the form
% (w1,w2) where w1 and w2 are the weights of the adaptive filter. The blue
% dots in the figure indicate the contour lines of the error surface. Zoom
% into the graph to see properties of convergence path by selecting Zoom In
% from the Tools menu.
%
% This example does not depict the convergence speed of the different
% algorithms. You can experiment with different step-size values for the
% adaptive filters to see the change in convergence paths.
%
% Each of the adaptive filters can be enabled or disabled separately:
% 
% 
% * LMS - Least Mean Square algorithm
% * NLMS - Normalized LMS algorithm
% * SELMS - Sign-Error LMS algorithm
% * SSLMS - Sign-Sign LMS algorithm
%%

% Copyright 2006-2012 The MathWorks, Inc.

open_system('lmsxyplot');
sim('lmsxyplot');
%%
bdclose lmsxyplot
