function FDesignRegisterCompileCheck(block, h)
% Function: FDesignRegisterCompileCheck ==============================
% This function is used to update Filter Design Library blocks':
% --- Input processing widget
% --- Rate options widget
% --- underlying Integer Delay/Delay blocks, upsample/downsample blocks  

% Copyright 2010 The MathWorks, Inc.

% Check if the block really needs slupdate
ud = get_param(block, 'userdata'); 
if (isfield(ud, 'InputProcessing') &&...
    ~strcmpi(ud.InputProcessing, 'inherited'))
    return;
end

% Compile check the input frameness and call ReplaceDFDesignBlock
appendCompileCheck(h, block, @CollectFrameData, ...
    @UpdateFDesignBlock);
end

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectFrameData(block, ~)

% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);
end

function UpdateFDesignBlock(block, h, isFrame)
if askToReplace(h, block) 
    if (doUpdate(h))
        muUpdateBlock(block, isFrame);
    end
    appendTransaction(h, block, h.ReplaceBlockReasonStr, {block});
end
end

function  muUpdateBlock(Block, isFrame)

hBlk  = get_param(Block,'handle');
ud = get(hBlk, 'userdata');

ud.BuildUsingBasicElements = 'on';

% set InputProcessing info
if (strcmp(ud.ImpulseResponse, 'IIR') ||...
    strcmp(ud.FilterType, 'Sample-rate converter')||...
     strcmp(ud.FilterType, 'Interpolator'))  
    if isFrame
        % get the handle for the filter object --- Hd
        hDesigner = feval([ud.class '.load'], ud);
        [Hd, dum] = design(hDesigner); %#ok
        if isblockable(Hd)        
            % if old block has algebraic loop and blockable
            % slupdate to use block method
            ud.BuildUsingBasicElements = 'off';
            ud.InputProcessing = 'columnsaschannels';
            InputProcessing = 'Columns as channels (frame based)';
        else
            % if old block has algebraic loop but not blockable
            % do not slupdate the block
            return;
        end
    else
        ud.InputProcessing = 'elementsaschannels';
        InputProcessing    = 'Elements as channels (sample based)';
    end
else
    if isFrame
        ud.InputProcessing = 'columnsaschannels';
        InputProcessing = 'Columns as channels (frame based)';
    else
        ud.InputProcessing = 'elementsaschannels';
        InputProcessing = 'Elements as channels (sample based)';
    end
end

% In 10b, RateOption was hardcoded to allowmultirate.
ud.RateOption = 'allowmultirate';
RateOptions   = 'Allow multirate processing';

hDesigner = feval([ud.class '.load'], ud);
hDesigner.InputProcessing = ud.InputProcessing;
hDesigner.RateOption      = ud.RateOption;
hDesigner.BuildUsingBasicElements = ud.BuildUsingBasicElements;
captureState(hDesigner);
set(hBlk, 'UserData', saveobj(hDesigner));

if strcmp(ud.BuildUsingBasicElements, 'on')
    % pass down Input processing to Integer Delay blocks
    delayBlocks = find_system(hBlk, 'LookUnderMasks','on','MaskType','Integer Delay');
    if ~isempty(delayBlocks)
        if ~strncmp(get_param(delayBlocks(1), 'InputProcessing'),InputProcessing, 9)
            for i = 1: length(delayBlocks)
                blk = delayBlocks(i);
                set_param(blk, 'InputProcessing', InputProcessing);
            end
        end
    end
    
    % pass down Input processing and Rate option to Downsample/Upsample blocks
    downspBlocks = find_system(hBlk, 'LookUnderMasks','on','MaskType','Downsample');
    upspBlocks   = find_system(hBlk, 'LookUnderMasks','on','MaskType','Upsample');
    spBlocks     = [downspBlocks upspBlocks];
    if ~isempty(spBlocks)
        if ~strcmp(get_param(spBlocks(1), 'InputProcessing'),'InputProcessing')||...
                ~strcmp(get_param(spBlocks(1), 'RateOptions'),'RateOptions')
            for i = 1: length(spBlocks)
                blk = spBlocks(i);
                set_param(blk, 'InputProcessing', InputProcessing,...
                    'RateOptions', RateOptions);
            end
        end
    end
    
    
    % pass down Input processing to Delay blocks (CIC Filter)
    delayBlocks = find_system(hBlk, 'LookUnderMasks','on','MaskType','Delay');
    if ~isempty(delayBlocks)
        if ~strncmp(get_param(delayBlocks(1), 'InputProcessing'),InputProcessing, 9)
            for i = 1: length(delayBlocks)
                blk = delayBlocks(i);
                set_param(blk, 'InputProcessing', InputProcessing);
            end
        end
    end
else
    % slupdate to use block method
    [Hd, sameDesign] = design(hDesigner); %#ok
    generateModel(hDesigner, hBlk, Hd);    
end

end %muUpdateBlock

% LocalWords:  userdata frameness DF IIR Hd blockable columnsaschannels
% LocalWords:  elementsaschannels allowmultirate
