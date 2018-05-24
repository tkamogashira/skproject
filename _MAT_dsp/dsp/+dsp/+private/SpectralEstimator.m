classdef SpectralEstimator < matlab.System
%SpectralEstimator SpectralEstimator class
  
%   Copyright 2012-2013 The MathWorks, Inc.

properties (Nontunable)
  SampleRate = 10e3;
end
properties   
  FrequencySpan = 'Full';
  Span = 10e3;
  CenterFrequency = 0;
  StartFrequency = -5e3;
  StopFrequency = 5e3;  
  FrequencyResolutionMethod = 'RBW';
  RBWSource = 'Auto';
  RBW = 9.76;
  FFTLengthSource = 'Auto';
  FFTLength = 1024;
  WindowLength = 1024;
  Window = 'Hann';
  SidelobeAttenuation = 60;
  % If channel mode is 'All' then we compute periodograms for all channels.
  % If it is 'Single' then we compute the periodograms for the channel
  % specified in ChannelNumber property.
  ChannelMode = 'All';
  % Channel number only relevant when ChannelMode is 'Single'
  ChannelNumber = 1;
end
properties (PositiveInteger)
  SpectralAverages = 10;
end
properties (Logical)
  MaxHoldTrace = false;
  MinHoldTrace = false;
  TwoSidedSpectrum = true;
end
properties (Logical, Nontunable)  
  DigitalDownConvert = true;
end

properties (Constant, Hidden)
  WindowSet = matlab.system.StringSet({...
    'Rectangular', ...
    'Chebyshev', ...
    'Flat Top', ...
    'Hamming', ...
    'Hann', ...
    'Kaiser'});
  FFTLengthSourceSet = matlab.system.StringSet({'Auto','Property'});
  RBWSourceSet = matlab.system.StringSet({'Auto','Property'});
  FrequencySpanSet = matlab.system.StringSet( {'Full','Span and center frequency','Start and stop frequencies'});
  ChannelModeSet = matlab.system.StringSet({'All','Single'});
  FrequencyResolutionMethodSet = matlab.system.StringSet({'RBW','WindowLength'});
end

properties
  OverlapPercent = 0;
  ReduceUpdates = false;
end

properties (Hidden)
  %DataBuffer Handle to buffer object, we set the buffer object according to current
  % settings. This is the buffer used by the source to buffer the input
  % data. The buffer consists of an input buffer, a DDC, and a segment
  % buffer. 
  DataBuffer;
end

properties (Access = private)  
  %sSegmentBuffer Handle to buffer System object that creates vectors of
  %data with required segment length
  sSegmentBuffer
  %sDDC Handle to DDC System object 
  sDDC    
  %pInputFrameLength Input frame length
  pInputFrameLength
  %pNumChannels Number of input channels
  pNumChannels
  %pSegmentLength Segment length required to achieve specified RBW
  pSegmentLength 
  %pWindowData Precomputed window vector
  pWindowData
  %pWindowData Precomputed window power used to normalize spectrum
  pWindowPower
  %pNFFT Actual NFFT value being used in the spectrum estimation algorithm
  pNFFT  
  %pInputProcessingFunction Handle to input processing function - If the
  %DDC is enabled, then this function will consist of a DDC followed by a
  %segment length buffer, otherwise this function will be no action.
  pInputProcessingFunction
  %pIsCurrentSpectrumTwoSided True if current spectrum is two sided
  pIsCurrentSpectrumTwoSided
  %pIsDownSamplerEnabled True if down sampling is enabled
  pIsDownSamplerEnabled
  %pIsDownConverterEnabled True if frequency down conversion is enabled
  pIsDownConverterEnabled
  %pActualSampleRate Contains the current sample rate according to the
  %decimation factor being used in the down sampling process. The value
  %equals SampleRate/DecimationFactor.
  pActualSampleRate
  %pPeriodogramMatrix 3D matrix containing the last SpectralAverages
  %periodograms in each column. The third dimension contains matrices for
  %each input channel. So pPeriodogramMatrix(:,:,i) contains the
  %periodograms for the i-th channel.
  pPeriodogramMatrix
  %pMaxHoldPSD Matrix with a number of columns equal to the number
  %of input channels. Column i contains the current max hold PSD
  %for the i-th channel.
  pMaxHoldPSD
  %pMinHoldPSD Matrix with a number of columns equal to the number
  %of input channels. Column i contains the current min hold PSD
  %for the i-th channel.  
  pMinHoldPSD
  %pNumAvgsCounter Counter that counts number of averages and saturates
  %when its value reaches SpectralAverages. This counter is used to avoid
  %averaging initial all zero periodograms.
  pNumAvgsCounter   
  %pNewPeriodogramIdx Index for newer periodogram column in the
  %pPeriodogramMatrix
  pNewPeriodogramIdx
  %pDDCCoeffs Container that holds structures with filter coefficients
  %predesigned for different decimation factor values. The container keys
  %to access each structure are the values of the decimation factors.
  pDDCCoeffs  
  %pIsLockedFlag True if System object is about to be locked
  pIsLockedFlag = false;
  %pDataWrapFlag Flag that indicates that NFFT < Segment length
  pDataWrapFlag = false;
  %pFreqVect Vector containing frequency values for the current spectrum
  pFreqVect
  %pFreqVectLength Length of pFreqVect
  pFreqVectLength
  %pIdxFreqVect We use this vector of indices to keep the PSD points of
  %interest and trim points that fall out of the current span interval.
  pIdxFreqVect
  %pActualFstart Current Fstart value
  pActualFstart
  %pActualFstop Current Fstop value
  pActualFstop
  % Actual RBW (may differ from specified RBW)
  ActualRBW
end

% Properties to check if tunable property has changed
properties (Access = private)  
  pFrequencySpanOld = 'Full';
  pSpanOld = 10e3;
  pCenterFrequencyOld = 0;
  pStartFrequencyOld = -5e3;
  pStopFrequencyOld = 5e3;  
  pRBWSourceOld = 'Auto';
  pRBWOld = 9.76;
  pWindowOld = 'Hamming';
  pSidelobeAttenuationOld = 60;
  pSpectralAveragesOld = 10;
  pFFTLengthSourceOld = 'Auto';
  pFFTLengthOld = 1024;
  pMaxHoldTraceOld = false;
  pMinHoldTraceOld = false;  
  pOverlapPercentOld = 80;
  pChannelModeOld = 'All';
  pChannelNumberOld = 1;
  pWindowLengthOld = 1024;
  pFrequencyResolutionMethodOld = 'RBW';
