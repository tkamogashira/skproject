function dspblkunwrap(blkh,action,varargin)
% DSPBLKUNWRAP Unwrap block helper function.

% Copyright 2010-2011 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end

switch action
        
    case 'init'
        dspSetFrameUpgradeParameter(blkh, 'InputProcessing', ...
            'Inherited (this choice will be removed - see release notes)');
        
    case 'dynamic'
        blk = gcbh;
        maskVisOld = get_param(blk, 'MaskVisibilities');
        maskVisNew = maskVisOld;
        maskEnOld  = get_param(blk, 'MaskEnables');
        maskEnNew  = maskEnOld;
        if strcmpi(get_param(blk,'InputProcessing'), ...
                'Elements as channels (sample based)')
            [maskEnNew{3}, maskVisNew{3}] = deal('off');
        else
            [maskEnNew{3}, maskVisNew{3}] = deal('on');
        end
        if ( ~isequal(maskVisNew, maskVisOld) || ~isequal(maskEnNew, maskEnOld) )
            set_param(blk, 'MaskVisibilities', maskVisNew, 'MaskEnables', maskEnNew);
        end
        
end
