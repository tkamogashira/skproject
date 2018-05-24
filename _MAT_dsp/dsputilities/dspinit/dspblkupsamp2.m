function varargout = dspblkupsamp2(blkh,action,varargin)
% DSPBLKUPSAMP2 DSP System Toolbox Upsample block helper function.

% Copyright 1995-2011 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end

switch action
    case 'icon'
        % Determine string to display in icon
        % This represents the sample count parameter
        eval_fct = varargin{1};  % evaluated sample count (could be empty if problem occurred)
        lit_fct  = varargin{2};   % literal sample count string (exactly what user entered)
        
        if isempty(eval_fct),
            % Problem probably occurred
            fctstr = lit_fct;
        else
            % have an evaluated expression
            if ~isnumeric(eval_fct) || numel(eval_fct)~=1,
                fctstr = '?';
            else
                fctstr = num2str(eval_fct);
            end
        end
        x = [0 NaN 1 NaN .3 .3 NaN .3 .2 NaN .3 .4];
        y = [0 NaN 1 NaN .2 .8 NaN .8 .6 NaN .8 .6];
        varargout = {fctstr, x,y};
        
    case 'init'
        modeArg = varargin{1};
        switch modeArg
            case 2
                set_param(blkh,'RateOptions', 'Allow multirate processing');
                set_param(blkh,'mode', 'Unused parameter value');
            case 3
                set_param(blkh,'RateOptions', 'Enforce single-rate processing');
                set_param(blkh,'mode', 'Unused parameter value');
        end
        dspSetFrameUpgradeParameter(blkh, 'InputProcessing', ...
            'Inherited (this choice will be removed - see release notes)');
        
    case 'dynamic'
        [RateOptionsArg, ICArg] = deal(4,5);
        blk = gcbh;
        maskVisOld = get_param(blk, 'MaskVisibilities');
        maskVisNew = maskVisOld;
        maskEnOld  = get_param(blk, 'MaskEnables');
        maskEnNew  = maskEnOld;
        
        [maskEnNew{RateOptionsArg}, maskVisNew{RateOptionsArg}] = deal('on');
            [maskEnNew{ICArg}, maskVisNew{ICArg}] = deal('on');
        
        if strcmpi(get_param(blk,'InputProcessing'), 'Elements as channels (sample based)')
            [maskEnNew{RateOptionsArg}, maskVisNew{RateOptionsArg}] = deal('off','on');
            set_param(blk,'RateOptions','Allow multirate processing');
        else
            % FB processing or Inherit
            if (strcmpi(get_param(blk,'InputProcessing'), 'Columns as channels (frame based)') && ...
                strcmpi(get_param(blk,'RateOptions'), 'Enforce single-rate processing'))
                [maskEnNew{ICArg}, maskVisNew{ICArg}] = deal('off');
            end
        end
        if ( ~isequal(maskVisNew, maskVisOld) || ~isequal(maskEnNew, maskEnOld) )
            set_param(blk, 'MaskVisibilities', maskVisNew, 'MaskEnables', maskEnNew);
        end
end