end
%--------------------------------------------------------------------------
% Public methods
%--------------------------------------------------------------------------
methods
  function obj = SpectralEstimator(varargin)
    setProperties(obj, nargin, varargin{:});
    
    % Instantiate contained objects
    obj.sSegmentBuffer = scopesutil.SpectrumBuffer(1,80,true,1);
    obj.sDDC = dsp.DigitalDownConverter('FilterSpecification','Coefficients');
    % Load DDC filter coefficients. These coefficients are in a container.
    % The script used to compute the coefficients can be found in
    % ..\toolbox\dsp\dsp\+dsp\+private\computeDDCFilterCoefficients.m
    loadedStruct = load(fullfile(matlabroot,'toolbox','dsp','dsp','+dsp','+private','DDCCoefficients.mat'));
    obj.pDDCCoeffs = loadedStruct.ddcCoeffs;    
  end  
  %------------------------------------------------------------------------
  function RBW = getRBW(obj)
    %getRBW Get current resolution bandwidth
    if strcmp(obj.FrequencyResolutionMethod,'RBW')
      if strcmp(obj.RBWSource,'Auto')
        RBW = getSpan(obj)/1024;
      else
        RBW = obj.RBW;
      end
    else
      WL = obj.WindowLength;
      RBW = getENBW(obj,WL)*obj.SampleRate/WL;      
    end
  end  
  %------------------------------------------------------------------------
  function span = getSpan(obj)
    %getSpan Get current span
    if strcmp(obj.FrequencySpan,'Full')
      span = obj.SampleRate;
      if ~obj.TwoSidedSpectrum
        span = span/2;
      end        
    elseif strcmp(obj.FrequencySpan,'Span and center frequency')
      span = obj.Span;
    else
      span = obj.StopFrequency - obj.StartFrequency;
    end    
  end    
  %------------------------------------------------------------------------
  function cf = getCenterFrequency(obj)
    %getCenterFrequency Get current center frequency
    if strcmp(obj.FrequencySpan,'Full')
      cf = obj.SampleRate/4;
      if obj.TwoSidedSpectrum
        cf = 0;
      end        
     elseif strcmp(obj.FrequencySpan,'Span and center frequency')
      cf = obj.CenterFrequency;
    else
      cf = (obj.StopFrequency + obj.StartFrequency)/2;
    end
  end    
  %------------------------------------------------------------------------
  function Fstart = getFstart(obj)
    %getFstart Get current Fstart
    Fstart = getCenterFrequency(obj) - getSpan(obj)/2;    
  end
  %------------------------------------------------------------------------
  function Fstop = getFstop(obj)
    %getFstop Get current Fstop
    Fstop = getCenterFrequency(obj) + getSpan(obj)/2;    
  end 
  %------------------------------------------------------------------------  
  function ENBW = getWindowENBW(obj,L,Win,sideLobeAttn)
      if nargin == 1
        if strcmp(obj.FrequencyResolutionMethod,'WindowLength')
          % We do not have to wait for the object to be locked to know the
          % value.
          segLen = obj.WindowLength;
        else
          segLen = obj.pSegmentLength;
        end
      else
          segLen = L;
      end
      
      if nargin < 3
        % Get ENBW corresponding to the current segment length
        ENBW = getENBW(obj,segLen);
      elseif nargin < 4
        ENBW = getENBW(obj,segLen,Win);
      else
        ENBW = getENBW(obj,segLen,Win,sideLobeAttn);
      end
  end
  %------------------------------------------------------------------------  
  function [SL,DF] = getSegmentLength(obj,varargin)
    
    if (nargin == 1)
      ReadOut = obj.pIsLockedFlag;
    else
      ReadOut = true;
    end        
    
    % Get the segment length         
    if ReadOut
      SL = obj.pSegmentLength;      
      % Get decimation factor (if any is being used)
      DF = 1;
      if obj.pIsDownSamplerEnabled
        DF = prod(obj.sDDC.DecimationFactor);        
      end
    elseif strcmp(obj.FrequencyResolutionMethod,'WindowLength')
      % We do not have to wait for the object to be locked to know the
      % value.      
      SL = obj.WindowLength;
      DF = 1;
    else
      SL = [];
      DF = [];
    end
  end
  %------------------------------------------------------------------------  
  function NFFT = getNFFT(obj)
    NFFT = [];
    if obj.pIsLockedFlag
      NFFT = obj.pNFFT;
    elseif strcmp(obj.FrequencyResolutionMethod,'WindowLength')
      % We do not have to wait for the object to be locked to know the
      % value.
      if strcmp(obj.FFTLengthSource,'Auto')
        NFFT = max(obj.WindowLength,1024);
      else
        NFFT = obj.FFTLength;
      end
    end
  end    
  %------------------------------------------------------------------------  
  function ispu = getInputSamplesPerUpdate(obj,varargin)
      
    if (nargin == 1)
        ReadOut = obj.pIsLockedFlag;
    else
        ReadOut = true;
    end
    
    % Get the number of input samples required for a PSD update           
    if ReadOut
      % New input samples needed to create a segment equals the segment
      % length minus the number of overlap samples
      spls = obj.pSegmentLength - getNumOverlapSamples(obj);      
      % Get decimation factor (if any is being used)
      DF = 1;
      if obj.pIsDownSamplerEnabled
        DF = prod(obj.sDDC.DecimationFactor);        
      end
      % Multiply the number of samples by the decimation factor to get the
      % number of samples at the input rate.
      ispu = spls*DF;
    elseif strcmp(obj.FrequencyResolutionMethod,'WindowLength')
      % We do not have to wait for the object to be locked to know the
      % value.
      SL = obj.WindowLength;
      ispu =  SL - getNumOverlapSamples(obj,SL);  
    else
      ispu = [];
    end
  end
  %------------------------------------------------------------------------
  function value = getNumOverlapSamples(obj,SL)
    
    if nargin == 1
      SL = obj.pSegmentLength;
    end
    OP = obj.OverlapPercent;
    numSamples = SL*OP/100;
    upperNumSamples = ceil(numSamples);
    lowerNumSamples = floor(numSamples);
    percentDiff1 = abs((upperNumSamples*100/SL)-OP);
    percentDiff2 = abs((lowerNumSamples*100/SL)-OP);
    if percentDiff1 < percentDiff2
      value = upperNumSamples;
    else
      value = lowerNumSamples;
    end
    if (value == SL)
      % If the number of overlap samples is equal to the segment length,
      % the buffer sets the number of overlap samples to SL-1
      value = SL - 1;
    end
