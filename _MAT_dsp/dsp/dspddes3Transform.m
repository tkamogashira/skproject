function [outData] = dspddes3Transform(inData)
%dspddes3Transform dspddes3 library transformation table
%   Transforms and forwards all blocks in the dspddes3 library.
%   This is an internal function called by Simulink(R) during model load.

% Copyright 2013 The MathWorks, Inc.

forwardingTable = struct2cell(inData.ForwardingTableEntry);
srcBlk = regexprep(forwardingTable{1}, '\n', ' ');

switch srcBlk
    case{sprintf('dspddes3/Digital FIR Filter Design')}
        outData = localTransformDigitalFIRFilterDesign(inData);
    case{ sprintf('dspddes3/Remez FIR Filter Design')}
        outData = localTransformRemezFIRFilterDesign(inData);
    case{ sprintf('dspddes3/Least Squares FIR Filter Design')}
        outData = localTransformLeastSquaresFIRFilterDesign(inData);
    case{ sprintf('dspddes3/Digital IIR Filter Design')}
        outData = localTransformDigitalIIRFilterDesign(inData);
    case{ sprintf('dspddes3/Yule-Walker IIR Filter Design')}
        outData = localTransformYuleWalkerIIRFilterDesign(inData);
    case{ sprintf('dspddes3/Digital FIR Raised Cosine Filter Design')}
        outData = localTransformDigitalFIRRaisedCosineFilterDesign(inData);
end

end
%--------------------------------------------------------------------------

function outData = localTransformDigitalFIRFilterDesign(inData)
% Transform Digital FIR Filter Design block to a Digital Filter block

% Set parameters of Digital Filter block
outData.NewBlockPath = '';
outData.NewInstanceData    = localNVPair('TypePopup', 'FIR (all zeros)');
outData.NewInstanceData(2) = localNVPair('FIRFiltStruct', 'Direct form transposed');
outData.NewInstanceData(3) = localNVPair('CoeffSource', 'Specify via dialog');
outData.NewInstanceData(4) = localNVPair('InputProcessing', 'Inherited (this choice will be removed - see release notes)');
outData.NewInstanceData(5) = localNVPair('IC', '0');

% Derive filter coefficients

N0 = localGetVal(inData.InstanceData, 'N', '22');
windowType = localGetVal(inData.InstanceData, 'wintype', 'Hamming');
Rs = localGetVal(inData.InstanceData, 'Rs', '10');
K = localGetVal(inData.InstanceData, 'Kbeta', '5');
filterType = localGetVal(inData.InstanceData, 'filttype', 'Lowpass');
Wlo =  localGetVal(inData.InstanceData, 'Wlo', '0.4');
Whi =  localGetVal(inData.InstanceData, 'Whi', '0.6');
W0 = localGetVal(inData.InstanceData, 'W0', '[.2 .5 .8]');
g0 =  localGetVal(inData.InstanceData, 'g0', '1');
if any(strcmp(filterType,{'Highpass','Bandstop'}))
    % If we have an odd order highpass or bandstop filter the window
    % length must be increased by one (this is due to the spec for fir1).
    N = sprintf('%s+mod(%s,2)',N0,N0);
elseif strcmp(filterType,'Multiband')
    % If we have an odd order multiband with high gain at the nyquist
    % frequency, fir1 will increase the order of the filter by one.
    % Hence we bump the window length by one as well.
    N = sprintf('getFIRFilterDesignMultibandOrder(%s,%s,%s)',N0,W0,g0);
else
    N = N0;
end
% Return string representing window:
window = getwindow(windowType,Rs, K,N);

switch filterType
    case  {'Lowpass','Highpass','Bandpass','Bandstop'},
        b = dspfir1des(filterType,N,Wlo,Whi,window);
    case {'Multiband'}
        b = dspfir1des(filterType,N,W0,g0,window);
    case 'Arbitrary Shape (fir2)'
        W1 = localGetVal(inData.InstanceData, 'W1', '[0 .2 .3 .6 .8 1]');
        gains = localGetVal(inData.InstanceData, 'gains', '[1 .5 0 0 1 .5]');
        b = dspfir1des(filterType,N,W1,gains,window);
    otherwise
        
end

% Set coefficients of Digital Filter block
outData.NewInstanceData(6) = localNVPair('NumCoeffs', b);
end
%--------------------------------------------------------------------------

function outData = localTransformRemezFIRFilterDesign(inData)
% Transform Remez FIR Filter Design  block to a Digital Filter block

% Set parameters of Digital Filter block
outData.NewBlockPath = '';
outData.NewInstanceData    = localNVPair('TypePopup', 'FIR (all zeros)');
outData.NewInstanceData(2) = localNVPair('FIRFiltStruct', 'Direct form transposed');
outData.NewInstanceData(3) = localNVPair('CoeffSource', 'Specify via dialog');
outData.NewInstanceData(4) = localNVPair('InputProcessing', 'Inherited (this choice will be removed - see release notes)');
outData.NewInstanceData(5) = localNVPair('IC', '0');

