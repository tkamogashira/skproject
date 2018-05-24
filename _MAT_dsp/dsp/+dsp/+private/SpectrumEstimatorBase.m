classdef SpectrumEstimatorBase < matlab.System
%SpectrumEstimatorBase Abstract base class for spectrum estimation
%   dsp.spectrumEstimator and dsp.CrossSpectrumEstimator inherit from this 
%   base class.  

        %   Copyright 2013 The MathWorks, Inc.

%#codegen
%#ok<*EMCLS>

properties (Nontunable)
  %SampleRate Sample rate of input
  %   Specify the sample rate of the input in Hertz as a finite numeric
  %   scalar. The default is 1 Hz.
  SampleRate = 1;
end
       
properties (Nontunable)
  %SpectralAverages Number of spectral averages
  %   Specify the number of spectral averages as a positive, integer
  %   scalar. The Spectrum Estimator computes the current power spectrum
  %   estimate by averaging the last N power spectrum estimates, where N is
  %   the number of spectral averages defined in the SpectralAverages
  %   property. The default is 8.
  SpectralAverages = 8;
  %FFTLengthSource Source of the FFT length value
  %   Specify the source of the FFT length value as one of 'Auto' |
  %   'Property'. The default is 'Auto'. When you set this property to
  %   'Auto' the Spectrum Estimator sets the FFT length to the input frame
  %   size. When you set this property to 'Property' then you specify the 
  %   number of FFT points using the FFTLength property.
  FFTLengthSource = 'Auto';
  %FFTLength FFT length
  %   Specify the length of the FFT that the Spectrum Estimator uses to
  %   compute spectral estimates as a positive, integer scalar. This
  %   property applies when you set the FFTLengthSource property to
  %   'Property'. The default is 128.
  FFTLength = 128;
  %Window Window function
  %   Specify a window function for the spectral estimator as one of
  %   'Rectangular' | 'Chebyshev' | 'Flat Top' | 'Hamming' | 'Hann' |
  %   'Kaiser'. The default is 'Hann'.
  Window = 'Hann';
  %SidelobeAttenuation Sidelobe attenuation of window
  %   Specify the sidelobe attenuation of the window as a real, positive
  %   scalar in decibels (dB). This property applies when you set the 
  %   Window property to 'Chebyshev' or 'Kaiser'. The default is 60 dB.
  SidelobeAttenuation = 60;
  % FrequencyRange Frequency range of the spectrum estimate
  %   Specify the frequency range of the spectrum estimator as one 
  %   of 'twosided' | 'onesided' | 'centered'. 
  %   If you set the FrequencyRange to 'onesided', the spectrum estimator 
  %   computes the one-sided spectrum of real input signals. When the FFT 
  %   length, NFFT, is even, the spectrum estimate length is NFFT/2+1 and 
  %   is computed over the interval [0,SampleRate/2]. If NFFT is odd, the 
  %   length of the spectrum estimate is equal to (NFFT+1)/2 and the 
  %   interval is [0,SampleRate/2).
  %   If you set the FrequencyRange to 'twosided', the spectrum estimate
  %   computes the two-sided spectrum of complex or real inputs signals. 
  %   The length of the spectrum estimate is equal to NFFT and is computed 
  %   over [0, SampleRate). 
  %   If you set the FrequencyRange to 'centered', the spectrum estimate 
  %   computes the centered two-sided spectrum of complex or real 
  %   input signals. The length of the spectrum estimate is equal to NFFT 
  %   and is computed over (-SampleRate/2, SampleRate/2] and 
  %   (-SampleRate/2, SampleRate/2) for even and odd length NFFT, 
  %   respectively. 
  %   The default is 'twosided'
  FrequencyRange = 'twosided';
end

properties (Access = private)
  %pWindowData Pre-computed window vector
  pWindowData;
  %pWindowPower Pre-computed window power
  pWindowPower;
  %pW Pre-computed fequency vector
  pW;
  %pNumAvgsCounter Counter that counts number of averages and saturates
  %when its value reaches SpectralAverages. This counter is used to avoid
  %averaging initial all zero periodograms.
  pNumAvgsCounter;
  %pNewPeriodogramIdx Index for newer periodogram column in the
  %pPeriodogramMatrix
  pNewPeriodogramIdx;
  %pPeriodogramMatrix 3D matrix containing the last SpectralAverages
  %periodograms in each column. The third dimension contains matrices for
  %each input channel. So pPeriodogramMatrix(:,:,i) contains the
  %periodograms for the i-th channel.
  pPeriodogramMatrix;
  %pRBW Pre-computed RBW
  pRBW;
  %pFFT Handle to the FFT object
  pFFT;
