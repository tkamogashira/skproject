classdef VariableBandwidthIIRFilter  < dsp.private.VariableBandwidthFilterBase & matlab.system.mixin.CustomIcon 
%VariableBandwidthIIRFilter Variable bandwidth IIR filter
%   HIIR = dsp.VariableBandwidthIIRFilter returns a System object, HIIR, 
%   which independently filters each channel of the input over time using
%   specified IIR filter specifications. The IIR filter's passband 
%   frequency may be tuned during the filtering operation. The IIR filter 
%   is designed using the elliptical method. The IIR filter is tuned using 
%   IIR spectral transformations based on allpass filters [1]. 
%
%   H = dsp.VariableBandwidthIIRFilter('Name', Value, ...) returns a 
%   Variable Bandwidth IIR Filter System object, H, with each specified 
%   property name set to the specified value. You can specify additional 
%   name-value pair arguments in any order as (Name1,Value1,...,NameN,
%   ValueN).
%
%   Step method syntax:
%
%   Y = step(H, X) filters the real or complex input signal X using the
%   specified filter to produce the output Y. The System object filters
%   each channel of the input signal independently over time.
%
%   VariableBandwidthIIRFilter methods:
%
%   step          - See above description for use of this method
%   release       - Allow property value and input characteristics changes                      
%   clone         - Create Variable Bandwidth IIR Filter object with 
%                   same property values                      
%   isLocked      - Locked status (logical)
%   reset         - Reset the internal states to initial conditions
%
%   VariableBandwidthIIRFilter properties:
%
%   SampleRate                   - Input sample rate
%   FilterType                   - IIR filter type
%   FilterOrder                  - IIR filter order
%   PassbandFrequency            - Filter passband frequency
%   CenterFrequency              - Filter center frequency
%   Bandwidth                    - Filter bandwidth
%   PassbandRipple               - Filter passband ripple
%   StopbandAttenuation          - Filter stopband attenuation
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.VariableBandwidthIIRFilter.helpFilterAnalysis
%
%   % Example: Filter a signal through a variable bandwidth bandpass IIR
%   % filter. Tune the center frequency and the bandwidth of the IIR filter. 
%   Fs = 44100; % Input sample rate
%   % Define a bandpass variable bandwidth IIR filter:
%   hiir = dsp.VariableBandwidthIIRFilter('FilterType','Bandpass',...
%                                         'FilterOrder',8,...
%                                         'SampleRate',Fs,...
%                                         'CenterFrequency',1e4,...
%                                         'Bandwidth',4e3);
%   htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided');
%   hplot = dsp.ArrayPlot('PlotType','Line',...
%                         'XOffset',0,...
%                         'YLimits',[-120 5], ...
%                         'SampleIncrement', 44100/1024,...
%                         'YLabel','Frequency Response (dB)',...
%                         'XLabel','Frequency (Hz)',...
%                         'Title','System Transfer Function');
%   FrameLength = 1024;
%   hsin = dsp.SineWave('SamplesPerFrame',FrameLength);
%   for i=1:500
%      % Generate input
%      x = step(hsin) + randn(FrameLength,1);
%      % Pass input through the filter
%      y = step(hiir,x);
%      % Transfer function estimation
%      h = step(htfe,x,y);
%      % plot transfer function
%      step(hplot,20*log10(abs(h)))   
%      % Tune bandwidth and center frequency of the IIR filter
%      if (i==250)
%        hiir.CenterFrequency = 5000;
%        hiir.Bandwidth = 2000;
%      end
%   end
%
%   References:
%
%   [1] A. G. Constantinides, "Spectral transformations for digital 
%       filters",  Proc. Inst. Elect. Eng.,  vol. 117,  no. 8,  pp.1585 -
%       1590, 1970. 
%
%   See also dsp.VariableBandwidthFIRFilter, dsp.FIRFilter, dsp.IIRFilter, 
%            dsp.BiquadFilter, dsp.AllpoleFilter

