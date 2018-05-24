%BLOCK Generate a DSP System Toolbox block.
%   BLOCK(Hm) generates a DSP System Toolbox block equivalent to Hm.
%
%   BLOCK(Hm, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...) generates a
%   DSP System Toolbox block using the options specified in the
%   parameter/value pairs. The available parameters are:
%
%     -------------       ---------------      ----------------------------
%     Property Name       Property Values      Description
%     -------------       ---------------      ----------------------------
%     Destination         [{'current'}         Specify whether to add the block
%                          'new'               to your current Simulink model,
%                          <user defined>]     create a new model to contain the
%                                              block, or specify the name of the
%                                              target subsystem. 
%
%     Blockname           {'filter'}           Provides the name for the new 
%                                              subsystem block. By default the 
%                                              block is named 'filter'.
%
%     OverwriteBlock      ['on' {'off'}]       Specify whether to overwrite an
%                                              existing block with the same name
%                                              as specified by the Blockname 
%                                              property or create a new block.
%
%     Link2Obj            ['on' {'off'}]       Specify whether to set the
%                                              filter variable in the block
%                                              mask rather than setting the
%                                              coefficient values.
%
%     InputProcessing   [{'columnsaschannels'} Specify sample-based 
%                        'elementsaschannels'  ('elementsaschannels') vs. 
%                        'inherited']          frame-based ('columnsaschannels') 
%                                              processing.
%
%     RateOption        [{'enforcesinglerate'} Specify how the block adjusts
%                       'allowmultirate']      the rate at the output to accomodate
%                                              the reduced number of samples.
%                                              Apply only to multirate blocks 
%                                              when InputProcessing is set to 
%                                              'columnsaschannels'.
%
%    EXAMPLES:
%    L = 3; % interpolation factor
%    Hm = mfilt.firinterp(L);
% 
%    %#1 Default syntax:
%    block(Hm);
% 
%    %#2 Using parameter/value pairs:
%    block(Hm, 'Blockname', 'FirInterp');

% Copyright 1999-2010 The MathWorks, Inc.

% Help for the filter's BLOCK method.

% [EOF]
