function s = reorderdesignoptsstruct(~,s,varargin)
%REORDERDESIGNOPTSSTRUCT

%   Copyright 2011 The MathWorks, Inc.

% Reorder structure so that MinPhase and MaxPhase appear together and
% before the Weights and other design options.
  
s = reorderstructure(s, 'FilterStructure', 'DensityFactor', 'MinPhase',...
  'MaxPhase');
  
% [EOF]