% Derive filter coefficients
N = localGetVal(inData.InstanceData, 'N', '23');
filterType = localGetVal(inData.InstanceData, 'filttype', 'Multiband');
A = localGetVal(inData.InstanceData, 'A', '[1 1 0 0]');
W = localGetVal(inData.InstanceData, 'W', '[1 1]');
F = localGetVal(inData.InstanceData, 'F', '[0 0.4 0.5 1]');

b = sprintf('%s,%s,%s,%s',N,F,A,W);

switch filterType
    case 'Hilbert Transformer', b = sprintf('%s,''h''',b);
    case 'Differentiator', b = sprintf('%s,''d''',b);
end

b = sprintf('remez(%s)',b);

% Set coefficients of Digital Filter block
outData.NewInstanceData(6) = localNVPair('NumCoeffs', b);
end
% ---------------------------------------------------------------------

function outData = localTransformLeastSquaresFIRFilterDesign(inData)
% Transform Least Squares FIR Filter Design  block to a Digital Filter 
% block

% Set parameters of Digital Filter block
outData.NewBlockPath = '';
outData.NewInstanceData    = localNVPair('TypePopup', 'FIR (all zeros)');
outData.NewInstanceData(2) = localNVPair('FIRFiltStruct', 'Direct form transposed');
outData.NewInstanceData(3) = localNVPair('CoeffSource', 'Specify via dialog');
outData.NewInstanceData(4) = localNVPair('InputProcessing', 'Inherited (this choice will be removed - see release notes)');
outData.NewInstanceData(5) = localNVPair('IC', '0');

% Derive filter coefficients
N = localGetVal(inData.InstanceData, 'N', '23');
filterType = localGetVal(inData.InstanceData, 'filttype', 'Multiband');
A = localGetVal(inData.InstanceData, 'A', '[1 1 0 0]');
W = localGetVal(inData.InstanceData, 'W', '[1 1]');
F = localGetVal(inData.InstanceData, 'F', '[0 0.4 0.5 1]');

b = sprintf('%s,%s,%s,%s',N,F,A,W);

switch filterType
    case 'Hilbert Transformer', b = sprintf('%s,''h''',b);

    case 'Differentiator', b = sprintf('%s,''d''',b);
end

b = sprintf('firls(%s)',b);

% Set coefficients of Digital Filter block
outData.NewInstanceData(6) = localNVPair('NumCoeffs', b);

end

%--------------------------------------------------------------------------

function outData = localTransformDigitalIIRFilterDesign(inData)
% Transform Digital IIR Filter Design  block to a Digital Filter block

% Set parameters of Digital Filter block
outData.NewBlockPath = '';
outData.NewInstanceData    = localNVPair('TypePopup', 'IIR (poles & zeros)');
outData.NewInstanceData(2) = localNVPair('IIRFiltStruct', 'Direct form II transposed');
outData.NewInstanceData(3) = localNVPair('CoeffSource', 'Specify via dialog');
outData.NewInstanceData(4) = localNVPair('InputProcessing', 'Inherited (this choice will be removed - see release notes)');
outData.NewInstanceData(5) = localNVPair('IC', '0');

% Derive filter coefficients
method = localGetVal(inData.InstanceData, 'method', 'Butterworth');
N = localGetVal(inData.InstanceData, 'N', '4');
Wlo = localGetVal(inData.InstanceData, 'Wlo', '0.4');
Whi = localGetVal(inData.InstanceData, 'Whi', '0.6');
Rp =  localGetVal(inData.InstanceData, 'Rp', '2');
Rs =  localGetVal(inData.InstanceData, 'Rs', '20');
filttype = localGetVal(inData.InstanceData, 'filttype', 'Lowpass');
% getIIRFilterDesignOutput will return numerator coefficients or
% denominator coefficients
b = sprintf('getIIRFilterDesignOutput(''%s'',''%s'',%s,%s,%s,%s,%s,1)',method , filttype, N , Rp , Rs , Wlo ,Whi);
a = sprintf('getIIRFilterDesignOutput(''%s'',''%s'',%s,%s,%s,%s,%s,2)',method , filttype, N , Rp , Rs , Wlo ,Whi);

% Set coefficients of Digital Filter block
outData.NewInstanceData(6) = localNVPair('NumCoeffs', b);
outData.NewInstanceData(7) = localNVPair('DenCoeffs', a);

end

%--------------------------------------------------------------------------

function outData = localTransformYuleWalkerIIRFilterDesign(inData)
% Transform Yule-Walker IIR Filter Design  block to a Digital Filter block

% Set parameters of Digital Filter block
outData.NewBlockPath = '';
outData.NewInstanceData    = localNVPair('TypePopup', 'IIR (poles & zeros)');
outData.NewInstanceData(2) = localNVPair('IIRFiltStruct', 'Direct form II transposed');
outData.NewInstanceData(3) = localNVPair('CoeffSource', 'Specify via dialog');
outData.NewInstanceData(4) = localNVPair('InputProcessing', 'Inherited (this choice will be removed - see release notes)');
outData.NewInstanceData(5) = localNVPair('IC', '0');

