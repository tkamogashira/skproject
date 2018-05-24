function html = dspbhelp(fileStr)
% DSPBHELP DSP System Toolbox on-line help function.
%   Points Web browser to the HTML help file corresponding 
%   to this DSP System Toolbox block.  The current 
%   block is queried for its MaskType.
%
%   Typical usage:
%      set_param(gcb,'MaskHelp','web(dspbhelp);');

% Copyright 1995-2005 The MathWorks, Inc.

error(nargchk(0,1,nargin));
d = docroot;

if isempty(d),
   % Help system not present:
   html = ['file:///' matlabroot '/toolbox/dsp/dsp/dspbherr.html'];
else
   if nargin < 1
      % Derive help file name from mask type:
      html_file = getblock_help_file(gcb);
   else
      % Derive help file name from fileStr argument:
      html_file = getarg_help_file(fileStr);
   end
   
   % Construct full path to help file.
   % Use 3 forward slashes for portability of HTML file paths:
   html = ['file:///' d '/toolbox/dsp/' html_file];
end
return

% --------------------------------------------------------
function html_file = getarg_help_file(fileStr)
html_file = help_name(fileStr);
return

% --------------------------------------------------------
function help_file = getblock_help_file(blk)
% Get ALL DSP System Toolbox block libraries:
s = dspliblist;

% Get DSP System Toolbox block libraries with Reference Pages
libs_with_ref_page        = s.current;   % Current block libraries
libs_with_ref_page{end+1} = 'dspobslib'; % Deprecated blocks

refBlock = get_param(blk,'ReferenceBlock'); 

if ~isempty(refBlock) 
   % Use reference library block info
   sys = strtok(refBlock, '/');
else
   % Not a linked library block (the block link is disabled or broken).
   % Check if block has an ancestor (i.e. indicates it is a disabled link).
   % If so, use the ancestor block information for library block help page.
   ancBlock = get_param(blk,'AncestorBlock');
   
   if ~isempty(ancBlock) 
       % Use ancestor library block info
       sys = strtok(ancBlock, '/');
   else
       % Use present parent (sub)system directly
       sys = get_param(blk,'Parent'); 
   end
end 

if isempty(strmatch(sys,libs_with_ref_page,'exact'))
   % Not a version 4 block, no online help is available.
   fileStr = 'olddspblocksethelp';   
else
   % Only masked DSP System Toolbox blocks call 
   % dspbhelp, so if we get here, we know we can get the 
   % MaskType string.
   fileStr = get_param(blk,'MaskType');
end

help_file = help_name(fileStr);
return

% ---------------------------------------------------------
function y = help_name(x)
% Returns proper help-file name
%
% Invoke same naming convention as used with the
% auto-generated help conversions for the blockset
% on-line manuals.
%
% - only allow a-z, 0-9, and underscore
% - truncate to 25 chars max, plus ".html"
if isempty(x), x='default'; end
y = lower(x);
y(find(~isvalidchar(y))) = '';  % Remove invalid characters
y = [y '.html'];
return

% ---------------------------------------------------------
function y = isvalidchar(x)
y = isletter(x) | isdigit(x) | isunder(x);
return

% ---------------------------------------------------------
function y = isdigit(x)
y = (x>='0' & x<='9');
return

% ---------------------------------------------------------
function y = isunder(x)
y = (x=='_');
return

% [EOF] dspbhelp.m
