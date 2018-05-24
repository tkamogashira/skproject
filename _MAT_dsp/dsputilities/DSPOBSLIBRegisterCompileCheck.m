 function DSPOBSLIBRegisterCompileCheck(block, muObj)
% DSPOBSLIBREGISTERCOMPILECHECK  Compile check registration for blocks
%   in dspobslib library
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object

%   Copyright 2012 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectFrameData, ...
    @ReplaceDSPOBSLIBBlocks);
end %DSPOBSLIBRegisterCompileCheck

%-------------------------------------------------------------------------------
% Collect block information under compile stage
function mydata = CollectFrameData(block, ~)
% Get frameness of input signal
tp  = get_param(block,'CompiledPortFrameData');
mydata.isFrame  = tp.Inport(1); 
tp  = get_param(block,'CompiledPortDimensions');
mydata.inLength = tp.Inport(2);
end

%-------------------------------------------------------------------------------
function ReplaceDSPOBSLIBBlocks(block, h, mydata)
if askToReplace(h, block)  
    if (doUpdate(h))
        % --------------------------------------------------------
        % Consider Not supported cases:
        % --- Integer Delay: input data is a FB Column && 
        %                    delay is not scalar
        %                    input data is a FB matrix &&
        %                    delay is a column or a matrix
        % --------------------------------------------------------
        blockName = get_param(block, 'ReferenceBlock');
        notSupportFlag = false;
        if strcmp(blockName,sprintf('dspobslib/Integer Delay'))
            delaySize    = size(str2num(get_param(block, 'delay')));   
            if (mydata.isFrame && (delaySize(1)~=0) &&(delaySize(1)~=1))
                notSupportFlag = true;
            end                
        end
        
        if notSupportFlag
            disp(sprintf('slupdate does not support this block(Please see release notes): \n%s\n', block));    
        else            
            funcSet =  muUpdateBlock(block, mydata);
            appendTransaction(h, block, h.ReplaceBlockReasonStr, {funcSet});
        end        
    end    
end
end % ReplaceDSPOBSLIBBlocks


% Function: getDecorationParams =========================================
function decorations = getDecorationParams(block)
%getDecorationParams Return a cell array with block decorations
%
% Decorations include FontSize, FontWeight, Orientation, etc.
%

decorations = {
    'Position',        [];
    'Orientation',     [];
    'ForegroundColor', [];
    'BackgroundColor', [];
    'DropShadow',      [];
    'NamePlacement',   [];
    'FontName',        [];
    'FontSize',        [];
    'FontWeight',      [];
    'FontAngle',       [];
    'ShowName',        []
    };

for i=1:size(decorations,1),
  decorations{i,2}=get_param(block,decorations{i,1});
end