end  
  % -----------------------------------------------------------------  
  function fv = getFrequencyVector(obj)
    fv = [];
    if isLocked(obj)
      fv = obj.pFreqVect;
    end
  end
 
  % -----------------------------------------------------------------
  function setNumChan(obj,L)
     obj.pNumChannels = L;
     obj.DataBuffer.NumChannels = L;
     obj.sSegmentBuffer.NumChannels = L;
  end
  % -----------------------------------------------------------------  
  function updateBuffer(obj)
      processTunedPropertiesImpl(obj);
  end   
end
%--------------------------------------------------------------------------
% Protected methods
%--------------------------------------------------------------------------
methods(Access=protected)
  function num = getNumInputsImpl(obj)  %#ok<*MANU>
    num = 1;
  end
  %------------------------------------------------------------------------  
  function num = getNumOutputsImpl(obj) 
    num = 4;
  end  
  %------------------------------------------------------------------------
  function flag = isInputComplexityLockedImpl(~, ~)
    flag = false;
  end
   %------------------------------------------------------------------------    
  function validateInputsImpl(~, x)
    if isempty(x)
      matlab.system.internal.error(...
        'MATLAB:system:inputMustBeMatrix','X');
    end    
  end
  %------------------------------------------------------------------------    
  function setupImpl(obj, x)
    %setupImpl Setup private properties and contained objects
    try
      obj.pInputFrameLength = size(x,1);
    catch %#ok<CTCH>
    end

    thisSetup(obj);          
        
    syncOldProperties(obj);
    
    % Set the pIsLockedFlag to indicate that System object is about to be
    % locked. 
    obj.pIsLockedFlag = true;
        
  end  
      %------------------------------------------------------------------------  
  function thisSetup(obj)
  % The setup and set methods must be called in the right order or some
  % private properties used in a method might not be set to the correct
  % value
       
    % Setup DDC function handle and object, also setup the frame input
    % buffer. setupDDC will set the pActualSampleRate property according to
    % the decimation factor. 
    setupDDC(obj);    
    
    % Set spectrum type
    setSpectrumSidedType(obj);       
    
    % Compute segment length and window data and store in pSegmentLength
    % and pWindowData properties
    setWindow(obj);
            
    % Set the NFFT value and store it in pNFFT property
    setNFFT(obj);  
        
    obj.pActualFstart = getFstart(obj);
    obj.pActualFstop = getFstop(obj);
    
    computeFrequencyVector(obj);    
  end
  %------------------------------------------------------------------------    
  function processTunedPropertiesImpl(obj)
      
    % If Span or RBW changes we need to setup the object again and reset
    if checkChangedProp(obj,'FrequencySpan') || ...
        checkChangedProp(obj,'Span') || ...       
        checkChangedProp(obj,'CenterFrequency') || ...
        checkChangedProp(obj,'StartFrequency') || ...
        checkChangedProp(obj,'StopFrequency') || ...        
        checkChangedProp(obj,'RBWSource') || ...
        checkChangedProp(obj,'RBW') || ...
        checkChangedProp(obj,'WindowLength') || ...
        checkChangedProp(obj,'OverlapPercent') || ...
        checkChangedProp(obj,'ChannelMode') || ...
        checkChangedProp(obj,'ChannelNumber') ||...
        checkChangedProp(obj,'FrequencyResolutionMethod');        
            
      thisSetup(obj);      
      reset(obj); % call reset after setup 
      syncOldProperties(obj);
      
      % If we entered this condition, then whatever other properties
      % changed will be taken care of in the thisSetup method.
      return;
    end      
      
    if strcmp(obj.ChannelMode,'All')
      nChan = obj.pNumChannels;
    else
      nChan = 1;
    end
    
    % If Window changes we need to update the segment length, the
    % segment length buffer, and pNFFT. We need to clear the
    % pPeriodogramMatrix. We need to recompute the frequency vector. 
    if checkChangedProp(obj,'Window') || ...
       checkChangedProp(obj,'SidelobeAttenuation') 
     
      setWindow(obj);
      setNFFT(obj);
      computeFrequencyVector(obj);
      reset(obj);
    end                  
        
    % If Spectral averages changes, we need to update the
    % pPeriodogramMatrix                
    cachedOldValue = obj.pSpectralAveragesOld;
    if checkChangedProp(obj,'SpectralAverages')
      % Shift columns of pPeriodogramMatrix to leave them in order from
      % oldest to newest periodogram
      obj.pPeriodogramMatrix = circshift(obj.pPeriodogramMatrix,...
        [0 cachedOldValue-obj.pNewPeriodogramIdx]);      
      
      if cachedOldValue > obj.SpectralAverages
        %Reduced averages - remove oldest periodogram columns        
        obj.pPeriodogramMatrix = ...
          obj.pPeriodogramMatrix(:,end-obj.SpectralAverages+1:end,:);
        
         obj.pNewPeriodogramIdx = 0;
      else
        extraCols = obj.SpectralAverages - cachedOldValue;

        obj.pNewPeriodogramIdx = cachedOldValue;
        
        % Add all zero colums
        obj.pPeriodogramMatrix = ...
          [obj.pPeriodogramMatrix zeros(obj.pNFFT,extraCols,nChan)];
      end
    end
    
    % If FFTLength changes, we need to check that the new value is valid
    % and then we need to resize the pPeriodogramMatrix and max/min hold
    % vectors. We also need to recompute the frequency vector. 
    if checkChangedProp(obj,'FFTLengthSource') || ...
       checkChangedProp(obj,'FFTLength')
     
      setNFFT(obj);   
      obj.pPeriodogramMatrix = zeros(obj.pNFFT,obj.SpectralAverages,nChan);
      
      obj.pNewPeriodogramIdx = 0;      
      obj.pNumAvgsCounter = 0;
      
      % Need to call computeFrequencyVector before resetMaxMinHoldStates so
      % that the dimensions of the max min hold states are correct. 
      computeFrequencyVector(obj);
      resetMaxMinHoldStates(obj);
            
    end
    
    % If MAX/MIN hold change, we need to clear pMaxHoldPSD and
    % pMinHoldPSD
    if checkChangedProp(obj,'MaxHoldTrace')
      resetMaxMinHoldStates(obj,'MaxHoldTrace')         
    end
    if checkChangedProp(obj,'MinHoldTrace')
      resetMaxMinHoldStates(obj,'MinHoldTrace') 
    end        
  end
  
  
  function [PSD,PSDMaxHold,PSDMinHold,F] = stepImpl(obj, x) 
    PSD = [];
    PSDMaxHold = [];
    PSDMinHold = [];   
    F = [];

    % If the DDC is not enabled, then we pass the data through a 'no action
    % function' since the input data has already been buffered at the
    % source with the DataBuffer object. If the DDC is enabled, then the
    % input data has been buffered by the DataBuffer so that the frame size
    % is compatible with the DDC decimation factor value and to guarantee
    % that the segment length buffer will output at least one complete
    % segment length at once. In this case, pass the data through the DDC
    % and the segment length buffer. 
    [s1, isDataReady] = obj.pInputProcessingFunction(obj,double(x));        
             
    % Compute PSD when we have enough data to obtain a spectral estimate
    if isDataReady
      % Compute PSD
      [PSD,PSDMaxHold,PSDMinHold,F] = computePSD(obj,s1);
    end
    
  end
  %------------------------------------------------------------------------      
  function resetImpl(obj)
      
      % Initialize matrix containing past periodograms
      if strcmp(obj.ChannelMode,'All')
        nChan = obj.pNumChannels;
      else
        nChan = 1;
      end
      obj.pPeriodogramMatrix = ...
          zeros(obj.pNFFT,obj.SpectralAverages,nChan);
      
      % Initialize num averages counter
      obj.pNumAvgsCounter = 0;
      
      % Periodogram index
      obj.pNewPeriodogramIdx = 0;
      
      % Initialize max/min hold vectors
      resetMaxMinHoldStates(obj);
      
      reset(obj.sDDC);
      
      % Reset contained buffer
      % NOTE: Databuffer is not owned by this object and is not flushed here
      flush(obj.sSegmentBuffer);
    
  end
  %------------------------------------------------------------------------      
  function releaseImpl(obj)
    % Release contained objects
    % NOTE: Databuffer is not owned by this object and is not flushed here
    flush(obj.sSegmentBuffer);
    release(obj.sDDC); 
    obj.pIsLockedFlag = false;
  end  