end

properties (Access = private,Nontunable)
  % pSegmentLength Segment length, equal to the input frame length
  pSegmentLength;
  % pNumChannels Number of input channels
  pNumChannels;
  %pNFFT Actual FFT length
  pNFFT
  % pDatatype Input datatype
  pDatatype;
  % pInit Flag set to one when object is locked. Used in getRBW and
  % getFrequencyVector to disallow usage for unlocked object in code
  % generation
  pInit = 0
end

properties (Constant, Hidden)
  % String sets
  FFTLengthSourceSet = matlab.system.StringSet({'Auto','Property'});
  WindowSet = matlab.system.StringSet({...
        'Rectangular', ...
        'Chebyshev', ...
        'Flat Top', ...
        'Hamming', ...
        'Hann', ...
        'Kaiser'});
  FrequencyRangeSet = matlab.system.StringSet({'onesided','twosided','centered'});
end
    
%--------------------------------------------------------------------------
% Abstract methods
%--------------------------------------------------------------------------
methods (Abstract, Access = protected)
  % Abstract method. Children objects redifine this method. 
  P = computeWindowFFT(~,~)
  getInitialPeriodogramMatrix(~);
end

%--------------------------------------------------------------------------
% Public methods
%--------------------------------------------------------------------------
methods
  function obj = SpectrumEstimatorBase(varargin)
    %SpectrumEstimatorBase   Construct the SpectrumEstimatorBase class. 
    coder.allowpcode('plain');
    setProperties(obj, nargin, varargin{:});
  end

  function set.SampleRate(obj,value)
    % Set the sample rate. Positive real scalar.
    validateattributes(value,{'double'}, {'positive','real','scalar','finite'},...
    '','SampleRate');%#ok<EMCA>
    obj.SampleRate = value;
  end

  function set.SpectralAverages(obj,value)
    % Set the number of spectral averages. Positive scalar integer. 
    validateattributes(value,{'double'}, {'positive','real','scalar',...
                      'integer'},'','SpectralAverages');%#ok<EMCA>
    obj.SpectralAverages = value;
  end
  
  function set.SidelobeAttenuation(obj,value)
    % Set the Window sidelobe attenuation. Positive real scalar. 
    validateattributes(value,{'double'}, {'positive','real','scalar'},...
                              '','SidelobeAttenuation');%#ok<EMCA>        
    obj.SidelobeAttenuation = value;
  end
  
  function set.FFTLength(obj,value)
    % Set the FFT length. Positive real scalar. 
    % Set the number of spectral averages. Positive scalar integer. 
    validateattributes(value,{'double'}, {'positive','real','scalar',...
                      'integer','>',1},'','FFTLength');%#ok<EMCA>   
    obj.FFTLength = value;
  end
end

%--------------------------------------------------------------------------
% Public methods to get RBW and Frequency Vector
%--------------------------------------------------------------------------
methods
  function RBW = getRBW(obj,varargin)
    % getRBW Get the resolution bandwidth of the Spectrum, in Hz. 
    %   The resolution bandwidth, RBW, is the smallest positive frequency, 
    %   or frequency interval, that can be resolved. It is equal to 
    %   ENBW * SampleRate/ L, where L is the input length, and ENBW is the
    %   two-sided equivalent noise bandwidth of the window (in Hz). For
    %   example, if SampleRate = 100, L = 1024, and Window = 'Hann', 
    %   RBW =  enbw(hann(1024)) * 100 / 1024
    assertScalar(obj);
    
    % Throw compile-time error if function is called before locking object
    coder.internal.errorIf(obj.pInit==0,...
        'dsp:system:SpectrumEstimatorBase:NotLockedYet','getRBW');
    % Disallow usage if object was locked and then released
    coder.internal.errorIf(~isLocked(obj),...
        'dsp:system:SpectrumEstimatorBase:NotLockedYet','getRBW');
    
    if (nargin==1)
        RBW = obj.pRBW;
    else
        % Use input sample rate
        w = obj.pWindowData;
        L = length(w);
        Fs = varargin{1};
        % Compute window power
        ENBW = (sum(w.^2)/sum(w)^2)*L;
        % Compute the RBW
        RBW = ENBW * Fs/ L;
    end


  end
  
  function w = getFrequencyVector(obj,varargin)
   % getFrequencyVector Get the vector of frequencies at which the spectrum 
   %   is estimated, in Hz. 
   %   If you set the FrequencyRange to 'onesided' and the FFT length, 
   %   NFFT, is even, the frequency vector is of length NFFT/2+1 and it 
   %   covers the interval [0,SampleRate/2]. If you set the FrequencyRange 
   %   to 'onesided' and NFFT is odd, the frequency vector is of length 
   %   (NFFT+1)/2 and it covers the interval [0,SampleRate/2).
   %   If you set the FrequencyRange to 'twosided', the frequency vector is 
   %   of length NFFT and it covers the interval [0, SampleRate). 
   %   If you set the FrequencyRange to 'centered', the frequency vector is 
   %   of length NFFT and it covers the range (-SampleRate/2, SampleRate/2] 
   %   for even length NFFT, and (-SampleRate/2, SampleRate/2) for odd 
   %   length NFFT.
    assertScalar(obj);
    
   % Throw compile-time error if function is called before locking object
    coder.internal.errorIf(obj.pInit==0,...
        'dsp:system:SpectrumEstimatorBase:NotLockedYet','getFrequencyVector');
    % Disallow usage if object was locked and then released
    coder.internal.errorIf(~isLocked(obj),...
        'dsp:system:SpectrumEstimatorBase:NotLockedYet','getFrequencyVector');
    
   if (nargin==1)
       w0 = obj.pW;
   else
       % Use input sample rate
       if ~strcmp(obj.FrequencyRange,'onesided')
           Range = 'whole';
       else
           Range = 'half';
       end
       Npts = obj.pNFFT;
       Fs = varargin{1};
       pCenterDC = strcmp(obj.FrequencyRange,'centered');
       w0 = dsp.private.SpectrumEstimatorBase.frequencygrid...
           (Range,Npts,Fs,pCenterDC);
   end
   w = cast(w0,obj.pDatatype);
  end