decorations=reshape(decorations',1,length(decorations(:)));

end % getDecorationParams

function  funcSet = muUpdateBlock(oldBlock, mydata)
    load_system('simulink');
    load_system('dspmlti4')
    load_system('dspsigops')
    load_system('dspxfrm3');
    
    isFrame  = mydata.isFrame;
    inLength = mydata.inLength;
    
    % the old block's name and parent are needed for the new block
    name  = get_param(oldBlock,'Name');
    parent= get_param(oldBlock,'Parent'); 
    
    % create a temp block, if everything works fine replace the old block with this one.
    % if error ever occur, keep the old block.
    tempBlock = [parent '/temp'];
    
    % the decorations must be preserved
    decorations = getDecorationParams(oldBlock);    
    mask={};        
    
    blockName = get_param(oldBlock, 'ReferenceBlock');
    try
    switch blockName        
      case sprintf('dspobslib/Integer Delay')
        % Replace by Delay block 
        newBlock   = 'dspsigops/Delay';        
        param      = getIntegerDelayParam(oldBlock, mydata);
        add_block(newBlock, tempBlock); 
        setDelayParam(tempBlock, param);
        
      case sprintf('dspobslib/Dyadic Analysis\nFilter Bank')
        param = getDyadicParam(oldBlock, inLength);
        if isFrame
            % when single rate, direct replace with Dyadic Analysis Filter Bank 
            % and set params properly
            newBlock = sprintf('dspmlti4/Dyadic Analysis\nFilter Bank');        
            add_block(newBlock, tempBlock);
            setDyadicParam(tempBlock, param);
        else
            % when multirate, use subsystem to replace (more complicated)           
            if strcmp(param.tree, 'Asymmetric')
                newBlock = configAnalysisAsym(tempBlock,param); 
            else
                newBlock = configAnalysisSym(tempBlock,param);
            end
        end
        
        case sprintf('dspobslib/Dyadic Synthesis\nFilter Bank')
            param = getDyadicParam(oldBlock, inLength);
            if isFrame
                % when single rate, direct replace with Dyadic Synthesis Filter Bank 
                % and set params properly
                newBlock = sprintf('dspmlti4/Dyadic Synthesis\nFilter Bank');
                add_block(newBlock, tempBlock);
                setDyadicParam(tempBlock, param);
            else
                % when multirate, use subsystem to replace (more complicated) 
                if strcmp(param.tree, 'Asymmetric')
                    newBlock = configSynthesisAsym(tempBlock,param); 
                else
                    newBlock = configSynthesisSym(tempBlock,param);
                end
            end
            
        case sprintf('dspobslib/Wavelet\nAnalysis')
            param = getWaveletParam(oldBlock, inLength);
            if isFrame
                % when single rate, direct replace with DWT and set
                % params properly
                newBlock = sprintf('dspxfrm3/DWT');
                add_block(newBlock, tempBlock);
                setWaveletAnalysis(tempBlock, param);
            else
                % when multirate, use subsystem to replace (more complicated)                
                WaveletName = convertWaveletName(param);
                [LO_D,HI_D,LO_R,HI_R] = wfilters(WaveletName);
                param.hl = sprintf('[%s]', num2str(LO_D,16));
                param.hh = sprintf('[%s]', num2str(HI_D,16));               
                
                % The obsoleted one only has Asymmetric mode
                newBlock = configAnalysisAsym(tempBlock,param);
            end
            
        case sprintf('dspobslib/Wavelet\nSynthesis')
            param = getWaveletParam(oldBlock, inLength);
            if isFrame
                % when single rate, direct replace with IDWT and set
                % params properly
                newBlock          = sprintf('dspxfrm3/IDWT');
                add_block(newBlock, tempBlock);
                setWaveletSynthesis(tempBlock, param);
            else
                % when multirate, use subsystem to replace (more complicated)                
                WaveletName = convertWaveletName(param);
                [LO_D,HI_D,LO_R,HI_R] = wfilters(WaveletName);
                param.hl = sprintf('[%s]', num2str(LO_R,16));
                param.hh = sprintf('[%s]', num2str(HI_R,16));                
                
                % The obsoleted one only has Asymmetric mode
                newBlock = configSynthesisAsym(tempBlock,param);
            end
    end
    funcSet = {'replaceDSPOBSLIBBlockNew', oldBlock, newBlock};
    delete_block(oldBlock);
    add_block(tempBlock, [parent '/' name],decorations{:},mask{:});
    delete_block(tempBlock);
    catch
        delete_block(tempBlock);
    end
    
end %muUpdateBlock

function WaveletName = convertWaveletName(param)
switch param.Wname
    case 'Haar'
        WaveletName = 'haar';
    case 'Daubechies'
        WaveletName = sprintf('db%d', str2double(param.Order));
    case 'Symlets'
        WaveletName = sprintf('sym%d', str2double(param.Order));
    case 'Coiflets'
        WaveletName = sprintf('coif%d', str2double(param.Order));
    case 'Biorthogonal'
        a = param.FilterOrder;
        WaveletName = sprintf('bior%d.%d', str2double(a(2)), str2double(a(6)));
    case 'Reverse Biorthogonal'
        a = param.FilterOrder;
        WaveletName = sprintf('rbio%d.%d', str2double(a(2)), str2double(a(6)));
    case 'Discrete Meyer'
        WaveletName = 'dmey';
end
end

function param = getIntegerDelayParam(Block,mydata)
    isFrame  = mydata.isFrame;
    if isFrame
        param.InputProcessing = 'Columns as channels (frame based)';
    else
        param.InputProcessing = 'Elements as channels (sample based)';
    end
    param.delay = get_param(Block, 'delay');
    param.ic    = get_param(Block, 'ic');
    if isscalar(str2num(param.ic))
        param.dif_ic_for_ch = 'off';
    else
        param.dif_ic_for_ch = 'on';
    end
    param.reset_popup = get_param(Block, 'reset_popup');
end

function param = getDyadicParam(Block, inLength)
    param.hl        = get_param(Block, 'hl');
    param.hh        = get_param(Block, 'hh');
    param.numLevels = get_param(Block, 'numLevels');
    param.tree      = get_param(Block, 'tree');
    param.numDelay  = inLength*2^(str2double(param.numLevels)-1);
end


function param = getWaveletParam(Block, inLength)
    param.Wname         = get_param(Block, 'Wname');
    param.FilterOrder   = get_param(Block, 'OrdRec_ordDec');
    param.Order         = get_param(Block, 'Order');
    param.NumLevels     = get_param(Block, 'NumLevels');
    param.numLevels     = param.NumLevels;
    param.numDelay      = inLength*2^(str2double(param.NumLevels)-1);
end

function  setDelayParam(Block, param)
set_param(Block, 'InputProcessing',  param.InputProcessing,...
                 'delay',            param.delay,...
                 'dif_ic_for_ch',    param.dif_ic_for_ch,...
                 'ic',               param.ic,...
                 'reset_popup',      param.reset_popup);
end

function  setDyadicParam(Block, param)
    set_param(Block, 'lpf', param.hl,'hpf',   param.hh,...
                     'NumLevels', param.numLevels,...
                     'tree',  param.tree);
end

function  setSubbandParam(Block, param)
    set_param(Block, 'lpf', param.hl, 'hpf', param.hh,...
                     'InputProcessing',  'Elements as channels (sample based)',...
                     'framing', 'Allow multirate processing');
end

function  setWaveletAnalysis(Block, param)
    set_param(Block, 'Wname', param.Wname,   'OrdRec_ordDec', param.FilterOrder,...
                     'Order', param.Order,   'NumLevels', param.NumLevels,...
                     'tree', 'Asymmetric', 'Output', 'Multiple ports');
end

function  setWaveletSynthesis(Block, param)
    set_param(Block, 'Wname', param.Wname, 'OrdRec_ordDec', param.FilterOrder,...
                     'Order', param.Order, 'NumLevels', param.NumLevels,...
                     'tree', 'Asymmetric', 'Input', 'Multiple ports');
end

function addOutAndDelay(innerOutBlock, innerDelayBlock, Block, pidx, fidx, i, param)
    % Add/set/connect Out/Delay
    % pidx: Filter outport index
    % fidx: Filter block index
    % i:    Delay and Out index
    add_block(innerOutBlock, [Block sprintf('/Out%d', i)]);            
    add_block(innerDelayBlock, [Block sprintf('/delay%d',i)]);
    delayBlock = [Block sprintf('/delay%d',i)];
    set_param(delayBlock, 'delay',  num2str(param.numDelay));
    add_line(Block, sprintf('Subband Filter%d/%d',fidx, pidx),sprintf('delay%d/1',i));
    add_line(Block, sprintf('delay%d/1',i),sprintf('Out%d/1', i));
end
    
function addSubbandFilter(innerBlock, Block, pidx, fidx2, fidx1, param)
    % Add/set/connect Subband Filter
    % pidx:  Filter outport index
    % fidx2: this level Filter block index
    % fidx1: upper level Filter block index
    subbandBlock = [Block sprintf('/Subband Filter%d', fidx2)];
    add_block(innerBlock, subbandBlock);
    setSubbandParam(subbandBlock, param);            
    add_line(Block, sprintf('Subband Filter%d/%d',fidx1,pidx), sprintf('Subband Filter%d/1',fidx2));
end

function addInAndSubbandFilter(innerInBlock, innerBlock, Block, fidx, i, param)    
    % Add/set/connect Subband Filter and Inport
    % fidx: Filter block index
    % i:    Inport index
    subbandBlock = [Block sprintf('/Subband Filter%d', fidx)];
    add_block(innerBlock, subbandBlock);
    setSubbandParam(subbandBlock, param);
    
    add_block(innerInBlock, [Block sprintf('/In%d', i)]); 
    add_line(Block, sprintf('In%d/1', i),   sprintf('Subband Filter%d/1',fidx));
    add_line(Block, sprintf('Subband Filter%d/1',fidx),sprintf('Subband Filter%d/2',fidx-1));
end

function newBlock = configAnalysisAsym(subsystemBlock,param)
    innerBlock      = sprintf('dspmlti4/Two-Channel Analysis\nSubband Filter');
    innerOutBlock   = sprintf('simulink/Commonly\nUsed Blocks/Out1');
    innerDelayBlock = 'dspsigops/Delay';  
    
    % Add a Subsystem block
    newBlock = sprintf('simulink/Commonly\nUsed Blocks/Subsystem');
    add_block(newBlock, subsystemBlock);
    delete_line(subsystemBlock, 'In1/1', 'Out1/1');
    delete_block([subsystemBlock '/Out1']);
                
    % Add/set/connect Subband Filter
    subbandBlock = [subsystemBlock '/Subband Filter0'];
    add_block(innerBlock, subbandBlock);
    setSubbandParam(subbandBlock, param);
    add_line(subsystemBlock, 'In1/1', 'Subband Filter0/1');
    
    % add/set/connect Out/Delay
    addOutAndDelay(innerOutBlock, innerDelayBlock, subsystemBlock, 1, 0, 0,param);
    
    order = str2double(param.numLevels);
    if order == 1
        addOutAndDelay(innerOutBlock, innerDelayBlock, subsystemBlock, 2, 0, 1,param);
    else
        param.numDelay = param.numDelay/2;
        for i = 1: order-1                  
            % Add/set/connect Subband Filter         
            addSubbandFilter(innerBlock, subsystemBlock, 2, i, i-1,param);
            
            % add/set/connect Out/Delay
            addOutAndDelay(innerOutBlock, innerDelayBlock, subsystemBlock, 1, i, 2*i,param);
            
            param.numDelay = param.numDelay/2;
        end        
        param.numDelay = param.numDelay*2;
        
        % add/set/connect Out/Delay
        addOutAndDelay(innerOutBlock, innerDelayBlock, subsystemBlock, 2, i, 2*i+1,param);
    end 
end %configAnalysisAsym


function newBlock = configAnalysisSym(subsystemBlock,param)
    innerBlock      = sprintf('dspmlti4/Two-Channel Analysis\nSubband Filter');
    innerOutBlock   = sprintf('simulink/Commonly\nUsed Blocks/Out1');
    innerDelayBlock = 'dspsigops/Delay';                
    
    % Add a Subsystem block
    newBlock = sprintf('simulink/Commonly\nUsed Blocks/Subsystem');
    add_block(newBlock, subsystemBlock);
    delete_line(subsystemBlock, 'In1/1', 'Out1/1');
    delete_block([subsystemBlock '/Out1']);    
    
    % Add/set/connect Subband Filter
    subbandBlock = [subsystemBlock '/Subband Filter0'];
    add_block(innerBlock, subbandBlock);
    setSubbandParam(subbandBlock, param);
    add_line(subsystemBlock, 'In1/1', 'Subband Filter0/1');

    order = str2double(param.numLevels);
    if order == 1        
        % add/set/connect Out/Delay
        addOutAndDelay(innerOutBlock, innerDelayBlock, subsystemBlock, 1, 0, 1,param);         
        addOutAndDelay(innerOutBlock, innerDelayBlock, subsystemBlock, 2, 0, 0,param);
    else
        % order > 1
        param.numDelay = param.numDelay/2; 
        idx1 = 0;
        idx  = 1;       
        for i = 2:order
            for k = 1:2^(i-2) 
                subbandBlock = [subsystemBlock sprintf('/Subband Filter%d', idx)];
                add_block(innerBlock, subbandBlock);
                setSubbandParam(subbandBlock, param);
                add_line(subsystemBlock, sprintf('Subband Filter%d/2',idx1),   sprintf('Subband Filter%d/1',idx));
                idx = idx+1;
                
                subbandBlock = [subsystemBlock sprintf('/Subband Filter%d', idx)];
                add_block(innerBlock, subbandBlock);
                setSubbandParam(subbandBlock, param);
                add_line(subsystemBlock, sprintf('Subband Filter%d/1',idx1),   sprintf('Subband Filter%d/1',idx));
                idx  = idx  + 1;
                idx1 = idx1 + 1;                
            end
        end
        
        idx = idx - 1;
        for i = 1: 2^(order-1)    
            addOutAndDelay(innerOutBlock, innerDelayBlock, subsystemBlock, 1, idx, 2*i-1,param);
            addOutAndDelay(innerOutBlock, innerDelayBlock, subsystemBlock, 2, idx, 2*i,param);
            idx = idx - 1;
        end          
    end 
end %configAnalysisSym


function newBlock = configSynthesisAsym(subsystemBlock,param) 
    innerBlock      = sprintf('dspmlti4/Two-Channel Synthesis\nSubband Filter');
    innerInBlock    = sprintf('simulink/Commonly\nUsed Blocks/In1');
    innerDelayBlock = 'dspsigops/Delay';
    
    % Add a Subsystem block
    newBlock = sprintf('simulink/Commonly\nUsed Blocks/Subsystem');
    add_block(newBlock, subsystemBlock);
    delete_line(subsystemBlock, 'In1/1', 'Out1/1');
    
    % Add/set/connect Subband Filter 
    subbandBlock = [subsystemBlock '/Subband Filter0'];
    add_block(innerBlock, subbandBlock);
    setSubbandParam(subbandBlock, param);
    
    % add/set/connect Out/Delay
    delayBlock = [subsystemBlock '/delay0'];
    add_block(innerDelayBlock, delayBlock);
    set_param(delayBlock, 'delay',  num2str(param.numDelay)); 
    
    add_line(subsystemBlock, 'In1/1', 'Subband Filter0/1');
    add_line(subsystemBlock, 'Subband Filter0/1', 'delay0/1');
    add_line(subsystemBlock, 'delay0/1', 'Out1/1');
    
    order = str2double(param.numLevels);
    if order == 1
        add_block(innerInBlock, [subsystemBlock sprintf('/In%d', 2)]);
        add_line(subsystemBlock, 'In2/1', 'Subband Filter0/2');
    else
        % order > 1
        for i = 1: order-1                  
            % Add/set/connect Subband Filter and Inport
            addInAndSubbandFilter(innerInBlock, innerBlock, subsystemBlock, i, i+1, param);
        end    
        add_block(innerInBlock, [subsystemBlock sprintf('/In%d', i+2)]); 
        add_line(subsystemBlock, sprintf('In%d/1', i+2), sprintf('Subband Filter%d/2',i));    
    end 
end %configSynthesisAsym


function newBlock = configSynthesisSym(subsystemBlock,param)
    newBlock = sprintf('simulink/Commonly\nUsed Blocks/Subsystem');
    add_block(newBlock, subsystemBlock);
    delete_line(subsystemBlock, 'In1/1', 'Out1/1');
    
    innerBlock      = sprintf('dspmlti4/Two-Channel Synthesis\nSubband Filter');
    innerInBlock    = sprintf('simulink/Commonly\nUsed Blocks/In1');
    innerDelayBlock = 'dspsigops/Delay';
    
    % add/set/connect Out/Delay
    add_block(innerDelayBlock, [subsystemBlock '/delay0']);
    delayBlock = [subsystemBlock '/delay0'];
    set_param(delayBlock, 'delay',  num2str(param.numDelay)); 
    add_line(subsystemBlock, 'delay0/1', 'Out1/1');    
    
    order = str2double(param.numLevels);
    if order == 1
        % Add/set/connect Subband Filter
        subbandBlock = [subsystemBlock '/Subband Filter0'];
        add_block(innerBlock, subbandBlock);
        setSubbandParam(subbandBlock, param);
        
        add_block(innerInBlock, [subsystemBlock sprintf('/In%d', 2)]);
        add_line(subsystemBlock, 'In1/1', 'Subband Filter0/1');
        add_line(subsystemBlock, 'In2/1', 'Subband Filter0/2');
        add_line(subsystemBlock, sprintf('Subband Filter%d/1',0), 'delay0/1');
    else
        % order > 1
        delete_block([subsystemBlock '/In1']);
        
        for k = 2^(order-1):-1:1 
            add_block(innerInBlock, [subsystemBlock sprintf('/In%d', 2*k-2)]);
            add_block(innerInBlock, [subsystemBlock sprintf('/In%d', 2*k-1)]);
            subbandBlock = [subsystemBlock sprintf('/Subband Filter%d', k-1)];
            add_block(innerBlock, subbandBlock);
            setSubbandParam(subbandBlock, param);
            add_line(subsystemBlock, sprintf('In%d/1', 2*k-2),   sprintf('Subband Filter%d/1',k-1));
            add_line(subsystemBlock, sprintf('In%d/1', 2*k-1),   sprintf('Subband Filter%d/2',k-1));
        end    
        
        idx = 2^(order-1);
        idx1 = 0;
        for i = order-1:-1:1
            idx2 = idx;
            for k = 1:2^(i-1) 
                subbandBlock = [subsystemBlock sprintf('/Subband Filter%d', idx)];
                add_block(innerBlock, subbandBlock);
                setSubbandParam(subbandBlock, param);
                add_line(subsystemBlock, sprintf('Subband Filter%d/1',idx1),   sprintf('Subband Filter%d/2',idx));
                add_line(subsystemBlock, sprintf('Subband Filter%d/1',idx1+1), sprintf('Subband Filter%d/1',idx));
                idx  = idx + 1;
                idx1 = idx1+2;
            end
            idx1 = idx2;
        end
    end
    add_line(subsystemBlock, sprintf('Subband Filter%d/1',idx-1), 'delay0/1');
end %configSynthesisSym
% [EOF]

