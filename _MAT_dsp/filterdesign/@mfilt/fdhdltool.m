%FDHDLTOOL Launches the GUI to generate HDL
%   FDHDLTOOL(Hb) launches the Generate HDL dialog that lets you
%   customize and generate Verilog or VHDL code and test benches for a copy
%   of the quantized filter, Hb. You have to call FDHDLTOOL again if
%   you make changes in the filter, Hb at the command line. 
%
%   The main dialog and two subordinate dialogs provide access to many
%   options for customizing the generated filter and test bench code.
%
%   The Generate HDL main dialog categorizes options in two frames:
% 
%   * HDL Filter - Options you are most likely to customize at least once:
%   language selection, name and location of generated files, reset
%   specifications, and optimizations. 
% 
%   * Test bench types - Options for naming and specifying the type of test
%   bench files to generate, and specific types of stimuli the test benches
%   are to apply.
%
%   Example:
%       Hm = mfilt.cicdecim(4);
%       fdhdltool(Hm);
%
%   See also GENERATEHDL, GENERATETB, GENERATETBSTIMULUS.

% [EOF]