end
%--------------------------------------------------------------------------
% Private methods
%--------------------------------------------------------------------------
methods (Access = private)
      
  function   calculateSegmentLength(obj)
    % Get segment length corresponding to specified RBW.
    actualSampleRate = obj.SampleRate;
    if strcmp(obj.FrequencyResolutionMethod,'RBW')
      actualSampleRate = obj.pActualSampleRate;
      desiredRBW = getRBW(obj);
      
      % Segment length will depend on ENBW (which in turns depends on segment
      % length). Thus, an initial ENBW is obtained using a segment length of
      % 1000
      ENBW = getENBW(obj,1000);
      % Compute segment length
      segLen = ceil(ENBW*obj.pActualSampleRate/getRBW(obj));
      
      % Iterate over segment length to minimize
      % error between requested RBW and actual RBW:
      count = 1;
      segLenVect = segLen;
      while(count<100) % protect against very long convergence
        new_segLen = ceil(getENBW(obj,ceil(segLen)) * actualSampleRate/ desiredRBW);
        err = abs(new_segLen - segLen);
        if (err == 0) % we have converged
          segLen = new_segLen;
          break;
        end
        if ~any(segLenVect == new_segLen)
          segLenVect = [ segLenVect new_segLen];
          segLen = new_segLen;
          count = count + 1;
        else
          % We hit a previously computed segment length. The sequence
          % will repeat. Break out and select the segment length that
          % minimizes the error
          L = length(segLenVect);
          computed_RBW = zeros(L,1);
          for ind=1:L
            % Get RBW corresponding to segLenVect(ind)
            computed_RBW(ind) = getENBW(obj,segLenVect(ind)) * actualSampleRate / segLenVect(ind);
          end
          % Select segment length that minimizes absolute error between
          % actual and desired RBW:
          RBWErr = abs(desiredRBW -  computed_RBW);
          [~,ind_min] = min(RBWErr);
          segLen = segLenVect(ind_min);
          break;
        end
      end
    else
      % Window length is directly specified
      segLen = obj.WindowLength;
    end
    obj.pSegmentLength = segLen;
    obj.ActualRBW      =  getENBW(obj,segLen) * actualSampleRate/ segLen;
  end
  %------------------------------------------------------------------------
  function setWindow(obj)
    %setWindow Compute segment length and window data
    
    % Set segment length:
    calculateSegmentLength(obj);
    
    %Get equivalent noise bandwidth of current window    
    [~, winFcn, winParam] = getENBW(obj,obj.pSegmentLength);
    if isempty(winParam)
      obj.pWindowData = window(winFcn,obj.pSegmentLength);
    else
      obj.pWindowData = window(winFcn,obj.pSegmentLength,winParam);
    end    
    
    % Compute window power and store it in pWindowData property
    obj.pWindowPower = obj.pWindowData.'*obj.pWindowData;
    
    % Setup a buffer with required segment length
    setupSegmentBuffer(obj);                       
  end
  %------------------------------------------------------------------------  
  function [ENBW, winFcn, winParam] = getENBW(obj,L, Win, sideLobeAttn)
  % Get window parameters based on a segment legnth L
  
    if nargin < 3
      Win  = obj.Window;
    end
  
    if isempty(L)
    % Segment length not computed yet
       L = 1000; 
    end
      
    winParam = [];
    switch Win
      case 'Rectangular'
        ENBW = 1;
        winFcn = @rectwin;
      case 'Hann'
        w = hann(L,'periodic');
        ENBW = (sum(w.^2)/sum(w)^2)*L;    
        winFcn = @(x) hann(x,'periodic');
      case 'Hamming'
        w = hamming(L,'periodic');
        ENBW = (sum(w.^2)/sum(w)^2)*L;    
        winFcn = @(x) hamming(x,'periodic');
      case 'Flat Top'        
        w = flattopwin(L,'periodic');
        ENBW = (sum(w.^2)/sum(w)^2)*L; 
        winFcn = @(x) flattopwin(x,'periodic');
      case 'Chebyshev'
        if nargin < 4
          SLA = obj.SidelobeAttenuation;
        else
          SLA = sideLobeAttn;
        end
        w = chebwin(L,SLA);
        ENBW = (sum(w.^2)/sum(w)^2)*L;
        winFcn = @chebwin;
        winParam = SLA;
      case 'Kaiser'
        if nargin < 4
          SLA = obj.SidelobeAttenuation;
        else
          SLA = sideLobeAttn;
        end
        if SLA > 50
          winParam = 0.1102*(SLA-8.7);
        elseif SLA < 21
          winParam = 0;
        else
          winParam = (0.5842*(SLA-21)^0.4) + 0.07886*(SLA-21);
        end
        w = kaiser(L,winParam);
        ENBW = (sum(w.^2)/sum(w)^2)*L;   
        winFcn = @kaiser;              
    end    
