%% Parametric Audio Equalizer
% This example shows how to model an algorithm specification for a three 
% band parametric equalizer which will be used for both simulation and code
% generation. 
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

% Copyright 2008-2012 The MathWorks, Inc.

%% Introduction
% Parametric equalizers are often used to adjust the frequency response of 
% an audio system. For example, a parametric equalizer 
% can be used to compensate for physical speakers which have peaks and dips 
% at different frequencies. 
%
% The parametric equalizer algorithm in this example provides three second-order 
% (biquadratic) filters whose coefficients can be adjusted to achieve a 
% desired frequency response. A graphical user interface is used in simulation 
% to dynamically adjust filter coefficients and explore behavior. 
% For code generation, the coefficient variables are named and placed 
% in files such that they could be accessed by other software components 
% that dynamically change the coefficients while running on the 
% target processor.
%
% The following sections will describe how the parametric equalizer 
% algorithm is specified, how the behavior can be explored through 
% simulation, and how the code can be generated and customized.
open_system('dspparameq.mdl');
%% Specify Algorithm
%
% The parametric equalizer algorithm is specified in two parts: a model
% specification and a parameterized data specification. The model specification is a 
% Simulink subsystem that specifies the signal flow of the algorithm. 
% The model specification also accesses parameterized data that exists in 
% the MATLAB workspace. The parameterized data specification is a MATLAB script 
% that creates the data that is accessed by the Simulink model. 
%%
[algspecimage, algspecmap] = imread('dspparameq_algspec.jpg');
[rows,cols] = size(algspecimage);
algspecfigure = figure('Units','pixels','Position',[100 100 cols/3 rows]);
image(algspecimage);
set(gca,'Position',[0 0 1 1]);
axis off;
%%
%%
clear algspecimage;
close(algspecfigure);
%%
% For this example,  
% the model specification is the Equalizer subsystem of 
% the Simulink model 
% <matlab:open_system('dspparameq.mdl') dspparameq.mdl>.
% In this subsystem, the input is 
% passed through three cascaded bands of equalization. Coefficient changes 
% within each band are smoothed through a leaky integrator before being 
% passed into a Biquad Filter block. Each Biquad Filter block is configured to use a 
% different filter structure. Different filter structures are selected to 
% show the differences in code generation later in this example.
%
% For this example,  
% the parameterized data specification is the MATLAB script 
% <matlab:open('dspparameq_data.m') dspparameq_data.m>.
% This MATLAB script specifies the initial filter coefficients as well as code generation 
% attributes. When you open the model 
% <matlab:open_system('dspparameq.mdl') dspparameq.mdl>,
% the model?s |PreLoadFcn| callback is configured to run the 
% <matlab:open('dspparameq_data.m') dspparameq_data.m>
% script that creates the parameter data in the MATLAB workspace.
open_system('dspparameq/Equalizer');
%% Explore Behavior through Simulation
% You can use a simulation test bench to explore the behavior of the algorithm. 
% In this example, the test bench consists of the simulation model, 
% <matlab:open_system('dspparameq.mdl') dspparameq.mdl>,
% as a well as custom graphical user interface (GUI) programmed in MATLAB, 
% <matlab:open('dspparameq_gui.m') dspparameq_gui.m>.
%%
[exploreimage, exploremap] = imread('dspparameq_explore.jpg');
[rows,cols] = size(exploreimage);
explorefigure = figure('Units','pixels','Position',[100 100 cols/3 rows]);
image(exploreimage);
set(gca,'Position',[0 0 1 1]);
axis off;
%%
%%
clear exploreimage;
close(explorefigure);
%%
%
% This GUI is loaded in the |StartFcn| callback of the model. When you 
% run the model, the GUI is brought up and enables dynamic 
% adjustment of coefficient parameter data in the MATLAB workspace 
% during the simulation. 
%%
[img, ~] = imread('dspparameq_gui.png');
[rows, cols] = size(img);
fig = figure('Units','pixels','Position',[100 100 cols/3 rows]);
image(img);
set(gca,'Position',[0 0 1 1]);
axis off;
%%
clear img;
close(fig);
%% Generate C Code for the Equalizer Subsystem
% Once you achieve the desired simulation behavior, you can generate C code
% for the Equalizer subsystem based on the algorithm specification. This
% model is configured to show some common code generation
% customizations accessible from Embedded Coder product. These
% customizations ease the code review and integration process. The
% following sections show some of the code customizations for this
% model and provide references to documentation that describe these
% customizations in more detail.
%
% To generate C code, right-click on the Equalizer subsystem, select Code
% Generation > Build Subsystem, then click the Build button when prompted
% for tunable parameters. You can also generate code by clicking the
% following hyperlink:
% <matlab:open_system('dspparameq.mdl');rtwbuild('dspparameq/Equalizer')
%  Generate Code for the Equalizer Subsystem>.
%
% *Code Generation Report with Links to and from the Model*
%
% The model is configured to generate an HTML report that can be used to
% navigate the generated source and header files. The report also enables
% bidirectional linking between the generated code and the model. For
% example, each Biquad Filter block is configured to implement a different
% filter structure.  You can trace from the block to the associated code by
% right clicking on any of the Biquad Filter blocks and then selecting Code
% Generation > Navigate to code.
%%
[reportimage, reportmap] = imread('dspparameq_report.png');
[rows, cols] = size(reportimage);
reportfigure = figure('Units','pixels','Position',[100 100 cols/3 rows]);
image(reportimage);
set(gca,'Position',[0 0 1 1]);
axis off;
%%
%%
clear reportimage;
close(reportfigure);
%%
% For more information on traceability between the model and code see 
% <matlab:helpview(fullfile(docroot,'/toolbox/ecoder/helptargets.map'),'using_model_to_code_traceability') Creating and Using a Code Generation Report>.
%
% *Calling the Generated Code*
%
% You can integrate the generated code into an application by making 
% calls to the model initialization and model step functions. An example 
% |ert_main.c| file is generated that shows how to call the generated code. Note that 
% the example |main()| calls |Equalizer_initialize()| to initialize states. 
% The example |rt_OneStep()| shows how a periodic mechanism 
% such as an interrupt would call |Equalizer_step()| from the file |Equalizer.c|. 
%%
[modelstepimage, modelstepmap] = imread('dspparameq_modelstep.png');
[rows, cols] = size(modelstepimage);
modelstepfigure = figure('Units','pixels','Position',[100 100 cols/3 rows]);
image(modelstepimage);
set(gca,'Position',[0 0 1 1]);
axis off;
%%
%%
clear modelstepimage;
close(modelstepfigure);
%%
% For more information about how to integrate generated code into another 
% application see 
% <matlab:helpview(fullfile(docroot,'/toolbox/ecoder/helptargets.map'),'stand_alone_program_execution') Stand-Alone Program Execution>.
%
% *Input and Output Data Interface*
%
% The parameterized data specification file, 
% <matlab:open('dspparameq_data.m') dspparameq_data.m>,
% creates |in| and |out| signal data objects in the MATLAB workspace. 
% These data objects are associated with signal lines in the model and are 
% used to specify descriptions and storage classes of the corresponding 
% variables in the generated code. For example, the signals |in| and 
% |out| are declared as a global variable in |Equalizer.c|. 
% To run the model step function, an application writes data to |in|, 
% calls the |Equalizer_step()| function, and then reads the results from |out|.
%
% For more information on Data Objects see 
% <matlab:helpview(fullfile(docroot,'/toolbox/ecoder/helptargets.map'),'creating_simulink_mpt_data_objects') Creating Simulink and mpt Data Objects>.
%
% *Text Annotations in Code Comments*
%
% You can insert design documentation entered as text in the model 
% into the comments of the generated code. The |Equalizer| subsystem contains 
% annotation text with the keyword |S:Description|. The code generator 
% identifies that the text starts with this keyword and inserts the text 
% following the keyword as comments into the generated code. 
%
% For more information on inserting annotation text into code comments see 
% <matlab:helpview(fullfile(docroot,'/toolbox/ecoder/helptargets.map'),'adding_global_comments') Adding Global Comments>.
%
% *Function Partitioning*
% 
% To ease navigation of the generated code, each subsystem for the
% equalizer bands is configured to be atomic and create its own function. 
% You can see the calling order in the |Equalizer_step()| function.
%
% For more information on customizing function naming and placement see 
% <matlab:helpview(fullfile(docroot,'/toolbox/ecoder/helptargets.map'),'config_nonvirtual_subsys_for_modular_code_gen') Nonvirtual Subsystem Modular Function Code Generation>.
%
% *Coefficient File Placement*
%
% The parameterized data specification file, 
% <matlab:open('dspparameq_data.m') dspparameq_data.m> 
% creates parameter data objects for the coefficients in the MATLAB workspace. 
% These data objects are configured to define and declare coefficient variables in 
% separate files |biquad_coeffs.c| and |biquad_coeffs.h| respectively. 
% Partitioning coefficients into separate files enables other software 
% components to access this data. For example, in a deployed application, 
% you could schedule another software component to modify these variables 
% at runtime before they are used by |Equalizer_step()|.
%
% For more information about file placement of Data Objects see 
% <matlab:helpview(fullfile(docroot,'/toolbox/ecoder/helptargets.map'),'data_placement') Managing File Placement of Data Definitions and Declarations>.
%
% *Filter Design Parameters in Coefficient Variable Comments*
%
% When coefficients are calculated (in the parameterized data file
% or by the graphical user interface), the filter design parameters are 
% stored in the |Description| field of the coefficient parameter data objects. 
% The model is configured to insert the design parameters as comments in the 
% generated code. This enables reviewers of the code to easily identify 
% which design parameters were used to design the filters.  
%%
[commentsimage, commentsmap] = imread('dspparameq_coeffcomments.png');
[rows, cols] = size(commentsimage);
commentsfigure = figure('Units','pixels','Position',[100 100 cols/3 rows]);
image(commentsimage);
set(gca,'Position',[0 0 1 1]);
axis off;
%%
%%
clear commentsimage;
close(commentsfigure);
%%
% For more information on customizing the comments of Data Objects in the
% generated code see 
% <matlab:helpview(fullfile(docroot,'/toolbox/ecoder/helptargets.map'),'adding_custom_comments') Adding Custom Comments>.
%
% *Package Generated Files*
%
% The generated files referenced by the HTML report exist in the
% |Equalizer_ert_rtw| directory. In addition to the files in this directory, 
% other files in the MATLAB application install directory may be required 
% for integration into a project. To ease porting the generated code to other 
% environments, this model is configured to use the PackNGo feature, which 
% packages up all of the required files into the zip file |Equalizer.zip|. 
% Note that the zip file contains all of the required files, but might 
% also contain additional files that may not be required.
%
% For more information on packaging files for integration into other
% environments, see 
% <matlab:helpview(fullfile(docroot,'/toolbox/rtw/helptargets.map'),'pack_and_go_util') Relocating Code to Another Development Environment>.
%
close_system('dspparameq/Equalizer');
close_system('dspparameq.mdl');
% For a more detailed 
% tutorial on how to configure a model for code generation, see the 
% work flow example in Embedded Coder:
% <matlab:web(fullfile(matlabroot,'/toolbox/rtw/rtwdemos/html/rtwdemo_pcgd_intro.html'),'-helpbrowser') 
%  Embedded Coder Guided Introduction>.
%
%% Converting the Equalizer subsystem to Fixed Point Using the Fixed-Point Advisor
%
% To learn how to convert the Equalizer subsystem to fixed point using the
% Fixed-Point Advisor, see the <dspparameqflt2fix.html dspparameqflt2fix>
% example.


% LocalWords:  biquadratic algspec Biquad helptargets modelstep mpt
% LocalWords:  nonvirtual subsys biquad coeffcomments NGo workflow rtwdemo pcgd
% LocalWords:  dspparameqflt
