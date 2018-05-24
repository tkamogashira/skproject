function varargout = dspblkdsamp2(action,varargin)
% DSPBLKDSAMP2 DSP System Toolbox Downsample block helper function.

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
        x = [0 NaN 1 NaN .3 .3 NaN .2 .3 NaN .3 .4];
        y = [0 NaN 1 NaN .2 .8 NaN .4 .2 NaN .2 .4];
        varargout = {fctstr, x,y};
        
    case 'init'
        blkh = varargin{1};
        dspSetFrameUpgradeParameter(blkh, 'InputProcessing', ...
            'Inherited (this choice will be removed - see release notes)');
        
    case 'dynamic'
        blk = gcbh;
        maskVisOld = get_param(blk, 'MaskVisibilities');
        maskVisNew = maskVisOld;
        maskEnOld  = get_param(blk, 'MaskEnables');
        maskEnNew  = maskEnOld;
        if strcmpi(get_param(blk,'InputProcessing'), ...
            'Inherited (this choice will be removed - see release notes)')
            [maskEnNew{4}, maskVisNew{4}] = deal('off');
            [maskEnNew{5}, maskVisNew{5}] = deal('on');
            [maskEnNew{6}, maskVisNew{6}] = deal('on');
            [maskEnNew{7}, maskVisNew{7}] = deal('on');
        else
            [maskEnNew{4}, maskVisNew{4}] = deal('on');
            [maskEnNew{5}, maskVisNew{5}] = deal('off');
            [maskEnNew{6}, maskVisNew{6}] = deal('off');
            if strcmpi(get_param(blk,'RateOptions'), 'Allow multirate processing')
                [maskEnNew{7}, maskVisNew{7}] = deal('on');
            else
                [maskEnNew{7}, maskVisNew{7}] = deal('off');
            end
        end
        if ( ~isequal(maskVisNew, maskVisOld) || ~isequal(maskEnNew, maskEnOld) )
            set_param(blk, 'MaskVisibilities', maskVisNew, 'MaskEnables', maskEnNew);
        end
end
