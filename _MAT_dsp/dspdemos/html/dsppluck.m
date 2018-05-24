%% Simulation of a Plucked String
% This example shows how to simulate a plucked string using digital
% waveguide synthesis.
%%

% Copyright 2005-2013 The MathWorks, Inc.

open_system('dsppluck');
sim('dsppluck');
%%
bdclose dsppluck

%% Exploring the Example
% The result of the simulation is automatically played back using the *To
% Audio Device* block. To see the implementation, look under the *Digital
% Waveguide Synthesis* block by right clicking on the block and selecting
% |Look Under Mask|.

%% Acknowledgements
% This Simulink(R) implementation is based on a MATLAB(R) file implementation
% available from Daniel Ellis's home page at Columbia University.

%% References
% The online textbook *Digital Waveguide Modeling of Musical Instruments*
% by Julius O. Smith III covers significant background related to digital
% waveguides.
% 
% The Harmony Central
% website also provides very useful background information on a variety of
% related topics.