% Derive filter coefficients
N = localGetVal(inData.InstanceData, 'N', '8');
F = localGetVal(inData.InstanceData, 'F', '[0 .4 .6 1]');
A = localGetVal(inData.InstanceData, 'A', '[1 1 0 0]');

% getYuleWalkerIIRFilterDesignOutput will return numerator coefficients or
% denominator coefficients
b = sprintf('getYuleWalkerIIRFilterDesignOutput(%s,%s,%s,1)',N,F,A);
a = sprintf('getYuleWalkerIIRFilterDesignOutput(%s,%s,%s,2)',N,F,A);

outData.NewInstanceData(6) = localNVPair('NumCoeffs', b);
outData.NewInstanceData(7) = localNVPair('DenCoeffs', a);

end

%--------------------------------------------------------------------------

function outData = localTransformDigitalFIRRaisedCosineFilterDesign(inData)
% Transform Digital FIR Raised Cosine Filter Design block to a Digital 
% Filter block

% Set parameters of Digital Filter block
outData.NewBlockPath = '';
outData.NewInstanceData    = localNVPair('TypePopup', 'FIR (all zeros)');
outData.NewInstanceData(2) = localNVPair('FIRFiltStruct', 'Direct form transposed');
outData.NewInstanceData(3) = localNVPair('CoeffSource', 'Specify via dialog');
outData.NewInstanceData(4) = localNVPair('InputProcessing', 'Inherited (this choice will be removed - see release notes)');
outData.NewInstanceData(5) = localNVPair('IC', localGetVal(inData.InstanceData, 'InitCond', '0'));

% Derive filter coefficients
N = localGetVal(inData.InstanceData, 'filter_order', '63');
% Make the order even
N = sprintf('%s + mod(%s,2)',N,N);
enable_sqrt_design = localGetVal(inData.InstanceData, 'enable_sqrt_design', 'on');
wintype = localGetVal(inData.InstanceData, 'window_type', 'Boxcar');
Rs = localGetVal(inData.InstanceData, 'Rs', '5');
Kbeta = localGetVal(inData.InstanceData, 'Kbeta', '10');
DesignMethod = localGetVal(inData.InstanceData, 'rolloff_type', 'Rolloff factor');
RCFc = localGetVal(inData.InstanceData, 'upper_cutoff_freq', '0.5');
RollOff = localGetVal(inData.InstanceData, 'rolloff_factor', '0.6');
TransitionBW = localGetVal(inData.InstanceData, 'transition_bw', '0.4');

% Get string of window
window = getwindow(wintype,Rs,Kbeta,N);

if strcmp(enable_sqrt_design,'on')
    sqrtFlag = [',' '''sqrt'''];
else
    sqrtFlag = [',' '''normal'''];
end

if strcmp(DesignMethod,'Rolloff factor')
   CmdStr = sprintf('firrcos(%s,%s,%s,2,''rolloff''%s,(%s)/2,%s)',N,RCFc,RollOff,sqrtFlag,N,window); 
else
   CmdStr = sprintf('firrcos(%s,%s,%s,2%s,(%s)/2,%s)',N,RCFc,TransitionBW,sqrtFlag,N,window);  
end

b = CmdStr;

outData.NewInstanceData(6) = localNVPair('NumCoeffs', b);

end

%--------------------------------------------------------------------------

function window = getwindow(wintype,cheby_winarg,kaiser_winarg,N)
% Calculate the window to be used in the filter design
if (strcmp(wintype, 'Chebyshev'))
    wintype = 'chebwin';
elseif (strcmp(wintype, 'Triangular'))
    wintype = 'triang';
end
if strcmp(wintype, 'chebwin')
    window = sprintf('%s(%s+1, %s)',lower(wintype),N,cheby_winarg);
elseif strcmp(wintype, 'Kaiser')
    window = sprintf('%s(%s+1, %s)',lower(wintype),N,kaiser_winarg);
else
    window = sprintf('%s(%s+1)',lower(wintype),N);
end
end

% ---------------------------------------------------------------------

function b = dspfir1des(type,N,arg1,arg2,window)

if strcmp(type,'Arbitrary Shape (fir2)')
    str = sprintf('fir2(%s',N);
else
    str = sprintf('fir1(%s',N);
end

switch type
    case 'Lowpass',
        str = sprintf('%s,%s',str,arg1);
    case 'Highpass',
        str = sprintf('%s,%s,''high''',str,arg1);
    case 'Bandpass',
        str = sprintf('%s,[%s %s]',str,arg1,arg2);
    case 'Bandstop',
        str = sprintf('%s,[%s,%s],''stop''',str,arg1,arg2);
    case 'Multiband',
        str = sprintf('%s,%s,getFIRFilterDesignMultibandWhi(%s)',str,arg1,arg2);
    case 'Arbitrary Shape (fir2)'
        str = sprintf('%s,%s,%s',str,arg1,arg2);
    otherwise,
end

b = sprintf('%s,%s)',str,window);
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
