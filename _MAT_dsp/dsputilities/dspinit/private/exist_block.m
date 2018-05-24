function present = exist_block(sys, name)
%EXIST_BLOCK Determine whether a block exists
%  DSP System Toolbox local function to determine whether a block exists
%  within a given subsystem.
%  Usage:
%    if exist_block(getfullname(gcb), 'Buffer')
%       (configure the buffer block here)
%    end

% Copyright 2007-2010 The MathWorks, Inc.

present = ~isempty(find_system(sys,'searchdepth',1,...
                               'followlinks','on',...
                               'lookundermasks','on',...
                               'name',name));
