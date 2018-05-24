%% Generate HDL Code for Multichannel FIR Filter
% This example demonstrates how to generate HDL code for a discrete
% FIR filter with multiple input data streams.
%
% In many DSP applications, multiple data streams are filtered by the same
% filter. The straightforward solution is to implement a separate filter for
% each channel. If possible, a more area-efficient
% structure can be applied by sharing one filter implementation among
% multiple channels. The resulting hardware requires a faster
% clock with respect to the sample rate for a single channel filter.
%% Prerequisites
% You require an HDL Coder(TM) license to run this example.

% Copyright 2012 The MathWorks, Inc.

%% Model Multichannel FIR Filter
% Enter the following commands to open the example model:
modelname = 'dspmultichannelhdl';
open_system(modelname);
%%
% Consider a two-channel FIR filter. The input data vector includes two
% streams of sinusoidal signal with different frequencies. The input data
% streams are processed by a lowpass filter, whose coefficients are
% specified by the Model Properties InitFcn Callback function.
%%
% Enter the following commands to specify the fully parallel architecture
% implementation to the _Discrete FIR Filter_ block:
systemname = [modelname '/Multichannel FIR Filter'];
blockname = [systemname '/Discrete FIR Filter'];
set_param(blockname,'FilterStructure','Direct form symmetric');
hdlset_param(blockname, 'Architecture', 'Fully Parallel');
%%
% Enter the following commands to allow for resource sharing among multiple
% channels:
hdlset_param(blockname, 'ChannelSharing', 'On');
%%
% You can also specify these settings on the HDL Block Properties menu.
%% Simulation Results
% Enter the following command to run the example model:
sim(modelname);
%% 
% Enter the following command to open the scope:
open_system([modelname '/Scope']);
%%
% Compare the two output data streams.
%%
% Enter the following command to close the scope:
close_system([modelname '/Scope']);
%% Generate HDL Code and Test Bench
% Get a unique temporary directory name for the generated files:
workingdir = tempname;
%%
% You can enter the following command to validate the parameter settings of the
% _Multichannel FIR Filter_ block:
%% 
% checkhdl(systemname,'TargetDirectory',workingdir);
%%
% Enter the following command to generate HDL code:
makehdl(systemname,'TargetDirectory',workingdir);
%%
% Enter the following command to generate the test bench:
makehdltb(systemname,'TargetDirectory',workingdir);
%% Compare Resource Utilization
% You can enter the following command to show resource report with channel
% sharing:
%% 
% makehdl(systemname,'TargetDirectory',workingdir, 'resource', 'on');
%%
% You can enter the following command to show resource report without
% channel sharing:
%%
% hdlset_param(blockname, 'ChannelSharing', 'Off');
% makehdl(systemname,'TargetDirectory',workingdir, 'resource', 'on');
%%
% You can see the different resource utilization by comparing the two
% reports:
%
% <<dspmultichannelhdl_rp.png>>
%
% This ends the Generate HDL Code for Multichannel FIR Filter example.
displayEndOfDemoMessage(mfilename)
