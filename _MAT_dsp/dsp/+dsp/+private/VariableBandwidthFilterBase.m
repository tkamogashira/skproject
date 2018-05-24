classdef VariableBandwidthFilterBase < matlab.System  & dsp.private.FilterAnalysis
%VARIABLEBANDWIDTHFILTERBASE Abstract base class for variable bandwidth
% objects. dsp.VariableBandwidthIIRFilter and 
% dsp.VariableBandwidthFIRFilter inherit from this base class.  

%   Copyright 2013 The MathWorks, Inc.

%#codegen
%#ok<*EMCLS>

properties (Nontunable)
  % SampleRate Input sample rate
  %   Specify the sampling rate of the input in Hertz as a finite numeric
  %   scalar. The default is 44.1 kHz.
  SampleRate = 44100;
  %FilterType Filter type
  %   Specify the type of the filter as one of 'Lowpass' | 'Highpass'
  %   | 'Bandpass' | 'Bandstop'. The default is 'Lowpass'.
  FilterType = 'Lowpass';
end
    
properties
   %CenterFrequency  Filter center frequency.
  %   Specify the filter center frequency in Hz as a real, positive
  %   scalar smaller than SampleRate/2. This property applies when
  %   you set the FilterType property to 'Bandpass' or 'Bandstop'.
  %   The default is 11025 Hz. This property is tunable.
  CenterFrequency     = 44100/4;
  % Bandwidth  Filter center bandwidth.
  %   Specify the filter bandwidth in Hertz as a real, positive
  %   scalar smaller than SampleRate/2. This property applies when
  %   you set the FilterType property to 'Bandpass' or 'Bandstop'.
  %   The default is 7680 Hz. This property is tunable.
  Bandwidth           = 7680;
end

properties(Constant, Hidden)
  % String sets
  FilterTypeSet = matlab.system.StringSet( {'Lowpass',...
                                            'Highpass',...
                                            'Bandpass',...
                                            'Bandstop'} );
end

properties (Access = protected)
  % filter handle. Children objects instantiate and set this object
  pfilter;
end

properties (Access = protected, Nontunable)
  % pDatatype Input datatype
  pDatatype;
end

properties (Access = protected)
  % pNumChannels Number of input channels
  pNumChannels;
end

%--------------------------------------------------------------------------
% Abstract Protected methods
%--------------------------------------------------------------------------
methods (Abstract, Access = protected)
  % Abstract methods. 
        
  %TUNECOEFFICIENTS Children objects redefine this method to specify
  % how coefficients are modified when filter characteristic is tuned
  tuneCoefficients(~);
        
  % VALIDATEFREQUENCYRANGE Children objects redefine this method to
  % validate cutoff frequencies versus sample rate. 
  validateFrequencyRange(~);
end
%--------------------------------------------------------------------------
% Abstract Static Hidden methods
%--------------------------------------------------------------------------
methods (Abstract,  Static, Hidden)
  % Abstract method. Children objects redefine this method so specify
  % equivalent DFILT object (for filter analysis methods)
  d = getdfiltobj(sysObjToAnalyze,arith);  
end
%--------------------------------------------------------------------------
% Public methods
%-------------------------------------------------------------------------- 
methods
  function obj = VariableBandwidthFilterBase(varargin)
    % Constructor
    coder.allowpcode('plain');
    setProperties(obj, nargin, varargin{:});
    % set initial pNumChannels to -1 (will be set to actual value in setup)
    obj.pNumChannels = -1;
  end
  %------------------------------------------------------------------------       
  function set.SampleRate(obj,value)
    % Validate and set SampleRate
    validateattributes(value,...
    {'double','single'}, ...
    {'real','scalar','positive','finite'},...
    '','SampleRate');%#ok<EMCA>
    obj.SampleRate = value;
  end
  %------------------------------------------------------------------------
  function set.CenterFrequency(obj,value)
    % Validate CenterFrequency. Validation against the sample rate
    % and the bandwidth happens when the object is locked.
    validateattributes(value,...
          {'double','single'}, ...
          {'real','scalar','positive','finite'},...
          '','CenterFrequency');%#ok<EMCA>
    % Set the normalized center frequency
    obj.CenterFrequency = value;
  end
  %------------------------------------------------------------------------
  function set.Bandwidth(obj,value)
    % Validate Bandwidth. Validation against the sample rate and
    % center frequency happens when the object is locked.
    validateattributes(value,...
          {'double','single'},...
          {'real','scalar','positive','finite'},...
          '','Bandwidth');%#ok<EMCA>
    % Set the normalized Bandwidth
    obj.Bandwidth = value;
  end
  %----------------------------------------------------------------------
  function realizemdl(~,~)
    % realizemdl is not supported     
    matlab.system.internal.error(...
    'dsp:system:VariableBandwidthFilter:UnsupportedMethod','realizemdl');   
  end
