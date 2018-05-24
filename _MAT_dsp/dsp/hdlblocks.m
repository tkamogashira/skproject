function regstruct = hdlblocks
% HDLBLOCKS
%
% Copyright 2009 The MathWorks, Inc.

regstruct.package = { 'hdldspblks' };
regstruct.name    = { 'HDL Implementations for Dspblks' };
regstruct.version = { 'v1.0' };
regstruct.license = license('test','Simulink_HDL_Coder');
regstruct.controlfile = {'hdldspblks_control'};
                   
regstruct.library = {'dspsigops',...
                     'dspsrcs4',...
                     'dspindex',...
                    };