%   Copyright 2013 The MathWorks, Inc.
    
%#codegen
%#ok<*EMCLS>

properties (Nontunable)
  % FilterOrder IIR filter order
  %   Specify the order of the IIR filter as a positive integer scalar. The 
  %   default is 8.
  FilterOrder = 8;
  % PassbandRipple Filter passband ripple
  %   Specify the filter passband ripple as a real, positive scalar in 
  %   decibels (dB). The default is 1 dB.
  PassbandRipple = 1;
  % StopbandAttenuation Filter Stopband attenuation
  %   Specify the filter stopband attenuation as a real, positive scalar in 
  %   decibels (dB). The default is 60 dB.
  StopbandAttenuation = 60;
end
    
properties
  % PassbandFrequency Filter passband frequency
  %   Specify the filter passband frequency in Hz as a real, positive
  %   scalar smaller than SampleRate/2. This property applies when you set 
  %   the FilterType property to 'Lowpass' or 'Highpass'. The default is 
  %   512 Hz. This property is tunable.
  PassbandFrequency   = 512;
end

properties (Access = private, Nontunable)
  % pPrototypeSOS Lowpass prototype SOS matrix
  pPrototypeSOS;
  % pPrototypeGain Lowpass prototype gain vector
  pPrototypeGain;
  % pPrototypePassbandFrequency Lowpass prototype passband frequency
  pPrototypePassbandFrequency;
  % pSectionLen Section length ( 3 for lowpass/highpass, 5 for
  % bandpass/bandstop)
  pSectionLen;
  % pNumSections Number of sections
  pNumSections;
end

properties (Access = private)
  % pTransformedNum Numerator coefficients of transformed filter
  pTransformedNum;
  % pTransformedDen Denominator coefficients of transformed filter
  pTransformedDen;
  % pTransformedGain Transformed filter gain vector
  pTransformedGain;
end
%--------------------------------------------------------------------------
% Public methods
%--------------------------------------------------------------------------
methods
  function obj = VariableBandwidthIIRFilter(varargin)
    % Constructor
    obj@dsp.private.VariableBandwidthFilterBase(varargin{:});
  end
  %------------------------------------------------------------------------   
  function set.PassbandFrequency(obj,value)
    validateattributes(value,{'double','single'}, {'real','scalar','positive','finite'},...
    '','PassbandFrequency');%#ok<EMCA>
    obj.PassbandFrequency = value;
  end
  %------------------------------------------------------------------------          
  function set.FilterOrder(obj,value)
    validateattributes(value,{'double','single'}, {'real','scalar','positive',...
    'integer'},'','FilterOrder');%#ok<EMCA>
    obj.FilterOrder = value;
  end
  %------------------------------------------------------------------------
  function set.PassbandRipple(obj,value)
    validateattributes(value,{'double','single'}, {'real','scalar','positive','finite'},...
    '','PassbandRipple');%#ok<EMCA>
    obj.PassbandRipple = value;
  end
  %------------------------------------------------------------------------
  function set.StopbandAttenuation(obj,value)
    validateattributes(value,{'double','single'}, {'real','scalar','positive','finite'},...
                              '','StopbandAttenuation');%#ok<EMCA>
    obj.StopbandAttenuation = value;
  end
