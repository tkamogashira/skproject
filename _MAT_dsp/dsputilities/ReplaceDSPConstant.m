% Function: ReplaceDSPConstant ==============================
% This function is used to replace the obsoleted DSP Constant block with
% the 'Constant' block in dspsrcs4.mdl in user's models. 

%   Copyright 2010-2012 The MathWorks, Inc.

function ReplaceDSPConstant(block, h)
%ReplaceDSPConstant Replaces obsolete DSP Constant with Simulink's built-in
%Constant block. 
% 
if askToReplace(h, block)    
    oldEntries = GetMaskEntries(block);
    CheckEntries(block, oldEntries, 17);

    Value           = oldEntries{1};
    SampleMode      = oldEntries{2};
    discreteOutput  = oldEntries{3};
    continuousOutput= oldEntries{4};
    sampTime        = oldEntries{5};    
    framePeriod = oldEntries{6};
    additionalParams = oldEntries{7};    
    allowOverrides = oldEntries{8};
    dataType = oldEntries{9};
    isSigned = oldEntries{10};
    wordLen = oldEntries{11};
    udDataType = oldEntries{12};
    fracBitsMode = oldEntries{13};
    numFracBits = oldEntries{14};
    InterpretAs1D = oldEntries{15};
    Ts = oldEntries{16};
    FramebasedOutput = oldEntries{17};
    
    % Default settings for the 'Constant' block. 
    inSampleBasedMode = true;
    SamplingMode = 'Sample based';
    SampleTime = 'inf';
    FramePeriod = 'inf';
    isContinuous = false;
    OutDataType = 'sfix(16)';
    conRadixGroup = 'Use specified scaling';
    OutScaling = '2^0';

    % Set the 'Constant' block properties based on the obsoleted 'DSP
    % Constant' block properties. 
    if strcmp(SampleMode,'Discrete') 
        VectorParams1D =  strcmp(discreteOutput,'Sample-based (interpret vectors as 1-D)');
        if (~VectorParams1D)
            SamplingMode   = discreteOutput;
            if (strcmp(discreteOutput,'Frame-based'))
                inSampleBasedMode = false;
            end
        end
    else
        VectorParams1D =  strcmp(continuousOutput,'Sample-based (interpret vectors as 1-D)');
        isContinuous = true;
    end
    if (VectorParams1D)
        VectorParams1DStr = 'on';
    else
        VectorParams1DStr = 'off';
        k = find(SamplingMode == '-');
        SamplingMode(k) = ' ';
    end

    if (~isContinuous)
        if inSampleBasedMode
            SampleTime = sampTime;
        else
            FramePeriod = framePeriod;
        end
    end

    % SL Constant data type
    switch dataType        
      case 'Fixed-point'
        % set sign
        if strcmpi(isSigned,'on')
            sign = '1';
        else
            sign = '0';
        end
        
        % already have wordLen
        
        if strcmp(fracBitsMode,'Best precision')
            OutDataTypeStr = ['fixdt(' sign ',' wordLen ')'];
        else
            fracLen = numFracBits;
            OutDataTypeStr = ['fixdt(', sign ',' wordLen ',' fracLen ')'];
        end
      case 'User-defined'
        % set the data type
        outDataType = udDataType;

        % set the scaling, if necessary
        if dspDataTypeDeterminesFracBits(udDataType)
            OutDataTypeStr = outDataType;
        else
            if strcmp(fracBitsMode,'Best precision')
                OutDataTypeStr = outDataType;
            else
                outScaling = ['2^(-(' numFracBits '))'];
                OutDataTypeStr = ['slDataTypeAndScale(''' outDataType ''',''' outScaling ''')'];
            end
        end
      case {'double','single','int8','uint8','int16','uint16','int32','uint32','boolean'}
        % Simulink built-in data types
        OutDataTypeStr = dataType;
      case {'Inherit from ''Constant value''' 'Inherit via back propagation'}
        % Inheritance rules     
        OutDataTypeStr = [ 'Inherit: ' dataType];
      otherwise
        assert('Unexpected data types'); 
    end

    % now replace the block with the built-in Constant block
    funcSet = uReplaceBlock(h, block,'built-in/Constant',...
                'Value',Value, ...
                'VectorParams1D',VectorParams1DStr,...
                'SamplingMode',SamplingMode,...
                'SampleTime',SampleTime,...
                'FramePeriod',FramePeriod,...
                'OutDataTypeStr',OutDataTypeStr);    
    appendTransaction(h, block, h.ReplaceBlockReasonStr, {funcSet});
end

% Function: CheckEntries ================================================
%
function CheckEntries(block, entriesList, num)
%CHECKENTRIES Check mask entries list for correct number
%

if length(entriesList) ~= num
    error(message('dsp:slupdate:slupdateWrongNumMaskEntries', block));
end