end
%--------------------------------------------------------------------------
% Protected methods
%--------------------------------------------------------------------------
methods(Access = protected)

  function num = getNumOutputsImpl(~)
    num = 1;
  end

  function flag = isInputSizeLockedImpl(~,varargin)
    % The segment length depends on the input frame size, so variable-size
    % inputs are not allowed. 
    flag = true;
  end
  
  function  resetImpl(obj)
    % Reset the running average counter and index
    obj.pNumAvgsCounter = 0;
    obj.pNewPeriodogramIdx = 0;
    % initialize the running average matrix:
    obj.pPeriodogramMatrix = cast(getInitialPeriodogramMatrix(obj),...
                                  obj.pDatatype);
  end
  
  function  releaseImpl(obj)
    release(obj.pFFT);
  end
  
  function validateInputsImpl(obj,x)
      
    if size(x,1)<=1
       matlab.system.internal.error(...
       'dsp:system:SpectrumEstimatorBase:ScalarInput');
    end
    
    % Complex input is not allowed for one-sided spectrum estimation
    if strcmp(obj.FrequencyRange,'onesided') && ~isreal(x)
       matlab.system.internal.error(...
       'dsp:system:SpectrumEstimatorBase:InvalidSpectrumType');
    end
    validateattributes(x,{'double','single'}, {'2d',...
                      'nonsparse'},'','x');%#ok<EMCA>
                  
  end
  
  function flag = isInputComplexityLockedImpl(~,~) 
    flag = true; 
  end
  
  function flag = isInactivePropertyImpl(obj, prop)
    flag = false;
    switch prop
        case 'SidelobeAttenuation'
            flag = ~strcmp('Chebyshev',obj.Window) && ...
                   ~strcmp('Kaiser',obj.Window);
        case 'FFTLength'
            flag = strcmp(obj.FFTLengthSource,'Auto');
    end
  end
  
  function setupImpl(obj, varargin)
    % Get the segment length and the number of channels from the input. 
    x = varargin{1};
    obj.pSegmentLength = size(x,1);
    obj.pNumChannels = size(x,2);
    obj.pDatatype = class(x);
    % Set the window parameters
    setWindowParameters(obj);

    % Set the actual FFT length.
    % when FFTLengthSource is auto, use segment length as FFT
    % length. Otherwise, use value in FFTLength property.
    if strcmp(obj.FFTLengthSource,'Auto')
        obj.pNFFT = obj.pSegmentLength;
    else
        obj.pNFFT = obj.FFTLength;
    end
    
    obj.pFFT = dsp.FFT('FFTImplementation','FFTW',...
        'FFTLengthSource','Property',...
        'FFTLength',obj.pNFFT);
    
    % Pre-compute the frequency vector
    % Compute one or two sided, dc-centered frequency vector
    if ~strcmp(obj.FrequencyRange,'onesided')
      Range = 'whole';
    else
      Range = 'half';  
    end        
    Npts = obj.pNFFT;
    Fs = obj.SampleRate;
    pCenterDC = strcmp(obj.FrequencyRange,'centered');
    obj.pW = dsp.private.SpectrumEstimatorBase.frequencygrid...
                 (Range,Npts,Fs,pCenterDC);
    % Flag indicates object is locked         
    obj.pInit = 1;

  end

  function P = stepImpl(obj, varargin)
    % Compute periodogram of new segment
    P = computeWindowFFT(obj,varargin{:})/obj.pWindowPower;
    % Update the running average matrix
    updatePeriodogramMatrix(obj,P);
    % Get the current average
    P = getPeriodogramMatrixAverage(obj);
    % Conver and scale
    P = convertAndScale(obj,P);
  end

  function s = saveObjectImpl(obj)
     s = saveObjectImpl@matlab.System(obj);
     if isLocked(obj)
        s.pFFT     = matlab.System.saveObject(obj.pFFT);
        s.pWindowData = obj.pWindowData;
        s.pWindowPower = obj.pWindowPower;
        s.pW = obj.pW;
        s.pNumAvgsCounter = obj.pNumAvgsCounter;
        s.pNewPeriodogramIdx = obj.pNewPeriodogramIdx;
        s.pPeriodogramMatrix = obj.pPeriodogramMatrix;
        s.pRBW = obj.pRBW;
        s.pNFFT = obj.pNFFT;
        s.pSegmentLength = obj.pSegmentLength;
        s.pNumChannels = obj.pNumChannels;
        s.pDatatype    = obj.pDatatype;
        s.pInit        = obj.pInit;
     end 
  end
  
  function loadObjectImpl(obj, s, wasLocked)
     if wasLocked
        obj.pWindowData = s.pWindowData;
        obj.pWindowPower = s.pWindowPower;
        obj.pW = s.pW;
        obj.pNumAvgsCounter = s.pNumAvgsCounter;
        obj.pNewPeriodogramIdx = s.pNewPeriodogramIdx;
        obj.pPeriodogramMatrix = s.pPeriodogramMatrix;
        obj.pRBW = s.pRBW;
        obj.pFFT = matlab.System.loadObject(s.pFFT);
        obj.pNFFT = s.pNFFT;
        obj.pSegmentLength = s.pSegmentLength;
        obj.pNumChannels = s.pNumChannels;
        obj.pDatatype    = s.pDatatype;
        obj.pInit        = s.pInit;
     end
      loadObjectImpl@matlab.System(obj, s);
   end
  
  function xout = windowData(obj,x)
    % Multiply input by the window vector
    xout = bsxfun(@times,x,obj.pWindowData);
  end

  function xout = computeFFT(obj,xin)
    % Compute FFT
    xout = step(obj.pFFT,xin); 
  end
  
  function  Pout = convertAndScale(obj,P)
    %convertAndScale Convert to one sided and center DC if needed, scale by
    %Fs to convert to density

    if strcmp(obj.FrequencyRange,'onesided')
        % If user specified one sided spectrum we need to call
        % computeOneSidedSpectrum to fold power values
        Pout = computeOneSidedSpectrum(obj,P);
    elseif strcmp(obj.FrequencyRange,'centered')
        % Center DC
       Pout = centerDC(obj,P);
    else
        Pout = P;
    end

    % Scale with respect to Fs to convert to PSD
    Pout = Pout/obj.SampleRate;
    
  end
  
  function numChan = getNumberOfChannels(obj)
      numChan = obj.pNumChannels;
  end
  
  function FFTLen = getActualFFTLen(obj)
      FFTLen = obj.pNFFT;
  end
  