end
%--------------------------------------------------------------------------
% Protected methods
%--------------------------------------------------------------------------
methods (Access = protected)  
  function setupImpl(obj, x) 
    % Invoke setupImpl method of base class
    setupImpl@dsp.private.VariableBandwidthFilterBase(obj,x);
     % extrinsic functions for lowpass prototype design
     coder.extrinsic('dsp.VariableBandwidthIIRFilter.designCustomOrderPrototype');
        
    if strcmp(obj.FilterType,'Bandpass') ||  strcmp(obj.FilterType,'Bandstop')
       % the spectral transformation doubles the filter order for the
       % bandpass and bandstop cases. Therefore, the target filter order
       % must be even in that case
       coder.internal.errorIf( all(mod(obj.FilterOrder,2)), ...
          'dsp:system:VariableBandwidthFilter:IIRBandpassBandstopOrder');
       pFilterOrder =  obj.FilterOrder / 2;
    else
       pFilterOrder =  obj.FilterOrder;
    end
     
    % Set the arbitrary lowpass prototype passband frequency
    obj.pPrototypePassbandFrequency = cast(.5,obj.pDatatype);
    % Design the lowpass prototype
    [obj.pPrototypeSOS,obj.pPrototypeGain] = coder.const(@obj.designCustomOrderPrototype,...
                                                          pFilterOrder,...
                                                          obj.pPrototypePassbandFrequency,...
                                                          obj.PassbandRipple,...
                                                          obj.StopbandAttenuation,...
                                                          obj.pDatatype);
    % Setup the transformed filter 
    % For lowpass and highpass filters, the transformed filter consists of
    % second-order sections. 
    % For bandpass and bandstop filters, the transformed filter consists of
    % fourth-order sections. 
    obj.pNumSections = size(obj.pPrototypeSOS,1);
    if strcmp(obj.FilterType,'Highpass') ||  strcmp(obj.FilterType,'Lowpass')
        obj.pSectionLen = 3; % SOS
    else
        obj.pSectionLen = 5; % Fourth-order section
    end 
    obj.pTransformedNum = cast(zeros(obj.pNumSections,obj.pSectionLen),obj.pDatatype);
    obj.pTransformedDen = cast(zeros(obj.pNumSections,obj.pSectionLen),obj.pDatatype);
    % Numerator, denominator and gain properties are set to zero matrices
    % with the correct dimensions. The actual values are computed in the
    % call to tuneCoefficients
    if strcmp(obj.FilterType,'Highpass') ||  strcmp(obj.FilterType,'Lowpass')
        obj.pfilter = dsp.private.SecondOrderSectionFilter('Numerator',obj.pTransformedNum,...
                                                           'Denominator',obj.pTransformedDen,...
                                                           'ScaleValues',cast(zeros(obj.pNumSections+1,1),obj.pDatatype));
    else
        obj.pfilter = dsp.private.FourthOrderSectionFilter('Numerator',obj.pTransformedNum,...
                                                           'Denominator', obj.pTransformedDen,...
                                                           'ScaleValues',cast(zeros(obj.pNumSections+1,1),obj.pDatatype));
    end 
    % Compute coefficients based on passband frequency
    tuneCoefficients(obj);
  end
%--------------------------------------------------------------------------
  function tuneCoefficients(obj)
    wo = cast(obj.pPrototypePassbandFrequency,obj.pDatatype);
    
    % Calculate the mapping allpass filter coefficients
    switch obj.FilterType
        case {'Lowpass','Highpass'}
            wt = cast(obj.PassbandFrequency * 2 / obj.SampleRate,obj.pDatatype);
            if strcmp(obj.FilterType,'Lowpass')
                [allpassnum, allpassden] = allpasslp2lp(wo, wt);    
            else % highpass
                [allpassnum, allpassden] = allpasslp2hp(wo, wt); 
            end
        case {'Bandpass','Bandstop'}
            wt1 = cast(obj.CenterFrequency* 2 / obj.SampleRate - obj.Bandwidth/ obj.SampleRate,obj.pDatatype);
            wt2 = cast(obj.CenterFrequency* 2 / obj.SampleRate + obj.Bandwidth/ obj.SampleRate,obj.pDatatype);   
            if strcmp(obj.FilterType,'Bandpass')
                [allpassnum, allpassden] = allpasslp2bp(wo, [wt1 wt2]);  
            else % bandstop
                [allpassnum, allpassden] = allpasslp2bs(wo, [wt1 wt2]); 
            end
    end
    
    % Transform each SOS section
    for i=1:obj.pNumSections
        % polyallpasssub replaces each delay by the allpass filter
        [num,den] = obj.polyallpasssub(obj.pPrototypeSOS(i,1:3), obj.pPrototypeSOS(i,4:6), allpassnum, allpassden);
        % The leading coefficient of the denominator must equal to 1
        a0 = den(1);
        if a0 ~= 1
            den =    den / a0;
            num =    num / a0;
        end
        % polyallpasssub will sometimes return a length-2 vector instead of
        % a length-3 vector if the last element was zero
        num0 = zeros(1,obj.pSectionLen);
        num0(1:length(num)) = num;
        obj.pTransformedNum(i,:) = num0;
        den0 = zeros(1,obj.pSectionLen);
        den0(1:length(den)) = den;
        obj.pTransformedDen(i,:) = den0;
    end
    % Force leading numerator to one
    sv = obj.pTransformedNum(:,1);
    L2 = size(obj.pTransformedNum,2);
    obj.pTransformedNum(:,1:L2) = obj.pTransformedNum(:,1:L2)./repmat(obj.pTransformedNum(:,1),1,L2);
    obj.pTransformedGain =  obj.pPrototypeGain;
    obj.pTransformedGain(1:length(sv)) = obj.pTransformedGain(1:length(sv)) .* sv;
    % Tune the IIR filter
    obj.pfilter.Numerator = obj.pTransformedNum;
    obj.pfilter.Denominator = obj.pTransformedDen;
    obj.pfilter.ScaleValues = obj.pTransformedGain; 
  end
