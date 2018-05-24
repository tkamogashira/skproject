function dspblklevdurb2()
% DSPBLKLEVDURB DSP System Toolbox Levinson-Durbin block helper function.

% Copyright 1995-2009 The MathWorks, Inc.

blk = gcbh;   % Cache handle to block

if ~strcmp(get_param(blk,'tag'),'dspblks_tmp_paramsplit_forward_compat')      
  if ~strcmp(get_param(blk,'coeffOutFcn'),'OBSOLETE')
      % this block lives in older version of SP BlockSet
      set_param(blk,'coeffOutFcnActive',get_param(blk,'coeffOutFcn'),...
                    'secondCoeffMode',get_param(blk,'firstCoeffMode'),...
                    'secondCoeffWordLength',get_param(blk,'firstCoeffWordLength'));
      set_param(blk,'coeffOutFcn','OBSOLETE');
  end
end

% [EOF] dspblklevdurb2.m