end

%--------------------------------------------------------------------------
% Private methods
%--------------------------------------------------------------------------
methods (Access = private)
    
  function setWindowParameters(obj)
    % Set the window parameters based on the segment length and the window
    % type
    L = obj.pSegmentLength;
    switch obj.Window
        case 'Rectangular'
            w = ones(L,1);
        case 'Hann'
            w = hann(L,'periodic');
        case 'Hamming'
            w = hamming(L,'periodic');
        case 'Flat Top'
            w = flattopwin(L,'periodic');
        case 'Chebyshev'
            w = chebwin(L,obj.SidelobeAttenuation);
        case 'Kaiser'
            if obj.SidelobeAttenuation > 50
                winParam = 0.1102*(obj.SidelobeAttenuation-8.7);
            elseif obj.SidelobeAttenuation < 21
                winParam = 0;
            else
                winParam = (0.5842*(obj.SidelobeAttenuation-21)^0.4) + ...
                    0.07886*(obj.SidelobeAttenuation-21);
            end
            w = kaiser(L,winParam);
    end
    % Store the window vector in pWindowData property
    obj.pWindowData = w;
    % Compute window power and store it in pWindowPower property
    obj.pWindowPower = obj.pWindowData.'*obj.pWindowData;
    ENBW = (sum(w.^2)/sum(w)^2)*L;
    % Compute the RBW and store it in pRBW property
    obj.pRBW = ENBW * obj.SampleRate/ L;
  end
   
  
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
        Pos = [Pos_unscaled(1,:); 2*Pos_unscaled(2:end-1,:); ...
               Pos_unscaled(end,:)];
    end
  end

  function Pdc_out = centerDC(~,P)
    % Convert to plot + and - frequencies.

    nfft = size(P,1);

    Pdc = fftshift(P,1);  % Places the Nyquist freq on the negative side.

    % Determine half the number of FFT points.
    if ~rem(nfft,2),
        % Move the Nyquist point to the right-hand side (pos freq) to be
        % consistent with plot when looking at the positive half only.
        Pdc_out = [Pdc(2:end,:); Pdc(1,:)];
    else
        Pdc_out = Pdc;
    end
  end

  function updatePeriodogramMatrix(obj,P)
    % Do running average with previous numAverage values
    % Do not include initial zero columns on the averages
    obj.pNumAvgsCounter = min(obj.pNumAvgsCounter+1,obj.SpectralAverages);
    obj.pNewPeriodogramIdx =  max(1,mod(obj.pNewPeriodogramIdx+1,...
                                  obj.SpectralAverages+1));
    obj.pPeriodogramMatrix(:,obj.pNewPeriodogramIdx,:) = P; 
  end

  function P = getPeriodogramMatrixAverage(obj)
    P = squeeze(sum(obj.pPeriodogramMatrix,2)/obj.pNumAvgsCounter);
  end
  