end  
  %------------------------------------------------------------------------
  function setupSegmentBuffer(obj)
    %setupSegmentBuffer Setup segment length buffer

    % If DDC is not enabled, then the data buffer at the Source will act
    % as the segment length buffer, otherwise, the data buffer at the
    % Source will act as the input frame buffer (to get input frame sizes
    % compatible with the DDC) and the contained sSegmentBuffer object
    % will act as the segment length buffer.
    
    if obj.pIsDownSamplerEnabled
      % Set contained buffer sSegmentBuffer to act as a segment length
      % buffer. Set the DataBuffer to act as an input frame buffer that
      % outputs input frames with sizes compatible with DDC decimation
      % factor value. 
      obj.sSegmentBuffer.SegmentLength = obj.pSegmentLength;
      obj.sSegmentBuffer.OverlapPercent = obj.OverlapPercent;
      
     % Setup the DataBuffer to be an input frame buffer to make frames of
      % size that is a multiple of the decimation factor. This is a
      % requirement for the DDC inputs.

      % required input length to DDC
      DF = 1;
      if obj.pIsDownSamplerEnabled
        DF = prod(obj.sDDC.DecimationFactor);        
      end
      inputFrameLength = (obj.pSegmentLength - getNumOverlapSamples(obj))*DF;       
      
      currentSegLen = obj.DataBuffer.SegmentLength;
      newSegLen = max(inputFrameLength,DF);
      obj.DataBuffer.SegmentLength = newSegLen;
      if (newSegLen ~= currentSegLen)
         release(obj.sDDC); 
      end
      obj.DataBuffer.OverlapPercent = 0;
    else
      % Set DataBuffer to act as a segment length buffer
      
      obj.DataBuffer.SegmentLength = obj.pSegmentLength;
      obj.DataBuffer.OverlapPercent = obj.OverlapPercent;                              
    end
  end
  %------------------------------------------------------------------------
  function setupDDC(obj)
    %setupDDC Setup DDC object according to current span and center
    %frequency settings
    
    obj.pInputProcessingFunction = @dsp.private.SpectralEstimator.noAction;
    
    obj.pIsDownSamplerEnabled = false; % True if we downsample with the DDC   
    obj.pIsDownConverterEnabled = false; % True if oscillator is on
    obj.pActualSampleRate = obj.SampleRate; % Will change if we down sample       
        
    if strcmp(obj.FrequencySpan,'Full') || ~obj.DigitalDownConvert || ...
        strcmp(obj.FrequencyResolutionMethod,'WindowLength')
      % Do not down convert when working in full span or in window length
      % mode
      return;
    end
    
    % Actual sample rate over RBW cannot be smaller than L or we will have
    % very short segment lengths. Se we need to check that we do not
    % decimate more than what is possible. 
    L = 256;
    maximumDF = floor(obj.SampleRate/(L*getRBW(obj)));
            
    % Down sample if we at least achieve a down sample factor of 4.
    % Frequency down convert only if we achieve at least a gain of G on the
    % possible down conversion factor. Otherwise, just down convert.     
    G = 16;
    percentBW = 0.85;
    
    % BW and decimation factor without frequency down conversion
    BWNoDC = 2*max(abs(getFstart(obj)),abs(getFstop(obj)));
    % Compute possible decimation factor based on a filter with 85%
    % bandwidth with respect to cutoff frequency. Choose a decimation
    % factor that is no greater than maximumDF.
    DFNoDownConversion = min(maximumDF,floor(percentBW*obj.SampleRate/BWNoDC)); 
    
    % BW and decimation factor with frequency down conversion
    BWDC = getSpan(obj);
    % Choose a decimation factor that is no greater than maximumDF.
    DFWithDownConversion = min(maximumDF,floor(percentBW*obj.SampleRate/BWDC));
    
    DFRatio = DFWithDownConversion/DFNoDownConversion;
                               
    ddcEnabledFlag = false;
    % Available DF on predesigned filters
    availableDF = cell2mat(keys(obj.pDDCCoeffs));    
    
    % Case 1 - Frequency down conversion and down sampling are justified
    if DFWithDownConversion >= 4 && (DFRatio > G || DFNoDownConversion < 4)            
      ddcEnabledFlag = true;
      obj.pIsDownSamplerEnabled = true;
      obj.pIsDownConverterEnabled = true;
      
      DF = availableDF(availableDF <= DFWithDownConversion);
      DF = DF(end);                              
      
      release(obj.sDDC)
      obj.sDDC.Oscillator = 'Sine wave';
      obj.sDDC.CenterFrequency = getCenterFrequency(obj);

    % Case 2 - Only down sampling is justified       
    elseif DFNoDownConversion >=4
      ddcEnabledFlag = true;
      obj.pIsDownSamplerEnabled = true;
      
      DF = availableDF(availableDF <= DFNoDownConversion);
      DF = DF(end);                              
                 
      release(obj.sDDC)
      obj.sDDC.Oscillator = 'None';
           
    % Case 3 - No down conversion or down sampling is justified  
    end       
    
    if ddcEnabledFlag
                  
      % Set the sample rate and coefficients on the DDC       
      obj.sDDC.SampleRate = obj.SampleRate;
      
      % Get the structure containing the filter coefficients from the
      % containers.Map held in the pDDCCoeffs property
      s = obj.pDDCCoeffs(DF);
      obj.sDDC.DecimationFactor = s.decimFactors;
      obj.sDDC.NumCICSections = s.numCICSections;
      obj.sDDC.SecondFilterCoefficients = s.secondStageCoeffs;
      if length(s.decimFactors) == 3
        obj.sDDC.ThirdFilterCoefficients = s.thirdStageCoeffs;
      end      
      
      obj.pActualSampleRate = obj.SampleRate/DF;
      
      obj.pInputProcessingFunction = ...
        @dsp.private.SpectralEstimator.DDCAndBuffer;          
    end 
  end
  %------------------------------------------------------------------------
  function setNFFT(obj)
    %setNFFT Compute FFT length and store it in pNFFT property
    if strcmp(obj.FrequencyResolutionMethod,'WindowLength')
      if strcmp(obj.FFTLengthSource,'Auto')
        obj.pNFFT = max(obj.pSegmentLength,1024);
      else
        obj.pNFFT = obj.FFTLength;
      end
    else
      obj.pNFFT = obj.pSegmentLength;
    end
    obj.pDataWrapFlag = obj.pNFFT < obj.pSegmentLength;
  end
  %------------------------------------------------------------------------  
  function setSpectrumSidedType(obj)
    % setSpectrumSidedType Set spectrum type to 'onesided' or 'twosided'
    if obj.pIsDownConverterEnabled 
      % If we are using frequency down conversion then use two-sided
      % spectrum computations regardless of the user settings. Later on,
      % the final spectral estimate will be scaled by two if the user
      % setting was one sided.
      obj.pIsCurrentSpectrumTwoSided = true;
    elseif obj.TwoSidedSpectrum
      obj.pIsCurrentSpectrumTwoSided = true;
    else
      obj.pIsCurrentSpectrumTwoSided = false;      
    end
  end  
  %------------------------------------------------------------------------    
  function computeFrequencyVector(obj)
    %computeFrequencyVector Compute frequency vector for the current PSD
        
    % If spectrum computation is two sided then range is 'whole', otherwise
    % range is 'half'
    range = 'half';
    if obj.pIsCurrentSpectrumTwoSided 
      range = 'whole';
    end          
    
    % Compute one or two sided, dc-centered frequency vector
    obj.pFreqVect = psdfreqvec('npts',obj.pNFFT,'Fs',obj.pActualSampleRate,...
      'Range',range,'CenterDC',obj.pIsCurrentSpectrumTwoSided );
    
    % If we are doing frequency down conversion, then shift F to center
    % frequency
    if obj.pIsDownConverterEnabled
      obj.pFreqVect = obj.pFreqVect + getCenterFrequency(obj);          
    end    
        
    % Trim frequency vector to exact span
    obj.pIdxFreqVect = obj.pFreqVect>=getFstart(obj) & ...
      obj.pFreqVect<=getFstop(obj);
    obj.pFreqVect = obj.pFreqVect(obj.pIdxFreqVect);
    
    obj.pFreqVectLength = size(obj.pFreqVect,1);
    
  end
  %------------------------------------------------------------------------  
  function [PSD, PSDMaxHold, PSDMinHold, Fout] = computePSD(obj,x)        
    %computePSD Compute the power spectral density of matrix x that
    %contains columns of overlapped segments. The third dimension of x is
    %the channels dimension.
    
    if strcmp(obj.ChannelMode,'Single')
      x = x(:,:,obj.ChannelNumber);
    end
    
    if obj.ReduceUpdates
        % Reduced rate - one PSD returned
        [PSD, PSDMaxHold, PSDMinHold, Fout] = computePSDReducedRate(obj,x);
    else
        % Normal rate - one PSD per segment returned
        [PSD, PSDMaxHold, PSDMinHold, Fout] = computePSDNormalRate(obj,x); 
    end
  end
  %------------------------------------------------------------------------
  function [PSD, PSDMaxHold, PSDMinHold, Fout] = computePSDReducedRate(obj,x)    
    
      if ~obj.MaxHoldTrace && ~obj.MinHoldTrace
          % Remove segments in excess of running average since we only plot the
          % last running average
          numSegs = size(x,2);
          spectralAverages = obj.SpectralAverages;
          if numSegs > spectralAverages
              x = x(:,end-spectralAverages+1:end,:);
              Pall = computePeriodogram(obj,x);
              obj.pNumAvgsCounter = spectralAverages;
          else
              % append stored periodograms
              Pall = computePeriodogram(obj,x);
              Pall = [obj.pPeriodogramMatrix(:,numSegs+1:end,:) Pall];
              obj.pNumAvgsCounter = min(spectralAverages,obj.pNumAvgsCounter  + numSegs);
          end
          Pxx  = sum(Pall,2)/obj.pNumAvgsCounter;
          PSD = convertAndScale(obj,Pxx);
          Fout = obj.pFreqVect;
          PSDMaxHold = [];
          PSDMinHold = [];
          % update store periodgrams for next time:
          obj.pPeriodogramMatrix = Pall;
      else
          numSegs = size(x,2);
          Pall = computePeriodogram(obj,x);
          for i=1:numSegs
              
              % Do running average with previous numAverage values
              % Do not include initial zero columns on the averages
              obj.pNumAvgsCounter = min(obj.pNumAvgsCounter+1,obj.SpectralAverages);
              obj.pNewPeriodogramIdx =  max(1,mod(obj.pNewPeriodogramIdx+1,obj.SpectralAverages+1));
              
              % Remove oldest periodogram, add newest one for each channel.
              % pPeriodogramMatrix contains as many columns as the specified number
              % of spectral averages. The third dimension is the channels dimension.
              obj.pPeriodogramMatrix(:,obj.pNewPeriodogramIdx,:) = Pall(:,i,:);
              
              Pxx(:,:) = sum(obj.pPeriodogramMatrix,2)/obj.pNumAvgsCounter;
              
              %--------------------
              % Convert to one sided (if needed), center DC (if needed) and scale
              % with respect to Fs to obtain final PSD
              PSD = convertAndScale(obj,Pxx);
              
              %--------------------
              % Get max/min hold spectrum. Max/min hold values are obtained from the
              % running average values in PSD.
              if obj.MaxHoldTrace
                  obj.pMaxHoldPSD = max(obj.pMaxHoldPSD, PSD);
              end
              if obj.MinHoldTrace
                  obj.pMinHoldPSD = min(obj.pMinHoldPSD, PSD); 
              end
          end
          PSDMaxHold  = obj.pMaxHoldPSD;
          PSDMinHold  = obj.pMinHoldPSD;
          Fout = obj.pFreqVect;
      end
  end

  function [PSD, PSDMaxHold, PSDMinHold, Fout] = computePSDNormalRate(obj,x)          

    %--------------------
    % Compute periodograms of all the segments and all channels
        
    Pall = computePeriodogram(obj,x);
    [~,numSegs,numChan] = size(Pall);
    segLen = obj.pFreqVectLength;
    PSD = zeros(segLen,numSegs,numChan);
    PSDMaxHold = zeros(segLen,numSegs,numChan);
    PSDMinHold = zeros(segLen,numSegs,numChan);
    
    %--------------------
    % Running average of periodograms - Pxx is a matrix with columns as
    % channels
    
    for i=1:numSegs

        % Do running average with previous numAverage values
        % Do not include initial zero columns on the averages
        obj.pNumAvgsCounter = min(obj.pNumAvgsCounter+1,obj.SpectralAverages);
        obj.pNewPeriodogramIdx =  max(1,mod(obj.pNewPeriodogramIdx+1,obj.SpectralAverages+1));
        
        % Remove oldest periodogram, add newest one for each channel.
        % pPeriodogramMatrix contains as many columns as the specified number
        % of spectral averages. The third dimension is the channels dimension.
        obj.pPeriodogramMatrix(:,obj.pNewPeriodogramIdx,:) = Pall(:,i,:);
        
        Pxx(:,:) = sum(obj.pPeriodogramMatrix,2)/obj.pNumAvgsCounter;
        
        %--------------------
        % Convert to one sided (if needed), center DC (if needed) and scale
        % with respect to Fs to obtain final PSD
        PSD(:,i,:) = convertAndScale(obj,Pxx);
        
        %--------------------
        % Get max/min hold spectrum. Max/min hold values are obtained from the
        % running average values in PSD.
        if obj.MaxHoldTrace
            obj.pMaxHoldPSD = max(obj.pMaxHoldPSD, squeeze(PSD(:,i,:)));
            PSDMaxHold(:,i,:)  = obj.pMaxHoldPSD;
        end
        if obj.MinHoldTrace
            obj.pMinHoldPSD = min(obj.pMinHoldPSD, squeeze(PSD(:,i,:)));
            PSDMinHold(:,i,:)  = obj.pMinHoldPSD;
        end
    end
    
    Fout = obj.pFreqVect; 
    
  end
  %------------------------------------------------------------------------  
  function P = computePeriodogram(obj,x)
    % Window the data
    x = bsxfun(@times,x,obj.pWindowData);  
    if obj.pDataWrapFlag
      % If NFFT is smaller than segment length we need to wrap the data
      x = wrapData(obj,x);
    end
    % Compute fft
    X = fft(x,obj.pNFFT,1);
    % Compute power spectrum
    P = X.*conj(X)/obj.pWindowPower;
  end

  %------------------------------------------------------------------------
  function Pos = computeOneSidedSpectrum(obj,P)
    
    nfft = obj.pNFFT;
    
    if rem(nfft,2),
      select = 1:(nfft+1)/2;  % ODD
      Pos_unscaled = P(select,:); % Take only [0,pi] or [0,pi)
      % Don't double DC
      Pos = [Pos_unscaled(1,:); 2*Pos_unscaled(2:end,:)];
    else
      select = 1:nfft/2+1;    % EVEN
      Pos_unscaled = P(select,:); % Take only [0,pi] or [0,pi)
      % Don't double unique Nyquist point
      Pos = [Pos_unscaled(1,:); 2*Pos_unscaled(2:end-1,:); Pos_unscaled(end,:)];
    end   
  end
  %------------------------------------------------------------------------
  function  P = convertAndScale(obj,P)
    %convertAndScale Convert to one sided and center DC if needed, scale by
    %Fs to convert to density

    scaleFlag = false;
    
    if ~obj.TwoSidedSpectrum && ~obj.pIsDownConverterEnabled
      % If user specified one sided spectrum and we did not do frequency
      % down conversion we need to call computeOneSidedSpectrum to fold
      % power values
      P = computeOneSidedSpectrum(obj,P);
      
    elseif ~obj.TwoSidedSpectrum && obj.pIsDownConverterEnabled
      % If user specified one sided spectrum and we did frequency down
      % conversion, then the signal power is already doubled due to the
      % oscillator but we need to make sure we do not double DC or Nyquist
      % frequencies
      
      scaleFlag = true;
      
    elseif obj.TwoSidedSpectrum && obj.pIsDownConverterEnabled
      % If user specified two sided spectrum and we did frequency down
      % conversion we need to remove oscillator power from the spectrum
      P = 0.5*P;
      
      % If user specified two sided spectrum and we did not do frequency
      % down conversion we do not need to do anything
    end                         
    
    % Center DC
    if obj.pIsCurrentSpectrumTwoSided
      P = centerDC(obj,P);
    end
     
    % Scale with respect to Fs to convert to PSD
    P = P/obj.pActualSampleRate;
    
    % Trim PSD to exact span
    P = P(obj.pIdxFreqVect,:);    
    if scaleFlag && obj.pActualFstart==0
      P(1) = P(1)*0.5;
    end
    if scaleFlag && obj.pActualFstop==obj.SampleRate/2
      P(end) = P(end)*0.5;
    end    
  end
  %------------------------------------------------------------------------
  function Pdc = centerDC(~,P)
    % Convert to plot + and - frequencies.
    
    nfft = size(P,1);
    
    Pdc = fftshift(P,1);  % Places the Nyquist freq on the negative side.
    
    % Determine half the number of FFT points.
    if ~rem(nfft,2),
      % Move the Nyquist point to the right-hand side (pos freq) to be
      % consistent with plot when looking at the positive half only.
      Pdc = [Pdc(2:end,:); Pdc(1,:)];
    end    
  end  
  %------------------------------------------------------------------------  
  function flag = checkChangedProp(obj,prop)
    flag = ~isequal(obj.(prop),obj.(['p' prop 'Old']));
    obj.(['p' prop 'Old']) = obj.(prop);        
  end
  %------------------------------------------------------------------------  
  function syncOldProperties(obj)
    obj.pFrequencySpanOld = obj.FrequencySpan;
    obj.pSpanOld = obj.Span;
    obj.pCenterFrequencyOld = obj.CenterFrequency;
    obj.pStartFrequencyOld = obj.StartFrequency;
    obj.pStopFrequencyOld = obj.StopFrequency;    
    obj.pRBWSourceOld = obj.RBWSource;
    obj.pRBWOld = obj.RBW;
    obj.pWindowOld = obj.Window;
    obj.pSidelobeAttenuationOld = obj.SidelobeAttenuation;
    obj.pSpectralAveragesOld = obj.SpectralAverages;
    obj.pFFTLengthSourceOld = obj.FFTLengthSource;
    obj.pFFTLengthOld = obj.FFTLength;
    obj.pMaxHoldTraceOld = obj.MaxHoldTrace;
    obj.pMinHoldTraceOld = obj.MinHoldTrace;
    obj.pOverlapPercentOld = obj.OverlapPercent;
    obj.pChannelModeOld = obj.ChannelMode;
    obj.pChannelNumberOld = obj.ChannelNumber;
    obj.pWindowLengthOld = obj.WindowLength;
    obj.pFrequencyResolutionMethodOld = obj.FrequencyResolutionMethod;
  end 
  %------------------------------------------------------------------------
  function resetMaxMinHoldStates(obj,type)    
    
      if strcmp(obj.ChannelMode,'All')
        nChan = obj.pNumChannels;
      else
        nChan = 1;
      end
        
    if nargin == 1
      obj.pMaxHoldPSD = -inf*ones(obj.pFreqVectLength,nChan);
      obj.pMinHoldPSD = inf*ones(obj.pFreqVectLength,nChan);   
    elseif strcmp(type,'MaxHoldTrace')
      obj.pMaxHoldPSD = -inf*ones(obj.pFreqVectLength,nChan);
    elseif strcmp(type,'MinHoldTrace')
      obj.pMinHoldPSD = inf*ones(obj.pFreqVectLength,nChan);   
    end
  end
  %------------------------------------------------------------------------    
  function xout = wrapData(obj,xin)
    
    [nrows, ncols, n3d] = size(xin); 
    
    fact = ceil(nrows/obj.pNFFT);
    extraZeros = obj.pNFFT*fact - nrows;
              
    xin = [xin ; zeros(extraZeros,ncols,n3d)];
    xin = reshape(xin,obj.pNFFT,ncols*fact,n3d);
    
    xout = zeros(obj.pNFFT,ncols,n3d);
    
    for idx = 1:ncols
      xout(:,idx,:) = sum(xin(:,(idx-1)*fact+1:idx*fact,:),2);
    end
    
  end
