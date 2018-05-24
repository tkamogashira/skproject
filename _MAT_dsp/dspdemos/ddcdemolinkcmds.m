function tclcmd = ddclinkdemocmds
% DDCLINKDEMOCMDS - Creates Tcl cmds for Filter Testing Demo Model
%   The returned cell array can be passed as parameters ('cmd') to
%   VSIMULINK.  This will lauching ModelSim and build the demo.  ]
%   Also, the model will be loaded for cosimulation with 
%   DDCLINKDEMOMODEL.MDL
%
% See also VSIMULINK

%   Copyright 2004 The MathWorks, Inc.

tmpdir = fullfile(pwd, 'hdlsrc');

% TCL for ModelSim
unixprojdir  = strrep(tmpdir,'\','/'); % ModelSim prefers Unix style pathnames
unixprojdir  = strrep(unixprojdir, ' ', '\ '); % backslash spaces
tclcmd = { ['cd ',unixprojdir],...            
           'vlib work',... %create library (if necessary)
           'vcom filter_stage1.vhd',...
           'vcom filter_stage2.vhd',...
           'vcom filter_stage3.vhd',...
           'vcom filter.vhd',...
           'vsimulink work.filter',...
           'add wave -height 200 -radix decimal -format analog-step -scale 0.002 -offset 32000 sim:/filter/filter_in',...
           'add wave -height 200 -radix decimal -format analog-step -scale 0.064 -offset 1000 sim:/filter/filter_out',...
         };


