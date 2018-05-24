%% Converting a Parametric Audio Equalizer to Fixed Point
% This example shows how to convert a floating-point system to fixed point
% using the Fixed-Point Advisor from Fixed-Point Designer(TM).
%
% Required MathWorks(TM) products:
%
% * MATLAB(R)
% * Signal Processing Toolbox(TM)
% * DSP System Toolbox(TM)
% * Simulink(R)
% * MATLAB(R) Coder(TM)
% * Simulink(R) Coder(TM)
% * Embedded Coder(TM)
% * Fixed-Point Designer(TM)

% Copyright 2009-2012 The MathWorks, Inc.

%% Introduction
% This tutorial is designed to show you some of the capabilities of the
% Fixed-Point Tool and the Fixed-Point Advisor and to provide you with an
% understanding of the steps that are necessary to convert a floating-point
% system to fixed point. The Fixed-Point Advisor automates most of the
% tasks that are necessary to convert a floating-point model to fixed
% point. By working together with the Fixed-Point Tool, the Advisor is able
% to suggest appropriate fixed-point settings for your system.
%
% This example uses the same floating-point model that is discussed in the
% <dspparameq.html dspparameq> example. The discussion and work flow
% described in that example also apply here.
%
% In this example, you use the Fixed-Point Tool and the Fixed-Point Advisor to
% convert the Equalizer subsystem of the |dspparameqflt2fix| model from
% floating point to fixed point. After using these tools to do this
% conversion, you will be able to generate and examine the fixed-point
% C-code produced by the Equalizer subsystem.
%
open_system('dspparameqflt2fix.mdl');
%% Examining the Equalizer Subsystem
% The Equalizer subsystem consists of three second-order biquadratic
% filters whose coefficients can be adjusted to achieve a desired frequency
% response. 
open_system('dspparameqflt2fix/Equalizer');
%%
% The following graphical user interface (GUI) can be used in simulation to
% dynamically adjust the filter coefficients.
% 
%%
% <<dspparameq_gui.png>>
%%
%
% The filters are implemented using multiple DSP System Toolbox(TM) Biquad
% Filter blocks. By default, the fixed-point parameters on these blocks
% inherit their word and fraction lengths from the block input. You can see
% these settings on the block dialog, or in the Fixed-Point Advisor. To
% allow the Advisor to adjust the word and fraction lengths of the
% fixed-point parameters, you must set them to 'Binary point scaling'. When
% you do so, the block sets the word and fraction lengths to initial values
% which you can modify at any time. The Advisor can then recommend new
% fraction length settings that improve precision and prevent overflow,
% based on the minimum and maximum values logged during simulation.
%
% This example provides a script that changes the fixed-point parameters of
% the three Biquad blocks to 'Binary point scaling'. The script also sets
% the accumulator word length of these blocks to 40 bits, a length that is
% used in some DSP hardware processors.
%
% Open the model and run the script by clicking on the following hyperlink:
% <matlab:open_system('dspparameqflt2fix.mdl');dspparameqflt2fixPrep;
%  Prepare Biquad fixed-point parameters>. To view the script, click
% <matlab:edit('dspparameqflt2fixPrep.m'); Examine the script>.
%
% If you do not have a script to change the fixed-point
% parameter settings in a model, you must do so manually. To do so, open
% the block dialog, click the ''Data types'' tab and select the appropriate
% fixed-point parameter setting. Alternatively, you can write your own
% script and use the <matlab:doc('set_param'); set_param> function to
% change the fixed-point parameter settings.)

%% Getting Started
% From the model menu, select Analysis>Fixed-Point Tool. The Fixed-Point Tool
% opens. In the Model Hierachy pane, select the Equalizer subsystem.
%%
% <<dspparameqflt2fix_select_equalizer.png>>
%%
%
% Set the 'Fixed-point instrumentation mode' parameter to 'Minimums,
% maximums and overflows'. This allows the Fixed-Point Tool to collect the
% data needed to recommend fixed-point scaling. Apply the change. Next,
% open the Fixed-Point Advisor by clicking the button in the 'Fixed-point
% preparation for selected system' group box.
%
% The Fixed-Point Advisor opens. In the pane on the left, there is a series
% of tasks beginning with 'Prepare Model for Conversion'. In the pane on
% the right, the Advisor gives an explanation of the tasks it will perform 
% and provides a legend of the icons it uses.
%%
% <<dspparameqflt2fix_advisor.png>>
%%
%
% To begin the conversion, click the first task 'Prepare Model for
% Conversion' in the pane on the left. Next, click the 'Run to Failure'
% button on the pane on the right. As you go through the steps, each
% successfully completed task displays a green check mark. Tasks that
% succeed, but have recommended changes, show a yellow warning icon. Tasks
% that fail show a red 'X'. After each successfully executed task,
% right-click on the next task and select 'Continue' or 'Run to Failure'.