end
%--------------------------------------------------------------------------
% Private static methods
%--------------------------------------------------------------------------
methods (Access = private, Static)
  function w = frequencygrid(Range,Npts,Fs,CenterDC)
    freq_res = Fs/Npts;
    w0 = freq_res*(0:Npts-1);
    % There can still be some minor round off errors in the frequency grid.  
    % Fix the known points, i.e., those near pi and 2pi.
    Nyq = Fs/2;
    half_res = freq_res/2; % half the resolution

    % Determine if Npts is odd and calculate half and quarter of Npts.
    [isNPTSodd,halfNPTS] = ...
        dsp.private.SpectrumEstimatorBase.NPTSinfo(Npts);

    if isNPTSodd,
        % Adjust points on either side of Nyquist.
        w0(halfNPTS)   = Nyq - half_res;
        w0(halfNPTS+1) = Nyq + half_res;
    else
        % Make sure we hit Nyquist exactly, i.e., pi or Fs/2 
        w0(halfNPTS) = Nyq;
    end
    w0(Npts) = Fs-freq_res;

    % Get the right grid based on range, centerdc, etc.
    w = dsp.private.SpectrumEstimatorBase.finalgrid(w0,Range,...
                CenterDC,isNPTSodd,halfNPTS);
  end
  
  function [isNPTSodd,halfNPTS] = NPTSinfo(NPTS)
    % Determine if we are dealing with even or odd lengths of NPTS, 1/2 
    % NPTS, and 1/4 NPTS.

    % Determine if Npts is odd.
    isNPTSodd = false;
    if rem(NPTS,2),
        isNPTSodd = true;
    end

    % Determine half the number of points.
    if isNPTSodd
        halfNPTS = (NPTS+1)/2;  % ODD
    else
        halfNPTS = (NPTS/2)+1;  % EVEN
    end

  end
  
  function wout = finalgrid(w,Range,CenterDC,isNPTSodd,...
                            halfNPTS)
    % Calculate the correct grid based on user specified values for range,
    % centerdc, etc.
    if strcmpi(Range,'whole')
        % Calculated by default.% [0, 2pi)

        if CenterDC,          % (-pi, pi] even or (-pi, pi) odd
            if isNPTSodd,  negEndPt = halfNPTS;
            else           negEndPt = halfNPTS-1;
            end
            wtemp = [-fliplr(w(2:negEndPt)), w(1:halfNPTS)];
            wout  = wtemp(:);  % Return a column vector.
        else
            wout = w(:); % Return a column vector.
        end

    else
        w2 = w(1:halfNPTS);      % [0, pi] even or [0, pi) odd
        wout = w2(:);  % Return a column vector. 
    end
    
  end

end

end