%--------------------------------------------------------------------------
  function validateFrequencyRange(obj)
    % PassbandFrequency must be less than SampleRate/2
    % This method is invoked in validatePropertiesImpl of the base class
    if obj.PassbandFrequency > obj.SampleRate/2
        coder.internal.errorIf(obj.PassbandFrequency > obj.SampleRate/2,...
             'dsp:system:VariableBandwidthFilter:CharacteristicTooLarge','PassbandFrequency');
    end
  end
%--------------------------------------------------------------------------
  function y = stepImpl(obj, x)
    % step the IIR filter
    y = step(obj.pfilter,x);
  end   
%--------------------------------------------------------------------------
  function s = saveObjectImpl(obj)
    s = saveObjectImpl@dsp.private.VariableBandwidthFilterBase(obj);
    if isLocked(obj)
        s.pTransformedNum = obj.pTransformedNum;
        s.pTransformedDen = obj.pTransformedDen;
        s.pTransformedGain = obj.pTransformedGain;
        s.pPrototypeSOS = obj.pPrototypeSOS;
        s.pPrototypeGain = obj.pPrototypeGain;
        s.pSectionLen = obj.pSectionLen;
        s.pNumSections = obj.pNumSections;
        s.pPrototypePassbandFrequency = obj.pPrototypePassbandFrequency;
    end
  end
%--------------------------------------------------------------------------
  function loadObjectImpl(obj, s, wasLocked)
    if wasLocked
        obj.pTransformedNum = s.pTransformedNum;
        obj.pTransformedDen = s.pTransformedDen;
        obj.pTransformedGain = s.pTransformedGain;
        obj.pPrototypeSOS = s.pPrototypeSOS;
        obj.pPrototypeGain = s.pPrototypeGain;
        obj.pSectionLen = s.pSectionLen;
        obj.pNumSections = s.pNumSections;
        obj.pPrototypePassbandFrequency = s.pPrototypePassbandFrequency;
    end
    loadObjectImpl@dsp.private.VariableBandwidthFilterBase(obj,s,wasLocked);
  end
%--------------------------------------------------------------------------
  function flag = isInactivePropertyImpl(obj, prop)
    flag = false;
    switch prop
        case {'PassbandFrequency'}
            if ~strcmp(obj.FilterType,'Lowpass') && ...
                    ~strcmp(obj.FilterType,'Highpass')
                flag = true;
            end
        otherwise
            flag = isInactivePropertyImpl@dsp.private.VariableBandwidthFilterBase(obj,prop);
    end
  end
