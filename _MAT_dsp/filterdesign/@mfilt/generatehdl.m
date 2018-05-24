%GENERATEHDL Generate HDL.
%   GENERATEHDL(Hb) automatically generates VHDL or Verilog code for 
%   the quantized filter, Hb. The default language is VHDL; to generate
%   Verilog, supply the property/value pair 'TargetLanguage','Verilog'. 
%   The default file name is the name of the filter variable, e.g. 
%   Hb.vhd for VHDL and Hb.v for Verilog.  The file is written to 
%   the HDL source directory which defaults to 'hdlsrc' under the 
%   current directory. This directory will be created if necessary.
%
%   GENERATEHDL(Hb, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...)
%   generates the HDL code with parameter/value pairs. Valid properties
%   and values for GENERATEHDL are listed in the Filter Design HDL 
%   Coder documentation section "Property Reference."
%
%   EXAMPLE:
%   Hm = mfilt.cicdecim(4);
%   generatehdl(Hm);
%   generatehdl(Hm,'TargetLanguage','Verilog');
%   generatehdl(Hm,'Name','myfiltername','TargetDirectory','mysrcdir');
%   generatehdl(Hm,'InputPort','adc_data','OutputPort','dac_data');
%   generatehdl(Hm,'AddInputRegister','on','AddOutputRegister','off');
%   generatehdl(Hm,'OptimizeForHDL','on','CoeffMultipliers','csd');
%
%   See also GENERATETB, GENERATETBSTIMULUS, FDHDLTOOL

%   Copyright 2007 The MathWorks, Inc.

% [EOF]