end
%--------------------------------------------------------------------------
% Public hidden methods
%--------------------------------------------------------------------------
methods (Hidden)
  function RBW = getActualRBW(obj)
      % Get the actual RBW. The actual RBW might deviate from the specified 
      % RBW. 
      % The actual RBW is given by:
      % RBW =  K(L) * Fs/ L, where L is the segment length and K is the
      % window constant (which depends on the segment length). Each segment
      % length is associated with a unique RBW value (for a specific
      % window). Therefore, not any specified RBW can be modeled with no
      % error. The segment length yielding the RBW closest to the specified
      % RBW is selected. 
      % When FrequencyResolution mode is 'WindowLength' we compute the RBW
      % directly from this value. 
      RBW = obj.ActualRBW;
  end
end
%--------------------------------------------------------------------------
% Static hidden methods
%--------------------------------------------------------------------------
methods (Static, Hidden)
  %------------------------------------------------------------------------
  function [dataOut, isDataReady] = noAction(~,dataIn)
    dataOut = dataIn;
    isDataReady = true;
  end
  
  function [dataOut, isDataReady] = DDCAndBuffer(obj,dataIn)
    dataOut = [];
    isDataReady = false;
    
    % dataIn might have more than one column (each one a frame that can be
    % downconverted) so make sure all the columns are processed.
    for idx = 1:size(dataIn,2)       
      
      s1In(1:size(dataIn,1),:) = dataIn(:,idx,:);
      
      % Pass data through DDC
      s2 = step(obj.sDDC,s1In);      
      
      % Buffer s2 to get segment lengths for Welch estimation. Output s3
      % contains one matrix of segments per channel.           
      addValue(obj.sSegmentBuffer,s2);
      s3= [];
      isDataReadyTmp = IsReady(obj.sSegmentBuffer);
      if isDataReadyTmp
         s3 = obj.sSegmentBuffer.getSegments;
         obj.sSegmentBuffer.clear;
      end
      dataOut = [dataOut s3]; %#ok<*AGROW>
      
      isDataReady = isDataReady || isDataReadyTmp;
      
    end   
  end
%   %------------------------------------------------------------------------  
%   function [dataOut, isDataReady] = noBuffuerInput(~,dataIn)
%     % Re dimension so channels are in the third dimension of the matrix
%     dataOut(:,1,1:size(dataIn,2)) = dataIn;
%     isDataReady = true;
%   end
end
end % End of class definition

