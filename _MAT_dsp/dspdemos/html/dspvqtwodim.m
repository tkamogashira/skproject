%% Vector Quantizer Design
% This example shows the Vector Quantizer Design process using
% Generalized Lloyd Algorithm (GLA) for a two dimensional input.
%
% <<dspvqtwodim_screenshot.png>>

% Copyright 2007-2012 The MathWorks, Inc.


%% Applications
% This example uses the Generalized Lloyd Algorithm, which is a common
% codebook design algorithm for digital image compression.

%% Exploring the Example
% The two-dimensional codebook and corresponding Voronoi cells are shown in
% the upper plot. Individual codebook values are represented by small round
% symbols. The training set is shown in the plot as a light green cloud of
% points behind the cells. You can examine each codeword by right-clicking
% on it and holding the mouse button down. You can change codeword values
% by left-clicking on the symbol, holding the mouse button down, and
% dragging it to a new location. The Voronoi cells change to indicate the
% updated partition.
%
% The lower plot shows the number of training vectors belonging to each
% Voronoi cell.
%
% To run the example, you need to specify a training set and the number of
% levels. Enter the training set using the *Training Set (TS)* parameter.
% Enter an initial codebook in one of three ways:
% 
% * Auto-generate - The example will select a set of initial codebook
% values based on the value entered in the *Number of levels* parameter.
% * User defined - Use the *Initial codebook* parameter to enter the
% codebook.
% * From plot - The codebook values shown in the plot are used.
%
% The stopping criteria are "Relative threshold", "Maximum iteration", and 
% "Whatever comes first". The *Relative threshold* and *Maximum Iteration* 
% parameters are used to complete the stopping criteria.
%
% Try varying one or more of the available parameters, run the example, and
% observe the change in the codebook after each iteration until the
% stopping criteria is met.

%% References
% Gersho, A. and R. Gray. *Vector Quantization and Signal Compression.*
% Boston: Kluwer Academic Publishers, 1992.
