%% Using System Objects with MATLAB(R) Compiler(TM)
% This example shows how to use the MATLAB Compiler to create a
% standalone application from a MATLAB function, which uses System objects.

% Copyright 1995-2013 The MathWorks, Inc.

%% Introduction
% In this example, you compile the linear predictive coder matlab function
% <matlab:edit('dspLinearPredictiveCoderFcn.m') dspLinearPredictiveCoderFcn.m> using the MATLAB compiler and then run the
% generated standalone application. Linear predictive coder function
% illustrates LPC analysis and synthesis (LPC coding) of a speech signal.
% Note that compilation is supported only for System objects used inside
% MATLAB functions. MATLAB scripts using System objects are not supported
% by MATLAB compiler.

%% LPC Analysis and Synthesis of Speech
% Linear predictive coding function consists of two steps: analysis and
% synthesis. In the analysis section, you extract the reflection
% coefficients from the signal and use it to compute the residual signal.
% In the synthesis section, you reconstruct the signal using the residual
% signal and reflection coefficients. The function also plots the signal
% spectrum and the spectrum  estimated from the LPC coefficients.

%% Run the MATLAB Code
dspLinearPredictiveCoderFcn
close all;

%% Create a Temporary Directory for Compilation
% To compile the MATLAB function to create the standalone application, you
% use a temporary directory. You copy the MATLAB function to compile and
% the required helper files into this temporary directory.
compilerDir = [tempdir 'compilerDir']; % Name of temporary directory
if ~exist(compilerDir,'dir')
    mkdir(compilerDir); % Create temporary directory
end
curdir = cd(compilerDir);
copyfile(which('dspLinearPredictiveCoderFcn'));
copyfile(which('hfigslpc'));
copyfile(which('plotlpcdata'));
copyfile(which('speech_dft.mp3'));

%% Compile the MATLAB Function Into a Standalone Application
% You use the |mcc| function to compile the dspLinearPredictiveCoderFcn
% into a standalone application. You specify the '-m' option to generate a
% standalone application, '-N' option to include only the directories
% specified using the '-p' option in the path. This step takes a few
% minutes to complete.
mcc('-mN', 'dspLinearPredictiveCoderFcn', '-p', [matlabroot '/toolbox/dsp'], ...
       '-p', 'shared/dsp/vision/simulink/utilities', ...
       '-p', 'shared/dsp/vision/matlab/utilities/mex', ...
       '-p', 'shared/dsp/vision/simulink/utilities/mex', ...
       '-p', 'shared/dsp/vision/matlab/utilities/init', ...
       '-p', 'shared/dsp/vision/matlab/vision', ...
       '-p', 'shared/dsp/vision/simulink/vision');

%% Run the Deployed Application
% You use the |system| command to run the generated standalone application.
% Note that running the standalone application using the system command
% uses the current MATLAB environment and any library files needed from
% this installation of MATLAB. To deploy this application to end users
% refer to the 'Deployment Process' section in the users guide for
% <matlab:doc('Compiler') MATLAB Compiler> product.
if ismac
    system(['dspLinearPredictiveCoderFcn.app/Contents/MacOS' filesep 'dspLinearPredictiveCoderFcn']);    
else
    system(['.' filesep 'dspLinearPredictiveCoderFcn']);
end
% Pause before cleaning up generated files to ensure resources were
% released.
pause(1);

%% Clean up Generated Files
cd(curdir);
rmdir(compilerDir,'s');


displayEndOfDemoMessage(mfilename)
