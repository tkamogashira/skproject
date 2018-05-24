function obj = dspDDGCreate(block, classInfo)
%dspDDGCreate create a object for use with the Dynamic Dialog engine
%
%  obj = dspDDGCreate(block, classInfo) 
%    block     : handle to Simulink block (e.g., gcbh)
%    classInfo : cell array with two elements:
%       classInfo{1} = class name
%       classInfo{2} = class package
%
%    The class package is optional; if it is not specified, then
%    dspfixptddg is used.
%
%  Example:
%
%    obj = dspDDGCreate(gcbh,{'VectorScope','dspdialog'});
%
%   NOTE: This is a DSP System Toolbox dialog utility function.  It is
%   not intended to be used as a general-purpose function.

% Really, this function is intended to be used with the 'dialogcontroller' and
% 'dialogcontrollerargs' block parameters. For example:
%
%    set_param(gcb,'dialogcontroller','dspDDGCreate');
%    set_param(gcb,'dialogcontrollerargs','MatrixScaling');
%
% or
%
%    set_param(gcb,'dialogcontroller','dspDDGCreate');
%    set_param(gcb,'dialogcontrollerargs','VectorScope','dspdialog');

% Copyright 2003-2005 The MathWorks, Inc.

if length(classInfo) < 2
    classInfo{2} = 'dspfixptddg';
end

fcnHandle = eval(['@' classInfo{2} '.' classInfo{1}]);
obj = fcnHandle(block);
