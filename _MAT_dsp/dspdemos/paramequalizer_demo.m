%% 3-Band Parametric Audio Equalizer Using UDP Packets and Code Generation
% This example shows how to design a 3-band parametric audio equalizer and
% use UDP packets to send the filter coefficients to standalone generated
% code via UDP packets. The example allows you to dynamically adjust the
% coefficients of the filters using a graphical user interface (GUI). The
% example also shows you how to use the MATLAB Coder product to generate
% code for the algorithm and create a standalone executable file that you
% can run outside of MATLAB.
%
% Required MathWorks(TM) products:
%
% * DSP System Toolbox(TM)
% * MATLAB Coder(TM)
%
%   Copyright 1995-2013 The MathWorks, Inc.
 
%% Introduction
% Parametric equalizers are often used to adjust the frequency response of 
% an audio system. For example, a parametric equalizer can be used to
% compensate for physical speakers which have peaks and dips at different
% frequencies. 
%
% The parametric equalizer algorithm in this example provides three
% second-order (biquadratic) filters whose coefficients can be adjusted to
% achieve a desired frequency response. You can adjust the filter
% coefficients and explore the results by using the included graphical user
% interface (GUI). When you modify the filter specifications in the GUI,
% the updates get sent back to the algorithm via UDP packets. When you use
% MATLAB Coder to generate code, the algorithm is automatically translated
% into C-code which is then compiled to create a standalone executable
% (EXE) file. You can run this EXE file on a PC without MATLAB or any
% library dependencies. The same GUI can be used to adjust the filter
% coefficients while the generated EXE is being executed on the host PC.
%
%% Example Architecture
% This example consists primarily of 2 MATLAB functions:
%
% # paramequalizer.m        - parametric equalizer algorithm code
% # paramequalizer_GUI.m    - graphical user interface code 
% 
% You can run the algorithm code independently in MATLAB or through the GUI
% itself. The primary purpose of the GUI is to allow you to easily adjust
% the frequency specification of each band of the filter and pass the new
% set of specifications directly to the algorithm. The GUI uses UDP System
% objects to pass the filter specifications back to the algorithm.
%
% In addition to the parametric equalizer algorithm and GUI, this example
% also provides a short code generation script, paramequalizer_codegen.m,
% which allows you to generate C-code from the algorithm and build an
% executable file. Once you run this script, you can then run the
% executable file from the GUI by selecting the 'Run Executable' check box.
%
% Currently, the algorithm is configured to work with 44100 Hz audio data.
% You can change this sample rate by modifying the code in line 42 of the
% paramequalizer.m file.
 
%% 3-Band Parametric Equalizer Algorithm Code
% The algorithm code consists of two primary sections: a test bench and the
% filtering algorithm. 
%
% The testbench portion of the code takes care of the inputs and outputs, 
% setting up the System objects, and streaming the audio in a loop.
% 
% The filtering algorithm functions generate the filter coefficients
% and construct three dsp.BiquadFilter System objects to perform the 
% 3-band filtering of the audio frames. 
%
% The parametric equalizer algorithm uses UDP System objects to read the
% filter band specifications that are sent by the GUI. The UDP System
% objects are supported for code generation, so the standalone executable
% file you create by generating and building the C-code also communicates
% with the GUI via UDP packets.
% 
%
% Open the algorithm in the MATLAB editor: 
% <matlab:edit('paramequalizer.m') paramequalizer.m>
 
%% Graphical User Interface Code
% This example provides a custom GUI, programmed in MATLAB, that allows you
% to dynamically adjust the filter coefficients. The GUI allows you to set
% the specification of each filter band, namely the center frequency,
% attenuation/gain, and bandwidth. Each time you click and drag one of the
% graphical objects (lines or markers), the GUI re-captures the
% specifications of each filter band. The GUI then uses a dsp.UDPSender
% System object to package the new specification and broadcast it as a UDP
% packet which can be read by the dsp.UDPReceiver System object in the
% algorithm code. This process occurs whether you are executing the
% algorithm in MATLAB or outside of MATLAB via the standalone executable
% file.
%
% To get started, <matlab:paramequalizer_GUI Open The GUI>.
%
% <<paramequalizer_GUI.png>>
%% Generate Code and Build an Executable File
% You can use MATLAB Coder to generate readable and standalone C-code from
% the paramequalizer.m algorithm code. Because the algorithm code uses
% System objects for reading and playing audio files, there are additional
% dependencies for the generated code and executable file. These are
% available in the /bin directory of your MATLAB installation.
%
% You can use the following script to invoke MATLAB Coder to automatically
% generate C-code and a standalone executable from the algorithm code.
% <matlab:edit('paramequalizer_codegen.m') paramequalizer_codegen.m>
%
% When generating code, some System objects have constraints on the 
% type and variability of the input arguments. In this case, the 
% dsp.AudioFileReader System object requires that you specify the name of  
% the audio file as a constant before you can generate code. 
%
% The first two lines of the code generation script ask you to browse for
% and specify the input audio file. The file name you specify is then used
% throughout the generated code. To run the executable with a different
% audio file, you must re-run the code generation script and specify the
% name of the new audio file.
%
% <matlab:paramequalizer_codegen Run the script> to generate code.
%%
% After you generate the executable file, you can launch it from the GUI by
% selecting the 'Run Executable' checkbox before pressing the Play button.
% If you choose to run the executable file from the GUI, you should see
% performance improvements compared to when you use the GUI with the
% algorithm code running in MATLAB. Because MATLAB is single-threaded, both
% the GUI and the audio stream processing must run in the same thread. This
% can reduce performance because your interactions with the GUI can preempt
% the processing of the audio. However, by configuring the GUI to run the
% executable file outside of MATLAB, you eliminate the competition for
% resources and you can interact with the GUI without interrupting the
% audio processing.

 
 
%% Appendix
% For more detailed information on how to configure MATLAB Coder for
% different types of code generation, see the documentation:
% <matlab:helpview(fullfile(docroot,'coder','ug','coder_ug.map'),'msginfo_Coder_builtins_Empty'); 
% Product Overview> 

displayEndOfDemoMessage(mfilename)