end
%--------------------------------------------------------------------------
% Protected methods
%-------------------------------------------------------------------------- 
methods (Access = protected)   
  function resetImpl(obj)
    % Reset the filter object
    reset(obj.pfilter);
  end
  %------------------------------------------------------------------------
  function releaseImpl(obj)
    % Release the filter object
    release(obj.pfilter);
    obj.pNumChannels = -1;
  end
  %------------------------------------------------------------------------
  function setupImpl(obj, x)
    % Setup the input datatype and number of channels.
    obj.pDatatype = class(x);
    obj.pNumChannels = size(x,2);
  end
  %------------------------------------------------------------------------
  function flag = isInactivePropertyImpl(obj, prop)
    flag = false;
    switch prop
    case {'CenterFrequency','Bandwidth'}
        if ~strcmp(obj.FilterType,'Bandpass') && ...
                ~strcmp(obj.FilterType,'Bandstop')
            flag = true;
        end
        otherwise
    end
  end
  %------------------------------------------------------------------------
  function s = saveObjectImpl(obj)
    s = saveObjectImpl@matlab.System(obj);
    if isLocked(obj)
        s.pfilter      = matlab.System.saveObject(obj.pfilter);
        s.pDatatype    = obj.pDatatype;
        s.pNumChannels = obj.pNumChannels;
    end
  end
  %------------------------------------------------------------------------
  function loadObjectImpl(obj, s, wasLocked)
    if wasLocked
        obj.pfilter = matlab.System.loadObject(s.pfilter);
        obj.pDatatype    = s.pDatatype;
        obj.pNumChannels = s.pNumChannels;
    end
    loadObjectImpl@matlab.System(obj, s);
  end
  %------------------------------------------------------------------------
  function flag = isInputComplexityLockedImpl(~,~)
    flag = true;
  end
  %------------------------------------------------------------------------
  function validatePropertiesImpl(obj)
    % Cross-validation of filter specifications
    if strcmp(obj.FilterType,'Bandpass') || ...
       strcmp(obj.FilterType,'Bandstop')
        coder.internal.errorIf(obj.CenterFrequency > obj.SampleRate/2, 'dsp:system:VariableBandwidthFilter:CharacteristicTooLarge','CenterFrequency');
        coder.internal.errorIf(obj.Bandwidth > obj.SampleRate/2, 'dsp:system:VariableBandwidthFilter:CharacteristicTooLarge','Bandwidth');
        coder.internal.errorIf(obj.CenterFrequency + obj.Bandwidth/2 > obj.SampleRate/2, 'dsp:system:VariableBandwidthFilter:CharacteristicTooLarge','CenterFrequency + Bandwidth/2');
        coder.internal.errorIf(obj.CenterFrequency - obj.Bandwidth/2 < 0, 'dsp:system:VariableBandwidthFilter:CFMinusBandwidthNegative');
    else % highpass/lowpass validation
        validateFrequencyRange(obj);
    end
  end
  %------------------------------------------------------------------------
  function processTunedPropertiesImpl(obj)
    % Tune the filter coefficients
    tuneCoefficients(obj);
  end
  %------------------------------------------------------------------------ 
  function flag = isInputSizeLockedImpl(~,~)
    % Variable size inputs are allowed.
    flag = false;
  end
  %------------------------------------------------------------------------
  function validateInputsImpl(obj, u)  
    validateattributes(u,{'double','single'}, {'2d',...
          'nonsparse'},'','input');%#ok<EMCA>
    % The number of input channel is not allowed to change.
    coder.internal.errorIf(obj.pNumChannels~=-1 && obj.pNumChannels ~= size(u,2), 'dsp:system:varSizeChannelsNotSupported');
    if(~isLocked(obj))
        % (Method of dsp.private.FilterAnalysis) Stores the data
        % type of input as ['double'|'single'|'fixed'] to use for
        % filter analysis
        cacheInputDataType(obj, u)
    end
  end
  %------------------------------------------------------------------------
  function d = convertToDFILT(obj, arith)
    % Returns equivalent dfilt to current object.
    if(~isLocked(obj))
        sysObjToAnalyze = clone(obj);
        setup(sysObjToAnalyze, 1)
    else
        sysObjToAnalyze = obj;
    end 
    % Force tuning to reflect latest properties
    tuneCoefficients(sysObjToAnalyze); 
    % Fixed-point analysis is not currently supported
    assert(strcmpi(arith,'single') || strcmpi(arith,'double')); 
    % getdfiltobj is defined by children objects.
    d = obj.getdfiltobj(sysObjToAnalyze,arith);
  end  
end
%--------------------------------------------------------------------------
% Hidden methods
%--------------------------------------------------------------------------
methods (Hidden)
  % Methods required for filter analysis functionality
  function restrictionsCell = getFixedPointRestrictions(~,~)
    restrictionsCell = {}; %#ok
  end
  %------------------------------------------------------------------------
  function props = getFixedPointProperties(~)
    props = {}; %#ok
  end
  %------------------------------------------------------------------------
  function props = getNonFixedPointProperties(obj)
    props = obj.getPropertyNames;
    idxtoprune = [];
    for k = 1:length(props)
        if(isInactiveProperty(obj, props{k})) %#ok
            idxtoprune = [idxtoprune, k]; %#ok
        end
    end
    props(idxtoprune) = [];
  end
  %------------------------------------------------------------------------
  function flag = isPropertyActive(obj,prop)
    flag = ~isInactiveProperty(obj, prop);
  end
end  
end