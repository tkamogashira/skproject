function varargout = dspblktrigtwks(action, varargin)
% DSPBLKTRIGTWKS DSP System Toolbox Triggered To Workspace
%   block helper function.

% Copyright 1995-2011 The MathWorks, Inc.
%  

obj = get_param(gcbh,'object');

if nargin==0, action='dynamic'; end

switch action

case 'init'
  
   % Update trigger:
   switch varargin{1}
   case 1, edge='rising';
   case 2, edge='falling';
   case 3, edge='either';
   end
   trigObj = get_param([gcb '/Trigger'],'object');
   trigObj.TriggerType = edge;
   
   % Update Signal To Workspace block:
   stwObj = get_param([gcb '/Signal To Workspace'],'object');
   stwObj.VariableName = obj.VariableName;
   stwObj.Save2DMode   = obj.Save2DMode;
   stwObj.FixptAsFi    = obj.FixptAsFi;
   
   dspSetFrameUpgradeParameter(gcbh, 'Save2DMode', ...
            'Inherit from input (this choice will be removed - see release notes)');
end

% [EOF] dspblktrigtwks.m
