function varargout = dspblkedetect2(action, varargin)
% DSPBLKEDETECT2 DSP System Toolbox Edge Detection block helper function.

% Copyright 1995-2011 The MathWorks, Inc.

  switch action
	case 'icon'

        x = [.1 .2 .2 .5 .5 .7 .7 .8 .8 .9 NaN ...
             .1 .9 NaN .2 .2 NaN .7 .7];

        y = [.6 .6 .9 .9 .6 .6 .9 .9 .6 .6 NaN ...
             .1 .1 NaN .1 .5 NaN .1 .5];

        varargout = {x,y};

      case 'init'
          blkh = varargin{1};  % handle
          blk  = varargin{2};  % name
          dspSetFrameUpgradeParameter(blkh,'InputProcessing', ...
            'Inherited (this choice will be removed - see release notes)'); 
          
          %set the input processing mode of the subsystem Delay block to be
          %the same as the subsystem block input processing mode.
          inputProc = get_param(blkh, 'InputProcessing');
          set_param([blk '/Delay'], 'InputProcessing', inputProc);
                    
  end