%--------------------------------------------------------------------------
  function icon = getIconImpl(~)
    % MATLAB system block icon
    icon = sprintf('Variable Bandwidth\nIIR Filter');
  end
end
%--------------------------------------------------------------------------
% Static, hidden methods
%--------------------------------------------------------------------------
methods (Static, Hidden)
  function d = getdfiltobj(sysObjToAnalyze,arith)
    %  Equivalent DFILT object for filter analysis methods
    d = convertToDFILT(sysObjToAnalyze.pfilter, arith);
  end
  %------------------------------------------------------------------------  
  function [sos,g] = designCustomOrderPrototype(N,Fpass,Apass,Astop,datatype)
    % Design prototype lowpass filter using elliptic method
    Fs = 2; % sample rate is 2, normalized frequency [0,1]
    f = fdesign.lowpass('N,Fp,Ap,Ast',N,Fpass,Apass,Astop,Fs);
    h = design(f,'ellip');
    sos =  cast(h.sosMatrix,datatype);
    g   =  cast(h.ScaleValues,datatype);
  end
end
%--------------------------------------------------------------------------
% Static, Protected methods
%--------------------------------------------------------------------------   
methods(Static, Access=protected)
    %------------------------------------------------------------------------
  function [num,den] = polyallpasssub(b0,a0,allpassnum,allpassden)
    %POLYALLPASSSUB   Substitute delays in polynomials with allpass filters. 
    % Remove possible trailing zeros and get polynomial lengths
    b = b0(b0~=0); M = length(b);
    a = a0(a0~=0); N = length(a);
    % Compute temporary numerator
    tempnum = dsp.VariableBandwidthIIRFilter.newpoly(b,allpassnum,allpassden,M);       
    % Compute temporary denominator
    tempden = dsp.VariableBandwidthIIRFilter.newpoly(a,allpassnum,allpassden,N);       
    % Now include common denominators
    num = conv(tempnum,dsp.VariableBandwidthIIRFilter.polypow(allpassden,N-M));
    den = conv(tempden,dsp.VariableBandwidthIIRFilter.polypow(allpassden,M-N));       
    num = num/den(1);
    den = den/den(1);
  end
  %-----------------------------------------------------------------------
  function temppoly = newpoly(b,allpassnum,allpassden,M)
    % Compute new polynomial after substitution
    % For each coefficient, we will have a resulting polynomial after we
    % substitute, form each polynomial and then add them all up to compute
    % the new numerator or denominator.
    temp = cast(zeros(M,(M-1)*length(allpassden)-M + 2),class(allpassden));
    for n = 1:M,
        temp(n,:) = b(n).*conv(dsp.VariableBandwidthIIRFilter.polypow(allpassden,M-n),...
        dsp.VariableBandwidthIIRFilter.polypow(allpassnum,n-1));
    end
    temppoly = sum(temp);     
  end
  %------------------------------------------------------------------------
  function p = polypow(q,N)
    %POLYPOW   Evaluate polynomial to power of N. 
    % Initialize recursion
    p = cast(zeros(1,N*length(q) - N + 1),class(q));
    p(1) = 1; 
    % Multiply polynomial by q, N times
    for n = 1:N,
        p(1:n*length(q)-n+1) = conv(p(1:(n-1)*length(q)-(n-2)),q);
    end
  end
  %------------------------------------------------------------------------
  function group = getPropertyGroupsImpl
    % Modify order of display
    group = matlab.system.display.Section('Title','Parameters');
    group.PropertyList = {'SampleRate','FilterType','FilterOrder',...
                          'PassbandFrequency','CenterFrequency', 'Bandwidth',...
                          'PassbandRipple', 'StopbandAttenuation'}; %#ok
  end
  %------------------------------------------------------------------------
  function header = getHeaderImpl
    % MATLAB System block header
    header = matlab.system.display.Header('dsp.VariableBandwidthIIRFilter', ...
                                          'ShowSourceLink', true, ...
                                          'Title', 'Variable Bandwidth IIR Filter');
   end
end
end