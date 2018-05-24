function [outData] = dsparch3Transform(inData)
%dsparch3Transform dsparch3 library transformation table
%   Transforms and forwards all blocks in the dspddes3 library.
%   This is an internal function called by Simulink(R) during model load.

% Copyright 2013 The MathWorks, Inc.

forwardingTable = struct2cell(inData.ForwardingTableEntry);
srcBlk = regexprep(forwardingTable{1}, '\n', ' ');

switch srcBlk
    case{sprintf('dsparch3/Direct-Form II Transpose Filter')}
        outData = localTransformDirectFormIITFilter(inData);
    case{sprintf('dsparch3/Time-Varying Lattice Filter')}   
        outData = localTransformTimeVaryingLatticeFilter(inData);
    case{sprintf('dsparch3/Time-Varying Direct- Form II Transpose Filter')}   
        outData = localTransformTimeVaryingDFIITFilter(inData);
end

end
%--------------------------------------------------------------------------

function outData = localTransformDirectFormIITFilter(inData)
% Transform Direct Form II-T filter block to a Digital Filter block

% Set parameters of Digital Filter block
outData.NewBlockPath = '';
outData.NewInstanceData    = localNVPair('TypePopup', 'IIR (poles & zeros)');
outData.NewInstanceData(2) = localNVPair('IIRFiltStruct', 'Direct form II transposed');
outData.NewInstanceData(3) = localNVPair('CoeffSource', 'Specify via dialog');
outData.NewInstanceData(4) = localNVPair('InputProcessing', 'Inherited (this choice will be removed - see release notes)');
icStr = localGetVal(inData.InstanceData, 'ic', '0');
outData.NewInstanceData(5) = localNVPair('IC', icStr);
b = localGetVal(inData.InstanceData, 'num', '[1 2]');
a = localGetVal(inData.InstanceData, 'den', '1');

% Attempt to evaluate the initial conditions. If ic = 0, no need to
% normalize coefficients
ic = 1;
try
    ic = eval(icStr);
catch e %#ok
end

if (ic==0)
    outData.NewInstanceData(6) = localNVPair('NumCoeffs',  b);
    outData.NewInstanceData(7) = localNVPair('DenCoeffs',  a);
else
    % Normalize a/b coefficients by the leading a coefficient
    outData.NewInstanceData(6) = localNVPair('NumCoeffs',  sprintf('normalizeDFT2Coefficients(%s,%s,1)',b,a));
    outData.NewInstanceData(7) = localNVPair('DenCoeffs',  sprintf('normalizeDFT2Coefficients(%s,%s,2)',b,a));
end

end
%--------------------------------------------------------------------------

function outData = localTransformTimeVaryingLatticeFilter(inData)
% Transform Time-Varying Direct Form II-T filter block to a Digital Filter block

filterType = localGetVal(inData.InstanceData, 'ARMA', 'All-Zero (MA)');
filtPerFrame =  localGetVal(inData.InstanceData, 'FiltPerFrame', 'One Filter Per Sample Time');

% Set parameters of Digital Filter block
outData.NewBlockPath = '';
if strcmp(filterType,'All-Zero (MA)')
    outData.NewInstanceData    = localNVPair('TypePopup','FIR (all zeros)');
    outData.NewInstanceData(2) = localNVPair('FIRFiltStruct', 'Lattice MA');
else
    outData.NewInstanceData    = localNVPair('TypePopup','IIR (all poles)');
    outData.NewInstanceData(2) = localNVPair('AllpoleFiltStruct', 'Lattice AR');

end
if strcmp(filtPerFrame,'One Filter Per Sample Time')
    outData.NewInstanceData(3)    = localNVPair('FiltPerSampPopup','One filter per sample');
else
    outData.NewInstanceData(3)    = localNVPair('FiltPerSampPopup','One filter per frame');
end
outData.NewInstanceData(4) = localNVPair('CoeffSource', 'Input port(s)');
outData.NewInstanceData(5) = localNVPair('InputProcessing', 'Inherited (this choice will be removed - see release notes)');
outData.NewInstanceData(6) = localNVPair('IC', localGetVal(inData.InstanceData, 'IC', '0'));

end


%--------------------------------------------------------------------------

function outData = localTransformTimeVaryingDFIITFilter(inData)

% Transform Time-Varying Direct Form II-T filter block to a Digital Filter block

filterType = localGetVal(inData.InstanceData, 'NumDen', 'Pole-Zero (IIR)');
filtPerFrame =  localGetVal(inData.InstanceData, 'FiltPerFrame', 'One Filter Per Sample Time');

% Set parameters of Digital Filter block
outData.NewBlockPath = '';
if strcmp(filterType,'Pole-Zero (IIR)')
    outData.NewInstanceData    = localNVPair('TypePopup','IIR (poles & zeros)');
    outData.NewInstanceData(2)    = localNVPair('IIRFiltStruct','Direct form II transposed');
elseif strcmp(filterType,'All-Zero (FIR)')
    outData.NewInstanceData    = localNVPair('TypePopup','FIR (all zeros)');
    outData.NewInstanceData(2)    = localNVPair('FIRFiltStruct','Direct form transposed');
else
    outData.NewInstanceData    = localNVPair('TypePopup','IIR (all poles)');
    outData.NewInstanceData(2)    = localNVPair('AllpoleFiltStruct','Direct form transposed');
end
filtCheck = localGetVal(inData.InstanceData, 'filtCheck', 'on');
if strcmp(filtCheck,'on')
     outData.NewInstanceData(3)    = localNVPair('denIgnore','off');
else
    outData.NewInstanceData(3)    = localNVPair('denIgnore','on');
end
if strcmp(filtPerFrame,'One Filter Per Sample Time')
    outData.NewInstanceData(4)    = localNVPair('FiltPerSampPopup','One filter per sample');
else
    outData.NewInstanceData(4)    = localNVPair('FiltPerSampPopup','One filter per frame');
end
outData.NewInstanceData(5) = localNVPair('CoeffSource', 'Input port(s)');
outData.NewInstanceData(6) = localNVPair('InputProcessing', 'Inherited (this choice will be removed - see release notes)');
outData.NewInstanceData(7) = localNVPair('IC', localGetVal(inData.InstanceData, 'ic', '0'));

end

%--------------------------------------------------------------------------

function entry = localNVPair(name, value)
entry = struct('Name', name, 'Value', value);
end

%--------------------------------------------------------------------------

function index = localParamIndex(InstanceData, paramName)
% Search paramName for index of paramName

index = -1; % Means not found

for i=1:length(InstanceData)
    if strcmp(InstanceData(i).Name, paramName)
        index = i;
        break;
    end
end

end

%--------------------------------------------------------------------------

function value = localGetVal(InstanceData, paramName, defaultValue)
% Attemp to get value from InstanceData. But if it is not in the
% InstanceData, set it to the library default value.

index = localParamIndex(InstanceData, paramName);
if index == -1
    value = defaultValue;
else
    value = InstanceData(index).Value;
end

end
