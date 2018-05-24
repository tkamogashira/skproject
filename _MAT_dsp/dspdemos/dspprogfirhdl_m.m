%% Generate HDL Code for Programmable FIR Filter
% This example demonstrates how to generate HDL code for a programmable
% FIR filter. You can program the filter to a desired response by loading
% the coefficients into internal registers using the host interface.
%
% In this example, we will implement a bank of filters, each having
% different responses, on a chip. If all of the filters have a direct-form
% FIR structure, and the same length, then we can use a host interface to 
% load the coefficients for each response to a register file when needed.
%
% This design adds latency of a few cycles before the input samples
% can be processed with the loaded coefficients. However, it has the 
% advantage that the same filter hardware can be programmed with new
% coefficients to obtain a different filter response. This saves chip area, as
% otherwise each filter would be implemented separately on the chip.
%
%% Prerequisites
% You must have an HDL Coder(TM) license to run this example.

% Copyright 2011-2012 The MathWorks, Inc.

%% Model Programmable FIR Filter
% Enter the following commands to open the example model:
modelname = 'dspprogfirhdl';
open_system(modelname);
%%
% Consider two FIR filters, one with a lowpass response and the other with a 
% highpass response. The coefficients can be specified with the Model
% Properties InitFcn Callback function.
%%
% The _Programmable FIR via Registers_ block loads the lowpass coefficients from the _Host Behavioral Model_, 
% and processes the input chirp samples first. Then the block loads the highpass coefficients
% and processes the same chirp samples again.
%%
% Enter the following commands to open the _Programmable FIR via Registers_ block:
systemname = [modelname '/Programmable FIR via Registers'];
open_system(systemname);
%%
% The _coeffs_registers_ block loads the coefficients into internal 
% registers when the 'write_enable' signal is high.
% The following shadow registers are updated from the coefficients registers 
% when the 'write_done' signal is high. 
% This enables simultaneous loading and processing of data by the filter entity.
% In this example, we apply fully parallel architecture implementation
% to the _Discrete FIR Filter_ block. You can also choose serial
% architectures from the *HDL Block Properties* menu.
%
% Notice that the blocks load the second set of coefficients and process  
% the last few input samples simultaneously.

%% Simulink(R) Simulation Results
% Enter the following command to run the example model:
sim(modelname);
%% 
% Enter the following command to open the scope:
open_system([modelname '/Scope']);
%%
% Compare the dut output with the reference output.
%%
% Enter the following command to close the scope:
close_system([modelname '/Scope']);

%% Using the Logic Analyzer
% You can also view the signals in the Logic Analyzer. The Logic Analyzer
% enables you to view multiple signals in one window. It also makes it easy
% to spot the transitions in the signals.

% The signals of interest - input coefficient, write address, write enable,
% write done, filter in, filter out, reference out and error have been
% logged into a Dataset called dspprogfirhdl_logsout.

% The helper function analyzeLogicFromSimlink creates a wave for every
% input provided in the Dataset. In order to make the default order of
% signals displayed more meaningful, we reorder the Dataset from Simulink
% to make the Coefficient signals appear first and the data signals next.
% The Error values are coverted to logical values.
logsout_r = dspprogfirhdlReorderDataset(dspprogfirhdl_logsout);

% The Dataset can now be used to display data in the Logic Analyzer.
% We use the helper function analyzeLogicFromSimulink, which
% creates a Logic Analyzer System object, adds in a wave for every input
% passed in, labels the wave based on the name of the logged signal and
% displays the data in the Dataset. The function returns a handle to
% the System object that can be used to modify the display.
H = analyzeLogicFromSimulink(logsout_r);

%% Modifying the display in the Logic Analyzer
% The Logic Analyzer System object has several properties to control its
% display. You can modify the height of all the display channels, the
% spacing between the display channels and the time span of the display.
H.DisplayChannelSpacing = 2;
H.DisplayChannelHeight  = 2;
H.TimeSpan = 12;

%%
% The Logic Analyzer display can also be controlled on a per-wave or
% per-divider basis. To modify an individual wave or divider, use the tag
% associated with it. You can obtain the tag associated with a wave or
% divider as the return value of addWave and addDivider, or you can get all
% the tags for the waves and dividers using the getDisplayChannelTags
% method.

% Get all the tags for the displayed waves
HDisplayTags = H.getDisplayChannelTags;

% View the write address (second wave in the display) in Decimal mode
modifyDisplayChannel(H, 'DisplayChannelTag', HDisplayTags{2}, ...
    'Radix', 'Signed decimal');

%%
% Another useful mode of visualization in the Logic Analyzer is the Analog
% format.

% View the Filter In, Filter Out and Ref Out signals in Analog format
modifyDisplayChannel(H, 'DisplayChannelTag', HDisplayTags{5}, ...
    'Format', 'Analog');
modifyDisplayChannel(H, 'DisplayChannelTag', HDisplayTags{6}, ...
    'Format', 'Analog');
modifyDisplayChannel(H, 'DisplayChannelTag', HDisplayTags{7}, ...
    'Format', 'Analog');
H.TimeSpan = 500;

%% 
% The Logic Analyzer allows you to add in dividers and waves and move them
% around in the display. By default, the wave or divider is added to the
% bottom of the display. If desired, the display channel can be passed in
% while adding in the wave or divider. The wave or divider can also be
% moved after it has been added to the display.

% Add dividers for the coefficient and data signals. The divider for the
% coefficient signals is set to be shown in Display Channel 1. The divider
% for the data signals is added to the bottom of the display.
addDivider(H, 'DisplayChannel', 1, 'Name', 'Coeff');
divTagData = addDivider(H, 'Name', 'Data');

% Increase the size of the window so that all the waves and dividers are
% visible.
pos = H.Position;
H.Position = [pos(1) pos(2) pos(3) pos(4)+100];

%%
% Using the tag for a given wave or divider, the moveDisplayChannel method
% can be used to move it to the Display Channel of your choice.

% Move the Data signal divider to Display Channel 6, right before the
% Filter In wave display
moveDisplayChannel(H, 'DisplayChannelTag', divTagData, 'DisplayChannel', 6);

%%
% The above operations on individual channels are also accessible through the GUI
% by right-clicking on the channel name.
%
% <<dspprogfirhdl_gui.png>>
%
%%
% For further information on the Logic Analyzer System object, refer to the
% <matlab:doc('dsp.LogicAnalyzer'); documentation>.

%% Generate HDL Code and Test Bench
% Get a unique temporary directory name for the generated files
workingdir = tempname;
%%
% Enter the following command to validate the parameter settings of the
% *Programmable FIR via Registers* block:
%% 
% To check whether there are any issues with the model for HDL code
% genration, you can run the foolowing command.
% checkhdl(systemname,'TargetDirectory',workingdir);
%%
% Enter the following command to generate HDL code:
makehdl(systemname,'TargetDirectory',workingdir);
%%
% Enter the following command to generate the test bench:
makehdltb(systemname,'TargetDirectory',workingdir);
%% ModelSim(TM) Simulation Results
% The following figure shows the ModelSim HDL simulator after running the
% generated .do file scripts for the test bench. Compare the ModelSim result
% with the Simulink result as plotted before.
%
% <<dspprogfirhdl_ms.png>>
%
% This ends the Generate HDL Code for Programmable FIR Filter example.
displayEndOfDemoMessage(mfilename)
