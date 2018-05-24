function DSPMatrixSumRegisterCompileCheck(block, muObj)
% DSPMATRIXSUMREGISTERCOMPILECHECK  Compile check registration function, used to
%   replace the DSP Matrix Sum block with the built-in 'Sum of elements'
%   Simulink block. 
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object

%   Copyright 2010-2012 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectDSPMatrixSumData, ...
    @ReplaceDSPMatrixSum);

%-------------------------------------------------------------------------------
% Collect block information under compile stage
function compiledParams = CollectDSPMatrixSumData(block, ~)

inDtype                   = get_param(block,'CompiledPortDataTypes');
inDtypeStr                = inDtype.Inport{1};
compiledParams.isUnsigned = strcmpi(inDtypeStr(1),'u');
compiledParams.isFltPt    = strcmpi(inDtypeStr,'double') || ...
                                strcmpi(inDtypeStr,'single');
compiledParams.dims       = get_param(block,'CompiledPortDimensions');                
                            

%-------------------------------------------------------------------------------
function ReplaceDSPMatrixSum(block, muObj, compiledParams)
% Post compile action:
% Replace the DSP Matrix Sum block with the 'Sum of Elements' Simulink block,
% with parameters set according to the input's signedness and floating point
% status.
    

if askToReplace(muObj, block)   

    isUnsigned = compiledParams.isUnsigned;
    isFltPt    = compiledParams.isFltPt;
    
    oldEntries = GetMaskEntries(block);
    CheckEntries(block, oldEntries, 12);

    Dim               = oldEntries{1};
    outputMode        = oldEntries{4};
    outputWordLength  = oldEntries{5};    
    outputFracLength  = oldEntries{6};
    accumMode         = oldEntries{7};    
    accumWordLength   = oldEntries{8};
    accumFracLength   = oldEntries{9};
    roundingMode      = oldEntries{10};
    overflowMode      = oldEntries{11};
    LockScale         = oldEntries{12};
        
    shape = 'rectangular';
    Inputs = '+';
    if strcmp(Dim,'Entire input')
        CollapseMode = 'All dimensions';  
        CollapseDim = '1';
    else
        CollapseMode = 'Specified dimension';
        if strcmp(Dim,'Rows')
            dims = compiledParams.dims;
            if (dims.Inport(1) == 1)
                CollapseDim = '1'; % Input is 1-d
            else
                CollapseDim = '2'; % Input is greater than 1-d
            end            
        else
            CollapseDim = '1';
        end
    end

    if isFltPt,
        AccumDataTypeMode = 'Inherit: Same as first input';
    else
    
        switch accumMode    
            case 'Same as input'
                AccumDataTypeMode = 'Inherit: Same as first input';
            case {'Binary point scaling','User-defined'}
                if isUnsigned,
                    AccumDataTypeMode = ...
                        ['fixdt(0,' accumWordLength ',' accumFracLength ')'];
                else
                    AccumDataTypeMode = ...
                        ['fixdt(1,' accumWordLength ',' accumFracLength ')'];
                end
            case 'Slope and bias scaling'
                if isUnsigned,
                    AccumDataTypeMode = ...
                        ['fixdt(0,' accumWordLength ',2^-' accumFracLength ',0)'];            
                else
                    AccumDataTypeMode = ...
                        ['fixdt(1,' accumWordLength ',2^-' accumFracLength ',0)'];            
                end
            otherwise
                % Inherit via internal rule. 
                AccumDataTypeMode = 'Inherit: Inherit via internal rule';
        end
    end

    if isFltPt,
        OutDataTypeMode = 'Inherit: Same as first input';
    else    
        switch outputMode    
            case 'Same as input'
                OutDataTypeMode = 'Inherit: Same as first input';
            case {'Binary point scaling','User-defined'}
                if isUnsigned,
                    OutDataTypeMode = ...
                        ['fixdt(0,' outputWordLength ',' outputFracLength ')'];
                else
                    OutDataTypeMode = ...
                        ['fixdt(1,' outputWordLength ',' outputFracLength ')'];
                end
            case 'Slope and bias scaling'
                if isUnsigned,
                    OutDataTypeMode = ...
                        ['fixdt(0,' outputWordLength ',2^-' outputFracLength ',0)'];            
                else
                    OutDataTypeMode = ...
                        ['fixdt(1,' outputWordLength ',2^-' outputFracLength ',0)'];            
                end
            otherwise
                % same as accumulator.
                OutDataTypeMode = 'Inherit: Same as accumulator';
        end
    end
    
    % now replace the block with the built-in 'Sum of elements' block    
    funcSet = uReplaceBlock(muObj, block,'built-in/Sum',...
                'IconShape',shape, ...
                'Inputs',Inputs,...
                'CollapseMode',CollapseMode,...
                'CollapseDim',CollapseDim,...  
                'InputSameDT','off',...
                'AccumDataTypeStr',AccumDataTypeMode,...
                'OutDataTypeStr',OutDataTypeMode,...
                'RndMeth', roundingMode, ...
                'SaturateOnIntegerOverflow',overflowMode,...
                'SampleTime','-1',...
                'LockScale',LockScale);    
    appendTransaction(muObj, block, muObj.ReplaceBlockReasonStr, {funcSet});
end

% Function: CheckEntries ================================================
%
function CheckEntries(block, entriesList, num)
%CHECKENTRIES Check mask entries list for correct number
%
if length(entriesList) ~= num
    error(message('dsp:slupdate:slupdateWrongNumMaskEntries', block));
end

% [EOF]

% LocalWords:  signedness DT Accum Rnd Meth CHECKENTRIES
