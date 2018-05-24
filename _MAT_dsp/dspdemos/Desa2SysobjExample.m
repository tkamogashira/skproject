%% Creating New Kinds of System objects: a Teager-Kaiser DESA-2 Operator
% This example takes the perspective of a MATLAB developer willing to 
% author an instantaneous frequency estimator based on a Discrete Energy
% Separation Algorithm. It also introduces creating System objects for
% custom DSP algorithms.

% Copyright 2013 The MathWorks, Inc.
 
%% The Discrete Energy Separation Algorithms
% The Discrete Energy Separation Algorithms (or DESA) provide instantaneous
% estimates of amplitude and frequency for sinusoidal signals. 
% The basic building block of DESA is the nonlinear Teager-Kaiser Energy
% Operator (TKEO)
%
% $\Psi(x[n]) = x^2[n]+x[n-1] x[n+1]$ 
%
% In particular, the DESA-2 algorithm provides instantaneous estimates for
% amplitude (or AM function) and frequency (or FM function) through the 
% following expressions
% 
% $|a[n]| \simeq \frac{2\Psi(x[n])}{\sqrt{\Psi(x[n+1] - x[n-1])}}$
%
% $|f[n]| \simeq \arcsin\sqrt{\frac{\Psi(x[n+1] - x[n-1])}{4\Psi(x[n])}}$
%
%% The newly-developed algorithm used within a simple test bench
% To start, <matlab:run('HelperDesa2Sysobj') run> an example of a final
% result - a simple system simulation using the newly developed DESA-2
% frequency estimator (<matlab:edit('dspdemo.DesaTwo') dspdemo.DesaTwo>)
% within a simple testbench. 
% The testbench includes an FM-modulated tone generator 
% (<matlab:edit('dspdemo.RandomFMToneGenerator') 
% dspdemo.RandomFMToneGenerator>), two scopes for signal visualization and
% the ability to tune a number of system parameters during simulation.
% In particular you can experiment with changing three parameters that
% affect the frequency variation of the FM-modulated tone test input, i.e.
% 
% * The frequency offset
% * The frequency standard deviation 
% * The bandwidth of the random frequency variations, identified as 
% Frequency Volatility for short
% 
% The signal generator and the frequency estimator are both implemented as
% custom System objects.
% You can inspect the simulation script <matlab:edit('HelperDesa2Sysobj')
% HelperDesa2Sysobj> and identify these three main tasks
% 
% * Definition of the initial values of parameters
% * Creation of all objects used in simulation
% * Execution of the actual simulation loop

%% System-level view
% The simulated system could be represented graphically as follows
%  
% <<SystemLevelView.png>>
%
% The diagram above helps understand how the different algorithmic
% components work together within the system simulation. It also helps
% visualize how the different portions of the system are packaged and used.
% In particular, all orange blocks represent System objects available
% within the DSP System Toolbox, while all cyan blocks represent
% custom MATLAB-authored System objects developed for this example.
% 
% At a high level the simulation uses two instances of the following
% custom System objects, both authored in MATLAB
%
% * <matlab:edit('dspdemo.RandomFMToneGenerator') 
%   dspdemo.RandomFMToneGenerator>, to generate the test signal
% * <matlab:edit('dspdemo.DesaTwo') dspdemo.DesaTwo>, to estimate the
%   frequency of the test signal
%
% Within dspdemo.DesaTwo, notice for example the presence of two instances
% of dspdemo.TeagerKaiserOperator, one for $\Psi(x[n])$ and the other for
% $\Psi(x[n+1] - x[n-1])$

%% Code and architecture of dspdemo.RandomFMToneGenerator
% RandomFMToneGenerator is composed of two other classes internally. One is
% <matlab:doc('dsp.BiquadFilter') dsp.BiquadFilter>, a built-in System
% object, and the other is
% <matlab:edit('dspdemo.BandlimitedNoiseGenerator')
% dspdemo.BandlimitedNoiseGenerator>, another custom System object.
% 
% If you are familiar with UML, the following diagram gives a more detailed
% overview of the architecture of dspdemo.RandomFMToneGenerator:
%  
% <<RandomFMToneGeneratorUML.png>>
%
% Inspecting the code of <matlab:edit('dspdemo.RandomFMToneGenerator') 
% dspdemo.RandomFMToneGenerator> helps further clarify how its lower-level
% components work together. 
% 
% The stepImpl method in particular implements the core functionality of
% the public step() method. Here separating responsibilities and hiding
% inner complexity within the other classes helps to simplify the code.
% Note how stepImpl calls in turn the step() methods of the two other
% System objects

%% Code and architecture of the DESA-2 frequency-estimation operator
% The DESA-2 frequency-estimation operator (<matlab:edit('dspdemo.DesaTwo')
% dspdemo.DesaTwo>) is again implemented as a custom System object. 
% This time though its step method accepts a buffer of samples as input and
% it returns local estimates of the tone amplitude and frequency.
% Comparing the equations for the operator on one hand and the class 
% diagram on the other, notice how the DESA-2 operator is composed of two 
% Teager-Kaiser energy operators of type TeagerKeiserEnergyOperator, as
% previously anticipated by visually inspecting the system-level diagram.
%  
% <<DesaTwoUML.png>>
%
%% Reusability of subcomponents - dspdemo.BandlimitedNoiseGenerator
% Packaging subcomponents as individual System objects also helps with
% reusing and testing.
% 
% For example a key component of 
% <matlab:edit('dspdemo.RandomFMToneGenerator') 
% dspdemo.RandomFMToneGenerator> is 
% <matlab:edit('dspdemo.BandlimitedNoiseGenerator') 
% dspdemo.BandlimitedNoiseGenerator>.
% dspdemo.BandlimitedNoiseGenerator generates a zero-mean random signal
% with a prescribed bandwidth and RMS amplitude, and it is used here to
% define the frequency variations of the test signal around its offset
% value.
% 
% Similarly to the main dspdemo.DesaTwo object, 
% dspdemo.BandlimitedNoiseGenerator can be used in isolation by creating an
% instance, setting its parameters and calling its step method in a
% simulation loop. An example simulation script is 
% <matlab:edit('HelperDesa2SysobjTestBLNG') HelperDesa2SysobjTestBLNG>
% (<matlab:run('HelperDesa2SysobjTestBLNG') run>). 

%% Reference
% P. Maragos, J.F. Kaiser, T.F. Quartieri, Energy Separation in Signal
% Modulations with Application to Speech Analysis, IEEE Transactions on
% Signal Processing, vol. 41, No. 10, October 1993

displayEndOfDemoMessage(mfilename)