%% Using the Fixed-Point Advisor to Convert the Equalizer Subsystem to Fixed Point 
% Perform the following steps to convert the Equalizer subsystem to fixed
% point.
%
% *1. Prepare Model for Conversion.* This task validates model-wide
% settings and creates simulation data. It consists of a number of sub
% tasks.
%
% *1.1 Verify model simulation settings.* This task as well as tasks 1.2
% and 1.3 pass. However, there is a warning at task 1.4.
%
% *1.4 Set up signal logging.* To remove the warning, right-click on the
% output signal line of the Equalizer subsystem and select 'Properties'.
% When the Properties dialog opens, select the 'Log signal data' check box.
% After doing so, rerun task 1.4.
% 
% *1.5 Create simulation reference data.* Run this task next. It will fail.
% The task fails because the model stop time is set to INF. Click the link
% 'Specify a finite Stop time'. The Solver pane of the Configuration
% parameter dialog opens. Change the 'Stop time' to a finite time such as
% 1, click OK and then rerun the task. The model runs to collect reference
% data.
%
% *1.6 Verify Fixed-Point Conversion Guidelines.* Run this task to failure.
% All sub tasks pass. However, there are some warnings that must be
% examined. The Advisor recommends that you change some of the Data
% Validity Parameter settings to 'warning'. To do so, follow the links
% provided and set the appropriate parameters to 'warning'. For the
% purposes of this example, you can skip these changes. It is not possible to
% check bus usage since this check only works from the top-level
% model. You can ignore this warning as well.
%
% *2. Prepare for Data Typing and Scaling.* This task is used to avoid
% data type propagation failures by properly configuring blocks with data
% type inheritance or other constraints. Select this task and click 'Run to
% Failure'. Task 2.1 passes but task 2.2 fails.
%
% *2.2 Remove output data type inheritance.* This task fails because there
% are floating-point inheritance blocks in the system. You must specify
% valid values. In general, enter the best data type information possible.
% For this example, select int16 and rerun the task. The task fails again. The
% Advisor recommends data types for blocks with floating-point inheritance.
% These data types will be changed by the Advisor in a later task. Click
% 'Modify All' and rerun the task. Continue with the remaining sub tasks.
% Task 2.6 fails.
%
% *2.6 Verify hardware selection* For input parameters, change the current
% default data type to the recommended type. Rerun the task.
%
% *2.7 Specify block minimum and maximum values.* For meaningful scaling,
% at a minimum, you should specify the minimum and maximum values for the
% input to the Equalizer subsystem. Open the Equalizer subsystem Inport
% block dialog. On the "Signal Attributes" tab, for ''Minimum'' enter -5.
% For ''Maximum'' enter 5. These limits are based on the expected signal
% range of the Gaussian random signal source. 99.99994 percent of the input
% samples will be in this range. Click on the Inport block dialog box and
% run task 2.7 in the Advisor.
%
% *3. Return to Fixed-Point Tool to Perform Data Typing and Scaling* When
% you run this task, the Fixed-Point Advisor will close and the Fixed-Point
% Tool will reopen.
%
% *Propose fraction lengths* In the 'Automatic data typing for Selected
% System' group box on the right, click 'Propose fraction lengths' button.
%
% *Accept or modify proposed fraction lengths* Select Column View
% 'Simulation View'. The proposed fraction length changes are shown in
% table column 'ProposeDT'. The fields are editable so you can modify any
% proposed value. The boxes to the left of each proposed data type will be
% checked. Uncheck any to refuse the proposed change. When you are done,
% click the 'Apply accepted fraction lengths' button in the 'Automatic data
% typing for selected system' group box.
%
%%
% <<dspparameqflt2fix_accept.png>>
%%
% The Equalizer subsystem is now fixed point, but the Excitation subsystem
% is still floating point. You must put a Data Type Conversion block
% between the Excitation subsystem and the Equalizer subsystem. This block
% serves as an analog to digital converter in the model. Right-click on the
% Equalizer subsystem and select 'Insert Data Type Conversion block'>'All
% Inports'.
%
% The Equalizer subsystem has now been converted to fixed point. Set the
% 'Stop time' to 'inf' and run the model. You should see a fixed-point
% frequency response that is visually identical to the floating-point
% frequency response. The two responses are shown here for comparison.
%
%%
% <<dspparameqflt2fix_compare.png>>
%% Generating C-Code for the Equalizer Subsystem
%
% To generate C-code, click the 'Generate Code for Equalizer Subsystem'
% block. You can also generate code by clicking the following hyperlink:
% <matlab:open_system('dspparameqflt2fix.mdl');rtwbuild('dspparameqflt2fix/Equalizer')
%  Generate Code for the Equalizer Subsystem>.
% The model is configured to generate an HTML report that can be used to
% navigate the generated source code and header files.
%
% Depending on your hardware platform, the generated code may need
% additional code steps to handle the 40 bit Biquad accumulator word size 
% that was selected for this example. To examine the generated C-code for a 
% processor with a 40 bit word length, you can do the following: 
%
% 1) Open the Hardware Implementation pane of the Configuration Parameters
% dialog.
%
% 2) For *Device vendor*, select |Texas Instruments|. For *Device Type*,
% select |C6000| This processor has a 40 bit long data type.
%
% 3) Generate code and compare the difference.
%
% A more detailed discussion of other code generation options can be found
% in the floating-point version of this example, <dspparameq.html dspparameq>.
%
close_system('dspparameqflt2fix/Equalizer');
close_system('dspparameqflt2fix.mdl');
%% Additional Information
%
% For more information on using the Fixed-Point Advisor from 
% Fixed-Point Designer, see
% <matlab:helpview(fullfile(docroot,'/toolbox/fixpoint/fixpoint.map'),'com.mathworks.FPCA.FixedPointConversionTask') Fixed-Point Advisor>.
%
% For more information on working with fixed-point data in the DSP System
% Toolbox, see
% <matlab:helpview(fullfile(docroot,'/toolbox/dsp/dsp.map'),'working_with_fixed_point_data') Fixed-Point Signal Processing Development>.
%
