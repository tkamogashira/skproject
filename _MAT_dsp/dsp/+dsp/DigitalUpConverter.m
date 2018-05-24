classdef DigitalUpConverter < dsp.private.DigitalConverterBase
    %dsp.DigitalUpConverter Digitally up convert input signal
    %   H = dsp.DigitalUpConverter creates a digital up converter (DUC) System
    %   object, H. The object up samples the input signal using a cascade of
    %   three interpolation filters. The object frequency up converts the up
    %   sampled signal by multiplying it with a complex exponential with center
    %   frequency equal to the value in the CenterFrequency property. When you
    %   set the FilterSpecification property to 'Design parameters', the DUC
    %   object designs the interpolation filters according to the filter
    %   specifications that you set in the filter-related object properties. In
    %   this case the filter cascade consists of a first FIR interpolation
    %   stage, a CIC compensator, and a CIC interpolator. The first filter
    %   stage can be bypassed depending on how you set the properties of the
    %   DUC object.
    %
    %   H = dsp.DigitalUpConverter(Name,Value) creates a DUC object, H, with the
    %   specified property Name set to the specified Value. You can specify
    %   additional name-value pair arguments in any order as
    %   (Name1,Value1,...,NameN,ValueN).
    %
    %   Step method syntax:
    %
    %   Y = step(H,X) takes a real or complex input column vector X and outputs
    %   an up sampled and frequency up converted signal Y. X can be of data
    %   type double, single, signed integer, or signed fixed point (fi
    %   objects). The length of Y is equal to the length of X multiplied by the
    %   InterpolationFactor. When the data type of X is double or single
    %   precision, the data type of Y is the same as that of X. When the data
    %   type of X is of a fixed point type, the data type of Y is defined by
    %   the OutputDataType property.
    %
    %   dsp.DigitalUpConverter methods:
    %
    %   step                    - Digitally up convert input signal (see above)
    %   release                 - Allow property value and input characteristics
    %                             changes
    %   clone                   - Create DUC object with same property values
    %   isLocked                - Locked status (logical)
    %   getFilters              - Get handles to interpolation filter objects
    %   getFilterOrders         - Get orders of interpolation filters
    %   getInterpolationFactors - Get interpolation factors of each filter stage
    %   visualizeFilterStages   - Visualize response of each filter stage
    %   fvtool                  - Visualize response of the filter cascade
    %   groupDelay              - Compute the group delay of the filter cascade
    %
    %   dsp.DigitalUpConverter properties:
    %
    %   SampleRate                  - Sample rate of input signal
    %   InterpolationFactor         - Interpolation factor
    %   FilterSpecification         - Filter specification
    %   MinimumOrderDesign          - Minimum order filter design
    %   FirstFilterCoefficients     - Coefficients of first filter stage
    %   SecondFilterCoefficients    - Coefficients of second filter stage
    %   FirstFilterOrder            - Order of first filter stage
    %   SecondFilterOrder           - Order of CIC compensation filter stage
    %   NumCICSections              - Number of sections of CIC interpolator
    %   Bandwidth                   - Two sided bandwidth of input signal in Hertz
    %   StopbandFrequencySource     - Source of stopband frequency
    %   StopbandFrequency           - Stopband frequency in Hertz
    %   PassbandRipple              - Passband ripple of cascade response in dB
    %   StopbandAttenuation         - Stopband attenuation of cascade response in dB
    %   Oscillator                  - Type of oscillator
    %   CenterFrequency             - Center frequency of output signal in Hertz
    %   NumAccumulatorBits          - Number of NCO accumulator bits
    %   NumQuantizedAccumulatorBits - Number of NCO quantized accumulator bits
    %   Dither                      - Dither control for NCO
    %   NumDitherBits               - Number of NCO dither bits
    %
    %   The dsp.DigitalUpConverter object supports fixed-point operations. For
    %   more information, type dsp.DigitalUpConverter.helpFixedPoint.
    %
    %   % Example:
    %   %   Create a digital up converter object that up samples a 1 KHz
    %   %   sinusoidal signal by a factor of 20 and up converts it to 50 KHz.
    %
    %   % Create a sine wave generator to obtain the 1 KHz sinusoidal signal
    %   % with a sample rate of 6 KHz.
    %   Fs = 6e3; % Sample rate
    %   hSig = dsp.SineWave('Frequency',1000,'SampleRate', Fs,'SamplesPerFrame',1024);
    %   x = step(hSig); % generate signal
    %
    %   % Create a DUC object. Use minimum order filter designs and set the
    %   % passband ripple to 0.2 dB and the stopband attenuation to 55 dB. Set
    %   % the double sided signal bandwidth to 2 KHz.
    %   hDUC = dsp.DigitalUpConverter(...
    %    'InterpolationFactor', 20,...
    %    'SampleRate', Fs,...
    %    'Bandwidth', 2e3,...
    %    'StopbandAttenuation', 55,...
    %    'PassbandRipple',0.2,...
    %    'CenterFrequency',50e3);
    %
    %   % Create a spectrum estimator to visualize the signal spectrum before
    %   % and after up converting.
    %   window = hamming(floor(length(x)/10));
    %   figure; pwelch(x,window,[],[],Fs,'centered');
    %   title('Spectrum of baseband signal x')
    %
    %   % Up convert the signal and visualize the spectrum
    %   xUp = step(hDUC,x); % up convert
    %   window = hamming(floor(length(xUp)/10));
    %   figure; pwelch(xUp,window,[],[],20*Fs,'centered')
    %   title('Spectrum of up converted signal xUp')
    %
    %   % Visualize the response of the interpolation filters
    %   visualizeFilterStages(hDUC)
    %
    %   See also dsp.DigitalDownConverter, dsp.SineWave, dsp.NCO,
    %   dsp.CICInterpolator, dsp.FIRInterpolator.
    
    %   Copyright 2010-2013 The MathWorks, Inc.
    %#codegen
    %#ok<*EMCA>
    
    properties (Nontunable)
        %Oscillator Type of oscillator
        %   Specify the oscillator as one of 'Sine wave' | 'NCO'. The default is
        %   'Sine wave'. When you set this property to 'Sine wave', the object
        %   frequency up converts the output of the interpolation filter cascade
        %   using a complex exponential signal obtained from samples of a
        %   sinusoidal trigonometric function. When you set this property to
        %   'NCO' the object performs frequency up conversion with a complex
        %   exponential obtained using a numerically controlled oscillator (NCO).
        Oscillator = 'Sine wave'
        %CenterFrequency Center frequency of output signal in Hertz
        %   Specify this property as a double precision, positive scalar. The
        %   object up converts the input signal so that the output spectrum
        %   centers at the frequency you specify in the CenterFrequency property.
        %   The default is 14e6 Hertz.
        CenterFrequency = 14e6;
    end
    
    properties (Nontunable)
        %SampleRate Sample rate of input signal
        %   Set this property to a double precision, positive scalar. The default
        %   is 300e3 Hertz.
        SampleRate
        %InterpolationFactor Interpolation factor
        %   Set this property to a positive, integer scalar, or to a 1x2 or 1x3
        %   vector of positive integers.
        %
        %   When you set this property to a scalar the object automatically
        %   chooses the interpolation factors for each of the three filtering
        %   stages.
        %
        %   When you set this property to a 1x2 vector, the object bypasses the
        %   first filter stage and sets the interpolation factor of the second and
        %   third filtering stages to the values in the first and second vector
        %   elements respectively. When you set the FilterSpecification property
        %   to 'Design parameters', both elements of the InterpolationFactor
        %   vector must be greater than one. When you set the FilterSpecification
        %   property to 'Coefficients', the second element of the
        %   InterpolationFactor vector must be greater than 1.
        %
        %   When you set this property to a 1x3 vector, the i-th element of the
        %   vector specifies the interpolation factor for the i-th filtering
        %   stage. When you set the FilterSpecification property to 'Design
        %   parameters', the second and third elements of the InterpolationFactor
        %   vector must be greater than one and the first element must be 1 or 2.
        %   When you set the FilterSpecification property to 'Coefficients', the
        %   third element of the InterpolationFactor vector must be greater than
        %   1.
        %
        %   When you set the FilterSpecification property to 'Coefficients', you
        %   must set the InterpolationFactor property to a 1x3 or 1x2 vector .
        %
        %   The default is 100.
        InterpolationFactor
        %FilterSpecification Filter specification
        %   Set the filter specification as one of 'Design parameters' |
        %   'Coefficients'. The default is 'Design parameters'. The DUC object
        %   performs interpolation using a cascade of three interpolation
        %   filters. The third filter stage is always a CIC interpolator. When
        %   you set the FilterSpecification property to 'Design parameters', the
        %   object designs the cascade of interpolation filters internally
        %   according to a set of parameters that you specify using the
        %   filter-related object properties. In this case, the first and second
        %   stages of the cascade consist of a halfband or lowpass FIR
        %   interpolator, and a CIC compensator respectively. When you set the
        %   FilterSpecification property to 'Coefficients', you specify an
        %   arbitrary set of filter coefficients for the first and second stages
        %   using the FirstFilterCoefficients, and SecondFilterCoefficients
        %   properties respectively. You specify the number of CIC sections using
        %   the NumCICSections property. In all cases, the first filter stage can
        %   be bypassed by setting the InterpolationFactor property appropriately.
        %
        %   When the input data type is double or single the object implements an
        %   N-section CIC interpolation filter as an FIR filter with a response
        %   that corresponds to a cascade of N boxcar filters. A true CIC filter
        %   with actual comb and integrator sections is implemented when the
        %   input data is of a fixed point type.
        FilterSpecification
        %FirstFilterCoefficients Coefficients of first filter stage
        %   Set this property to a double precision row vector of real
        %   coefficients that correspond to an FIR filter. When you set the
        %   InterpolationFactor property to a 1x2 vector, the object ignores the
        %   value of the FirstFilterCoefficients property because the first filter
        %   stage is bypassed. This property applies when you set the
        %   FilterSpecification property to 'Coefficients'. The default is 1.
        FirstFilterCoefficients
        %SecondFilterCoefficients Coefficients of second filter stage
        %   Set this property to a double precision row vector of real
        %   coefficients that correspond to an FIR filter. Usually, the response
        %   of this filter should be that of a CIC compensator since a CIC
        %   interpolation filter follows the second filter stage. This property
        %   applies when you set the FilterSpecification property to
        %   'Coefficients'. The default is 1.
        SecondFilterCoefficients
        %FirstFilterOrder Order of first filter stage
        %   Set this property to a positive, integer, even scalar. When you set
        %   the InterpolationFactor property to a 1x2 vector, the object ignores
        %   the FirstFilterOrder property because the first filter stage is
        %   bypassed. This property applies when you set the FilterSpecification
        %   property to 'Design parameters' and the MinimumOrderDesign property to
        %   false. The default is 10.
        FirstFilterOrder
        %NumCICSections Number of sections of CIC interpolator
        %   Set this property to a positive, integer scalar. This property applies
        %   when you set the FilterSpecification property to 'Design parameters'
        %   and the MinimumOrderDesign property to false, or when you set the
        %   FilterSpecification property to 'Coefficients'. The default is 3.
        NumCICSections
        %StopbandFrequencySource Source of stopband frequency
        %   Specify the source of the stopband frequency as one of 'Auto' |
        %   'Property'. The default is 'Auto'. When you set this property to
        %   'Auto', the object places the cutoff frequency of the cascade filter
        %   response at approximately Fc = SampleRate/2 Hertz, and computes the
        %   stopband frequency as Fstop = Fc + TW/2. TW is the transition
        %   bandwidth of the cascade response, computed as 2*(Fc-Fp), and the
        %   passband frequency, Fp, equals Bandwidth/2. This property applies when
        %   you set the FilterSpecification property to 'Design parameters'.
        StopbandFrequencySource
    end
    
    properties (Logical, Nontunable)
        %MinimumOrderDesign Minimum order filter design
        %   When you set this property to true the object designs filters with the
        %   minimum order that meets the passband ripple, stopband attenuation,
        %   passband frequency, and stopband frequency specifications that you set
        %   using the PassbandRipple, StopbandAttenuation, Bandwidth,
        %   StopbandFrequencySource, and StopbandFrequency properties. When you
        %   set this property to false, the object designs filters with orders
        %   that you specify in the FirstFilterOrder, SecondFilterOrder, and
        %   NumCICSections properties. The filter designs meet the passband and
        %   stopband frequency specifications that you set using the Bandwidth,
        %   StopbandFrequencySource, and StopbandFrequency properties. This
        %   property applies when you set the FilterSpecification property to
        %   'Design parameters'. The default is true.
        MinimumOrderDesign = true;
    end
    
    % Fixed-point properties
    
    properties (Nontunable)
        % FirstFilterCoefficientsDataType Data type of first filter coefficients
        %   Specify first filter coefficients data type as 'Same as input'
        %   |'Custom'. The default is 'Same as input'. This property applies when
        %   you set the FilterSpecification  property to 'Coefficients'.
        FirstFilterCoefficientsDataType = 'Same as input';
        % CustomFirstFilterCoefficientsDataType Fixed-point data type of first
        %                                       filter coefficients
        %   Specify the first filter coefficients fixed-point type as a scaled
        %   numerictype object with a Signedness of Auto. This property applies
        %   when you set the FirstFilterCoefficientsDataType property to 'Custom'.
        %   The default is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomFirstFilterCoefficientsDataType = numerictype([], 16, 15);
        %FiltersOutputDataType Data type of output of each filter stage
        %   Specify the data type at the output of the first (if it has not been
        %   bypassed), second, and third filter stages as one of 'Same as input'
        %   | 'Custom'. The default is 'Same as input'. The object casts the data
        %   at the output of each filter stage according to the value you set in
        %   this property. For the CIC stage, the casting is done after the
        %   signal has been scaled by the normalization factor.
        FiltersOutputDataType = 'Same as input';
        %CustomFiltersOutputDataType Fixed-point data type of output of each filter stage
        %   Specify the filters output fixed-point type as a scaled numerictype
        %   object with a Signedness of Auto. This property applies when you set
        %   the FiltersOutputDataType property to 'Custom'. The default is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomFiltersOutputDataType = numerictype([], 16, 15);
    end
    
    properties (Access = private)
        %pStage1 Handle to the first stage filter
        pStage1
    end
    
    properties (Nontunable, Access = private)
        %pFiltersOutputNumericType Numeric type of output of each filter stage
        pFiltersOutputNumericType
        %pFirstFilterCoefficientsNumericType Numeric type of first filter
        %coefficients
        pFirstFilterCoefficientsNumericType
        %pFirstdStageFilterFunction Handle to first stage filter helper function
        pFirstStageFilterFunction
    end
    
    properties(Constant, Hidden)
        FilterSpecificationSet  = matlab.system.StringSet( ...
            {'Design parameters', 'Coefficients'});
        StopbandFrequencySourceSet = dsp.CommonSets.getSet(...
            'AutoOrProperty');
        FiltersOutputDataTypeSet = matlab.system.StringSet(...
            {'Same as input','Custom'});
        FirstFilterCoefficientsDataTypeSet = matlab.system.StringSet(...
            {'Same as input','Custom'});
        OscillatorSet = matlab.system.StringSet({'Sine wave','NCO'});
    end
    %---------------------------------------------------------------------------
    % Public methods
    %---------------------------------------------------------------------------
    methods
        function obj = DigitalUpConverter(varargin)
            obj@dsp.private.DigitalConverterBase(varargin{:})
            setProperties(obj, nargin, varargin{:});
        end
        %------------------------------------------------------------------------
        function outputStruct = getFilters(obj,varargin)
            %getFilters Get handles to interpolation filter objects
            %   S = getFilters(H) returns a structure, S, with copies of the filter
            %   System objects and the CIC normalization factor that form the
            %   interpolation filter cascade. The FirstFilterStage structure field
            %   will be empty if the first filter stage has been bypassed. The CIC
            %   normalization factor is equal to the inverse of the CIC filter
            %   gain. In some cases this gain will have a correction factor to
            %   ensure that the cascade response meets the ripple specifications.
            %
            %   getFilters(H,'Arithmetic',ARITH) specifies the arithmetic of the
            %   filter stages. You set input ARITH to 'double', 'single', or
            %   'fixed-point'. When object H is in an unlocked state you must
            %   specify the arithmetic. When object H is in a locked state the
            %   arithmetic input is ignored.
            %
            %   See also visualizeFilterStages, dsp.DigitalUpConverter.fvtool,
            %   groupDelay, getFilterOrders, getInterpolationFactors.
            
            inputArith = parseArithmetic(obj,varargin{:});
            
            % Check if filters have been designed for the specified arithmetic. If
            % no designs are available, design the filters.
            designFilters(obj,inputArith)
            if isLocked(obj)
                if ~isempty(obj.pFilterDesigner.Stage1FilterSysObj)
                    outputStruct.FirstFilterStage = clone(obj.pStage1);
                else
                    outputStruct.FirstFilterStage = [];
                end
                outputStruct.SecondFilterStage = clone(obj.pCICComp);
                outputStruct.CICInterpolator = clone(obj.pCIC);
                outputStruct.CICNormalizationFactor = obj.pFilterDesigner.GainFilter;
            else
                outputStruct.FirstFilterStage = obj.pFilterDesigner.Stage1FilterSysObj;
                outputStruct.CICNormalizationFactor = obj.pFilterDesigner.GainFilter;
                outputStruct.SecondFilterStage = obj.pFilterDesigner.CICCompFilterSysObj;
                outputStruct.CICInterpolator = obj.pFilterDesigner.CICFilterSysObj;
                
                % if arithmetic was fixed-point and filter input type or
                % output data type was set to 'same as input', then switch
                % to full precision
                if strcmpi(inputArith,'fixed')
                    if strcmp(obj.FiltersOutputDataType,'Same as input')
                        if ~isempty(obj.pFilterDesigner.Stage1FilterSysObj)
                            outputStruct.FirstFilterStage.ProductDataType = 'Full precision';
                            outputStruct.FirstFilterStage.AccumulatorDataType = 'Full precision';
                        end
                        outputStruct.SecondFilterStage.ProductDataType = 'Full precision';
                        outputStruct.SecondFilterStage.AccumulatorDataType = 'Full precision';
                        outputStruct.CICInterpolator.FixedPointDataType = 'Full precision';
                    end
                    if strcmp(obj.OutputDataType,'Same as input')
                        if ~isempty(obj.pFilterDesigner.Stage1FilterSysObj)
                            outputStruct.FirstFilterStage.OutputDataType = 'Same as accumulator';
                        end
                        outputStruct.SecondFilterStage.OutputDataType = 'Same as accumulator';
                    end
                end
            end
        end
        %------------------------------------------------------------------------
        function outputStruct = getFilterOrders(obj,varargin)
            %getFilterOrders Get orders of interpolation filters
            %   S = getFilterOrders(H) returns a structure, S, that contains the
            %   orders of the interpolation filter stages. The FirstFilterOrder
            %   structure field will be empty if the first filter stage has been
            %   bypassed.
            %
            %   See also visualizeFilterStages, dsp.DigitalUpConverter.fvtool,
            %   groupDelay, getFilters, getInterpolationFactors.
            
            assertScalar(obj);
            % If no design is available, design filters using double arithmetic.
            if ~isLocked(obj.pFilterDesigner)
                obj.pFilterDesigner.Arithmetic = 'double';
                step(obj.pFilterDesigner, []);
            end
            
            interpFactors = getInterpolationFactors(obj);
            if ~isempty(obj.pFilterDesigner.Stage1FilterSysObj)
                outputStruct.FirstFilterOrder = length(obj.pFilterDesigner.Stage1FilterSysObj.Numerator)-1;
            else
                outputStruct.FirstFilterOrder = [];
            end
            outputStruct.SecondFilterOrder = length(obj.pFilterDesigner.CICCompFilterSysObj.Numerator)-1;
            if strcmpi(obj.pFilterDesigner.Arithmetic, 'fixed');
                outputStruct.NumCICSections = obj.pFilterDesigner.CICFilterSysObj.NumSections;
            else
                outputStruct.NumCICSections = ...
                    (length(obj.pFilterDesigner.CICFilterSysObj.Numerator)-1)/(interpFactors(end)-1);
            end
        end
        %------------------------------------------------------------------------
        function M = getInterpolationFactors(obj)
            %getInterpolationFactors Get interpolation factors of each filter stage
            %   M = getInterpolationFactors(H) returns a vector, M, with the
            %   interpolation factors of each filter stage. If the first filter
            %   stage is bypassed, then M is a 1x2 vector containing the
            %   interpolation factors of the second and third stages in the first
            %   and second elements respectively. If the first filter stage is not
            %   bypassed then M is a 1x3 vector containing the interpolation
            %   factors of the first, second and third filter stages.
            %
            %   See also visualizeFilterStages, dsp.DigitalUpConverter.fvtool,
            %   groupDelay, getFilters, getFilterOrders.
            
            assertScalar(obj);
            % If no design is available, design filters using double arithmetic.
            if ~isLocked(obj.pFilterDesigner)
                obj.pFilterDesigner.Arithmetic = 'double';
                step(obj.pFilterDesigner, []);
            end
            
            M = getInterpolationFactors(obj.pFilterDesigner);
            
            if isFirstStageBypassed(obj.pFilterDesigner)
                M = M(2:end);
            end
        end
        %-----------------------------------------------------------------------
        % Set/Get methods
        %------------------------------------------------------------------------
        %CenterFrequency
        function set.CenterFrequency(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','real'},'', 'CenterFrequency');
            obj.CenterFrequency = val;
        end
        %---------------------------------------------
        %SampleRate
        function set.SampleRate(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','real'},'', 'SampleRate');
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj);
            obj.pFilterDesigner.SampleRate = val;
        end
        
        function val = get.SampleRate(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.SampleRate;
        end
        %---------------------------------------------
        %InterpolationFactor
        function set.InterpolationFactor(obj,val)
            validateattributes(val, ...
                {'double'},{'row','positive','integer'},'', 'InterpolationFactor'); 
            
            coder.internal.errorIf((length(val) ~= 1) && (length(val) ~= 2) && (length(val) ~= 3), ...
                'dsp:system:DigitalUpConverter_invalidInterpFactor')
            
            if (length(val) == 1)
                coder.internal.errorIf(val < 2, 'dsp:system:DigitalUpConverter_invalidInterpFactorScalar')
            end
            
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.InterpolationFactor = val;
        end
        
        function val = get.InterpolationFactor(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.InterpolationFactor;
        end
        %---------------------------------------------
        %FilterSpecification
        function set.FilterSpecification(obj,val)
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.FilterSpecification = val;
        end
        
        function val = get.FilterSpecification(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.FilterSpecification;
        end
        %---------------------------------------------
        %MinimumOrderDesign
        function set.MinimumOrderDesign(obj,val)
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.MinimumOrderDesign = val;
            obj.MinimumOrderDesign = val;
        end
        
        function val = get.MinimumOrderDesign(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.MinimumOrderDesign;
        end
        %---------------------------------------------
        %NumCICSections
        function set.NumCICSections(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','integer'},'', 'NumCICSections');
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.OrderStage3 = val;
        end
        
        function val = get.NumCICSections(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.OrderStage3;
        end
        %---------------------------------------------
        %SecondFilterCoefficients
        function set.SecondFilterCoefficients(obj,val)
            validateattributes(val, ...
                {'double'},{'row','real'},'', 'SecondFilterCoefficients');
            
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.CoefficientsStage2 = val;
        end
        
        function val = get.SecondFilterCoefficients(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.CoefficientsStage2;
        end
        %---------------------------------------------
        %FirstFilterCoefficients
        function set.FirstFilterCoefficients(obj,val)
            validateattributes(val, ...
                {'double'},{'row','real'},'', 'FirstFilterCoefficients');
            
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.CoefficientsStage1 = val;
        end
        
        function val = get.FirstFilterCoefficients(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.CoefficientsStage1;
        end
        %---------------------------------------------
        %FirstFilterOrder
        function set.FirstFilterOrder(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','integer'},'', 'FirstFilterOrder');
            
            coder.internal.errorIf(mod(val,2) ~= 0, ...
                'dsp:system:DigitalUpConverter_oddFirstFilterOrder')
            
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.OrderStage1 = val;
        end
        
        function val = get.FirstFilterOrder(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.OrderStage1;
        end
        %---------------------------------------------
        %StopbandFrequencySource
        function set.StopbandFrequencySource(obj,val)
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.StopbandFrequencySource = val;
        end
        
        function val = get.StopbandFrequencySource(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.StopbandFrequencySource;
        end
        %---------------------------------------------
        % Fixed point properties
        %---------------------------------------------
        function set.CustomFirstFilterCoefficientsDataType(obj,val)
            validateCustomDataType(obj,'CustomFirstFilterCoefficientsDataType',val, ...
                {'AUTOSIGNED','SCALED'});
            obj.CustomFirstFilterCoefficientsDataType = val;
        end
        function set.CustomFiltersOutputDataType(obj,val)
            validateCustomDataType(obj,'CustomFiltersOutputDataType',val, ...
                {'AUTOSIGNED','SCALED'});
            obj.CustomFiltersOutputDataType = val;
        end
    end
    %--------------------------------------------------------------------------
    % Protected methods
    %--------------------------------------------------------------------------
    methods (Access = protected)
        function num = getNumInputsImpl(~)
            num = 1;
        end
        %------------------------------------------------------------------------
        function flag = isInactivePropertyImpl(obj, prop)
            flag = false;
            switch prop
                case {'FirstFilterCoefficients', 'SecondFilterCoefficients'}
                    if strcmp(obj.FilterSpecification,'Design parameters')
                        flag = true;
                    end
                case 'NumCICSections'
                    if strcmp(obj.FilterSpecification,'Design parameters') && ...
                            obj.MinimumOrderDesign
                        flag = true;
                    end
                case {'FirstFilterOrder', 'SecondFilterOrder'}
                    if (strcmp(obj.FilterSpecification,'Design parameters') && ...
                            obj.MinimumOrderDesign) || ...
                            ~strcmp(obj.FilterSpecification,'Design parameters')
                        flag = true;
                    end
                case {'PassbandRipple','StopbandAttenuation'}
                    if (strcmp(obj.FilterSpecification,'Design parameters') &&  ...
                            ~obj.MinimumOrderDesign) || ...
                            ~strcmp(obj.FilterSpecification,'Design parameters')
                        flag = true;
                    end
                case 'StopbandFrequency'
                    if (strcmp(obj.FilterSpecification,'Design parameters') && ...
                            strcmp(obj.StopbandFrequencySource,'Auto')) || ...
                            ~strcmp(obj.FilterSpecification,'Design parameters')
                        flag = true;
                    end
                case {'MinimumOrderDesign', 'Bandwidth', 'StopbandFrequencySource'}
                    if ~strcmp(obj.FilterSpecification,'Design parameters')
                        flag = true;
                    end
                case {'NumAccumulatorBits','NumQuantizedAccumulatorBits','Dither'}
                    if strcmp(obj.Oscillator,'Sine wave')
                        flag = true;
                    end
                case 'NumDitherBits'
                    if strcmp(obj.Oscillator,'Sine wave') || ...
                            ~obj.Dither
                        flag = true;
                    end
                case 'CustomOutputDataType'
                    if ~matlab.system.isSpecifiedTypeMode(obj.OutputDataType)
                        flag = true;
                    end
                case 'CustomFiltersOutputDataType'
                    if ~matlab.system.isSpecifiedTypeMode(obj.FiltersOutputDataType)
                        flag = true;
                    end
                case {'FirstFilterCoefficientsDataType', 'SecondFilterCoefficientsDataType'}
                    if strcmp(obj.FilterSpecification,'Design parameters')
                        flag = true;
                    end
                case 'CustomFirstFilterCoefficientsDataType'
                    if strcmp(obj.FilterSpecification,'Design parameters') || ...
                            ~matlab.system.isSpecifiedTypeMode(obj.FirstFilterCoefficientsDataType)
                        flag = true;
                    end
                case 'CustomSecondFilterCoefficientsDataType'
                    if strcmp(obj.FilterSpecification,'Design parameters') || ...
                            ~matlab.system.isSpecifiedTypeMode(obj.SecondFilterCoefficientsDataType)
                        flag = true;
                    end
            end
        end
        %------------------------------------------------------------------
        function resetImpl(obj)
            reset(obj.pCIC)
            reset(obj.pCICComp)
            if ~isFirstStageBypassed(obj.pFilterDesigner)
                reset(obj.pStage1)
            end
            reset(obj.pOscillator)
        end
        %------------------------------------------------------------------
        function releaseImpl(obj)
            release(obj.pOscillator);
            release(obj.pFilterDesigner);
        end
        %------------------------------------------------------------------
        function setupImpl(obj, x)
            
            % Get size and data type of input
            obj.pInputSize = size(x);
            
            obj.pInputDataType = getInputType(obj,x);
            
            % Validate dimensions of input vector. X must be a column vector.
            coder.internal.errorIf(~iscolumn(x) || isempty(x), ...
                'MATLAB:system:inputMustBeColVector','X');
            
            % Get the numeric type if input is fixed point, set all input type
            % properties.
            setInputOutputTypes(obj,x)
            
            if obj.pIsInputFixedPoint
                % Set the numeric type of the filter outputs, and the filter
                % coefficients if user specified coefficients
                
                if strcmp(obj.FiltersOutputDataType,'Same as input')
                    obj.pFiltersOutputNumericType = numerictype([],...
                        obj.pInputNumericType.WordLength,...
                        obj.pInputNumericType.FractionLength);
                else
                    obj.pFiltersOutputNumericType = numerictype([],...
                        obj.CustomFiltersOutputDataType.WordLength,...
                        obj.CustomFiltersOutputDataType.FractionLength);
                end
                
                if strcmp(obj.FilterSpecification,'Coefficients')
                    if strcmp(obj.FirstFilterCoefficientsDataType,'Same as input')
                        obj.pFirstFilterCoefficientsNumericType = numerictype([],...
                            obj.pInputNumericType.WordLength,...
                            obj.pInputNumericType.FractionLength);
                    else
                        obj.pFirstFilterCoefficientsNumericType = numerictype([],...
                            obj.CustomFirstFilterCoefficientsDataType.WordLength,...
                            obj.CustomFirstFilterCoefficientsDataType.FractionLength);
                    end
                end
            end
            
            % Design the interpolation filter stages.
            designInterpolatorCascade(obj);
            
            % Calculate data size at the output of the interpolation cascade
            sz = [obj.pInputSize(1)*prod(obj.InterpolationFactor) 1];
            
            % Allocate buffer with predefined data type for [cic-normalization
            % factor] output.
            if obj.pIsInputFixedPoint
                obj.pInitCICNormOutput = fi(complex(zeros(sz)),obj.pFiltersOutputNumericType);
            else
                obj.pInitCICNormOutput = complex(zeros(sz, obj.pInputDataType));
            end
            
            % Allocate buffer with predefined data type for oscillator and mixer
            % outputs. Define oscillator output data type.
            if obj.pIsInputFixedPoint
                obj.pInitMixerOutput = fi(zeros(sz),obj.pOutputNumericType);
                
                obj.pOscillatorOutputNumericType = ...
                    numerictype([],obj.pFiltersOutputNumericType.WordLength+1,...
                    obj.pFiltersOutputNumericType.WordLength-1);
                obj.pInitOscillatorOutput = ...
                    fi(complex(zeros(sz)), obj.pOscillatorOutputNumericType);
            else
                obj.pInitMixerOutput = zeros(sz, obj.pInputDataType);
                obj.pInitOscillatorOutput = complex(zeros(sz, obj.pInputDataType));
            end
            
            % Design the oscillator - pass the frame length and sampling rate to
            % the designOscillator method
            designOscillator(obj,sz(1),...
                obj.SampleRate*prod(obj.InterpolationFactor))
            
            % Assign function handles
            % pThirdStageFilterFunction and pOutputCastFunction
            if isFirstStageBypassed(obj.pFilterDesigner)
                obj.pFirstStageFilterFunction = @dsp.DigitalUpConverter.noAction;
            else
                obj.pFirstStageFilterFunction = ...
                    @dsp.DigitalUpConverter.filterWithFirstStage;
            end
            
            if obj.pCastOutputToBuiltInInteger
                obj.pOutputCastFunction = ...
                    @dsp.DigitalUpConverter.castOutputDataToBuiltInInteger;
            elseif obj.pCastOutputToFloatingFi
                obj.pOutputCastFunction = ...
                    @dsp.DigitalUpConverter.castOutputDataToFloatingFi;
            else
                obj.pOutputCastFunction = @dsp.DigitalUpConverter.noAction;
            end
            
            if obj.pIsInputFixedPoint
                obj.pNormalizeCICOutputFunction = ...
                    @dsp.DigitalUpConverter.normalizeFixedPoint;
            else
                obj.pNormalizeCICOutputFunction = ...
                    @dsp.DigitalUpConverter.normalizeFloatingPoint;
            end
            
        end

        %------------------------------------------------------------------------
        function y = stepImpl(obj,x,varargin)
            % Frequency up conversion
            
            % First filter stage
            s1 = obj.pFirstStageFilterFunction(obj,x);
            
            % CIC compensator interpolator
            s2 = step(obj.pCICComp, s1);
            
            % CIC stage and CIC normalization
            
            % pInitCICNormOutput is a vector of zeros with the data type that we
            % want to have at the output of the normalized CIC filter. Assigning the
            % output to s3(:) automatically casts the normalized filter output to
            % the data type in s3.
            s3 = step(obj.pCIC,s2);
            s4 = obj.pInitCICNormOutput;
            s4(:) = obj.pNormalizeCICOutputFunction(obj,s3);
            
            % Oscillator
            
            % sqrt(2) normalization to compensate for the carrier power is embedded
            % in the pCICNormalizationFactor
            w = obj.pInitOscillatorOutput;
            w(:) = step(obj.pOscillator);
            
            % Mixer
            s5 = obj.pInitMixerOutput;
            % Cast the mixer output to data type in pInitMixerOutput
            s5(:) = real(s4.*w);
            
            % Final cast (to built in integers, fi double, or fi single)
            y = obj.pOutputCastFunction(obj,s5);
        end
        %------------------------------------------------------------------------
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@dsp.private.DigitalConverterBase(obj);
            s.pFilterDesigner = matlab.System.saveObject(obj.pFilterDesigner);
            if isLocked(obj)
                s.pStage1 = matlab.System.saveObject(obj.pStage1);
                s.pFirstStageFilterFunction = obj.pFirstStageFilterFunction;
                s.pFiltersOutputNumericType = obj.pFiltersOutputNumericType;
                s.pFirstFilterCoefficientsNumericType = obj.pFirstFilterCoefficientsNumericType;
            end
        end
        %------------------------------------------------------------------------
        function loadObjectImpl(obj, s,wasLocked)
            loadSubObjects(obj,s,wasLocked);
            
            if wasLocked
                obj.pStage1                             = matlab.System.loadObject(s.pStage1);
                obj.pFirstStageFilterFunction           = s.pFirstStageFilterFunction;
                obj.pFiltersOutputNumericType           = s.pFiltersOutputNumericType;
                obj.pFirstFilterCoefficientsNumericType = s.pFirstFilterCoefficientsNumericType;
            end
            % Call the base class method
            loadObjectImpl@matlab.System(obj, s);
            % load filterdesigner at the end to preserve its locked status
            obj.pFilterDesigner = matlab.System.loadObject(s.pFilterDesigner);
        end
        %------------------------------------------------------------------
        function fd = getFilterDesigner(~)
            % Return the filter designer to be used. This is called from
            % the base class constructor
            fd = dsp.private.UpConverterFilterDesigner;
        end
        %------------------------------------------------------------------
        function customFiltersDataType = getCustomFiltersDataType(obj)
            % Return the custom filter output data type. This is called from
            % designFilters in base class
            customFiltersDataType = obj.CustomFiltersOutputDataType;
        end
        %------------------------------------------------------------------------
        function flag = isFilterCoefficientsDataTypeSameAsInput(obj)
            % Return true if any of the FirstFilterCoefficientsDataType or
            % SecondFilterCoefficientsDataType properties are set to 'Same as
            % input'.
            flag = strcmp(obj.FirstFilterCoefficientsDataType,'Same as input') || ...
                strcmp(obj.SecondFilterCoefficientsDataType,'Same as input');
        end
        %------------------------------------------------------------------------
        function checkFactorLength(obj)
            % Error out if interpolation factor is not a 1x2 or 1x3 vector
            coder.internal.errorIf(length(obj.InterpolationFactor)~= 3 && length(obj.InterpolationFactor)~= 2, ...
                'dsp:system:DigitalUpConverter_interpFactorNotVector');
        end
        %------------------------------------------------------------------------
        function checkFactorValues(obj)
            % Check value of InterpolationFactor vector
            if strcmp(obj.FilterSpecification,'Design parameters')
                if length(obj.InterpolationFactor) == 3
                    coder.internal.errorIf(obj.InterpolationFactor(1) > 2, ...
                        'dsp:system:DigitalUpConverter_invalidInterpFactorFirstElement');
                end
                
                if length(obj.InterpolationFactor) > 1
                    coder.internal.errorIf(any(obj.InterpolationFactor(2:end) < 2), ...
                        'dsp:system:DigitalUpConverter_invalidInterpFactorSecondThirdElements');
                end
            else
                if length(obj.InterpolationFactor) > 1
                    coder.internal.errorIf(any(obj.InterpolationFactor(end) < 2), ...
                        'dsp:system:DigitalUpConverter_invalidInterpFactorThirdElement');
                end
            end
        end
        %------------------------------------------------------------------------
        function checkFsFc(obj)
            % Check that sample rate at oscillator input is at least twice the
            % oscillator frequency
            
            coder.internal.errorIf(obj.SampleRate*prod(obj.InterpolationFactor) < 2*obj.CenterFrequency, ...
                    'dsp:system:DigitalUpConverter_InvalidFs');
        end
        %------------------------------------------------------------------------
        function setCustomCoefficientsDataType(obj)
            % Set coefficient data types of filter designer to the custom data
            % types specified by the user
            if ~isequivalent(obj.pFilterDesigner.CoefficientsStage1DataType, ...
                    obj.CustomFirstFilterCoefficientsDataType)
                release(obj.pFilterDesigner);  % Need to design filters again
                obj.pFilterDesigner.CoefficientsStage1DataType = ...
                    obj.CustomFirstFilterCoefficientsDataType;
            end
            if ~isequivalent(obj.pFilterDesigner.CoefficientsStage2DataType, ...
                    obj.CustomSecondFilterCoefficientsDataType)
                release(obj.pFilterDesigner);  % Need to design filters again
                obj.pFilterDesigner.CoefficientsStage2DataType = ...
                    obj.CustomSecondFilterCoefficientsDataType;
            end
        end
        %------------------------------------------------------------------
        function designDesignerIfEmpty(obj)
            % If a System object is loaded from previous release that
            % doesn't contain a saved FilterDesigner then create one
            if isempty(obj.pFilterDesigner)
                obj.pFilterDesigner = dsp.private.UpConverterFilterDesigner;
            end
        end
        %------------------------------------------------------------------
        function releaseDesignerIfLocked(obj)
            if isLocked(obj.pFilterDesigner)
                release(obj.pFilterDesigner);
            end
            obj.pFilterDesigner.IsFilterDesignAvailable = false;
        end
    end
    %--------------------------------------------------------------------------
    % Private methods
    %--------------------------------------------------------------------------
    methods (Access = private)
        %------------------------------------------------------------------------
        function designInterpolatorCascade(obj)
            % Design interpolation filters
            
            if strcmpi(obj.pArithmetic,'fixed') || ...
                    ~obj.pFilterDesigner.IsFilterDesignAvailable
                % If filters are not available for non fixed-point
                % arithmetic, then need to design them
                
                if isLocked(obj.pFilterDesigner)
                    release(obj.pFilterDesigner);  % Need to design filters again
                end
                
                %If user specified filter coefficients, and arithmetic is fixed, then
                %set the coefficient data types on the designer object.
                if strcmp(obj.FilterSpecification,'Coefficients') && ...
                        strcmp(obj.pArithmetic,'fixed')
                    obj.pFilterDesigner.CoefficientsStage1DataType = ...
                        obj.pFirstFilterCoefficientsNumericType;
                    obj.pFilterDesigner.CoefficientsStage2DataType = ...
                        obj.pSecondFilterCoefficientsNumericType;
                end
                
                %Check if a design is available before calling the design method of the
                %filter designer object. Make sure that the available design has an
                %arithmetic that is congruent with the input data type.
                if strcmpi(obj.pArithmetic,'fixed')
                    inputFixedPointArguments = obj.pFiltersOutputNumericType;
                else
                    inputFixedPointArguments = [];
                end
                
                obj.pFilterDesigner.Arithmetic = obj.pArithmetic;
                if obj.pIsInputFixedPoint
                    obj.pFilterDesigner.InputNumericType = obj.pInputNumericType;
                    obj.pFilterDesigner.OutputNumericType = obj.pOutputNumericType;
                end
                step(obj.pFilterDesigner, inputFixedPointArguments);
            end
                        
            %Set the properties with the filter System objects
            obj.pStage1 = obj.pFilterDesigner.Stage1FilterSysObj;
            obj.pCICComp = obj.pFilterDesigner.CICCompFilterSysObj;
            obj.pCIC = obj.pFilterDesigner.CICFilterSysObj;
            
            % Embed the carrier normalization (sqrt(2)) factor.
            normFactor = sqrt(2)*obj.pFilterDesigner.GainFilter;
            
            % Set fixed point properties of filters
            if obj.pIsInputFixedPoint
                
                obj.pCICNormalizationFactor = normFactor;
                % CIC Normalization
                % Find the number of shifts needed to normalize up to the closest
                % power of 2 (coarse gain).
                numCICOutputShifts = abs(nextpow2(obj.pCICNormalizationFactor));
                
                % The remaining normalization factor is done by multiplication with
                % the shifted CIC output (fine gain). We set the word length of this
                % value to 16 bits. We know this number is in the interval [0.5
                % 1]*sqrt(2).
                obj.pRemNormFactor = fi(...
                    (2^numCICOutputShifts)*obj.pCICNormalizationFactor, true, 16, 14);
                
                % WL at CIC output
                numCICOutputBits = coder.const(obj.pFiltersOutputNumericType.WordLength + ...
                    ceil(log2(obj.pCIC.InterpolationFactor^(obj.pCIC.NumSections-1))));
                fl = coder.const(obj.pFiltersOutputNumericType.FractionLength+numCICOutputShifts);
                
                % Set the numeric type object that will be used to reinterpret cast
                % the CIC output and achieve the nextpow2 coarse normalization gain.
                obj.pReinterpretCastNumericType = numerictype(true,numCICOutputBits,fl);
                
            else % Input is not fixed point
                obj.pCICNormalizationFactor = cast(...
                    normFactor,obj.pInputDataType);
            end
        end
    end
    methods (Static, Hidden)
        % Needed by helpFixedPoint and getPropertyGroupsImpl
        function props = getDisplayFixedPointProperties()
            props = {...
                'FirstFilterCoefficientsDataType',...
                'CustomFirstFilterCoefficientsDataType',...
                'SecondFilterCoefficientsDataType',...
                'CustomSecondFilterCoefficientsDataType',...
                'FiltersOutputDataType',...
                'CustomFiltersOutputDataType',...
                'OutputDataType',...
                'CustomOutputDataType'};
        end
        
        %-------------------------------------------------------------------------
        % Static Helper Methods
        
        function dataOut = filterWithFirstStage(obj,dataIn)
            dataOut = step(obj.pStage1,dataIn);
        end
        
        function dataOut = castOutputDataToBuiltInInteger(obj,dataIn)
            dataOut = cast(dataIn,obj.pInputDataType);
        end
        
        function dataOut = castOutputDataToFloatingFi(obj,dataIn)
            dataOut = fi(dataIn,obj.pInputNumericType);
        end
        
        function dataOut = noAction(~,dataIn)
            dataOut = dataIn;
        end
        
        function dataOut = normalizeFixedPoint(obj,dataIn)
            %   Normalize (coarse gain) using reinterpretcast method. Complete
            %   remaining normalization (fine gain) with multiplication
            x = reinterpretcast(dataIn,obj.pReinterpretCastNumericType);
            dataOut = x*obj.pRemNormFactor;
        end
        
        function dataOut = normalizeFloatingPoint(obj,dataIn)
            dataOut = dataIn*obj.pCICNormalizationFactor;
        end
    end
    %----------------------------------------------------------------------
    % Hidden methods
    %----------------------------------------------------------------------
    methods (Hidden)
        function hdlStruct = getFixedPointParameters(obj)
            % Return a structure with internal fixed point settings for HDL code
            % generation.
            
            coder.internal.errorIf(~isLocked(obj), ...
                'dsp:system:DigitalUpConverter_invalidObjectState');
            
            if obj.pIsInputFixedPoint
                
                hdlStruct.InputNumericType = obj.pInputNumericType;
                
                % Return NCO object
                if strcmp(obj.Oscillator,'NCO')
                    hdlStruct.NCOObject = clone(obj.pOscillator);
                end
                
                % Filters output data type
                hdlStruct.FiltersOutputNumericType = obj.pFiltersOutputNumericType;
                
                % Coarse CIC scaling output data type
                hdlStruct.CoarseCICScalingOutputNumericType = ...
                    obj.pReinterpretCastNumericType;
                
                % Fine scaling value
                hdlStruct.FineCICScaling = obj.pRemNormFactor;
                
                % Output numeric type
                hdlStruct.OutputNumericType = obj.pOutputNumericType;
            else
                % Return empty structure if input is floating point
                hdlStruct = struct;
            end
        end
        %------------------------------------------------------------------------
        function rateChangeFactors = getRateChangeFactors(obj)
            % Return the rate change factor for HDL code generation.
            intFac = getInterpolationFactors(obj);
            if length(intFac) == 2
                M = [1 intFac];
            else
                M = intFac;
            end
            rateChangeFactors = [M' ones(3,1)];
        end
    end

    %--------------------------------------------------------------------------
    % Static methods
    %--------------------------------------------------------------------------
    methods(Static)
        function helpFixedPoint
            %helpFixedPoint Display dsp.DigitalUpConverter System object fixed-point
            %               information
            %   dsp.DigitalUpConverter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.DigitalUpConverter
            %   System object.
            
            matlab.system.dispFixptHelp('dsp.DigitalUpConverter', ...
                dsp.DigitalUpConverter.getDisplayFixedPointProperties);
        end
    end

    
    methods(Static,Hidden,Access=protected)
        function groups = getPropertyGroupsImpl
            props = {...
                'SampleRate',...
                'InterpolationFactor',...
                'FilterSpecification',...
                'MinimumOrderDesign',...
                'FirstFilterCoefficients',...
                'SecondFilterCoefficients',...
                'FirstFilterOrder',...
                'SecondFilterOrder',...
                'NumCICSections',...
                'Bandwidth',...
                'StopbandFrequencySource',...
                'StopbandFrequency',...
                'PassbandRipple',...
                'StopbandAttenuation',...
                'Oscillator',...
                'CenterFrequency',...
                'NumAccumulatorBits',...
                'NumQuantizedAccumulatorBits',...
                'Dither',...
                'NumDitherBits'};
            mainS = matlab.system.display.Section('Title', 'Parameters', ...
                'PropertyList', props);
            mainSG = matlab.system.display.SectionGroup('Title', 'Main', ...
                'Sections', mainS);
            dt = matlab.system.display.SectionGroup('Title', 'Data Types', ...
                'PropertyList', ...
                dsp.DigitalUpConverter.getDisplayFixedPointProperties);
            groups = [mainSG, dt];
        end
    end
end

