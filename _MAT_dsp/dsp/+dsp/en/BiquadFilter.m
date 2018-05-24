classdef BiquadFilter< handle
%BiquadFilter Biquadratic IIR (SOS) filter structures
%   HBQD = dsp.BiquadFilter returns a biquadratic IIR (SOS) filter System
%   object, HBQD, which independently filters each channel of the input
%   over successive calls to step method using a specified biquadratic
%   structure.
%
%   HBQD = dsp.BiquadFilter('PropertyName', PropertyValue, ...) returns a
%   biquadratic filter object, HBQD, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   Y = step(HBQD, X) filters the real or complex input signal X, and
%   outputs the filtered values, Y. The System object filters each channel
%   of the input signal independently over successive calls to step method.
%
%   Y = step(HBQD, X, NUM, DEN) performs filtering using NUM as the
%   numerator coefficients, and DEN as the denominator coefficients of the
%   biquad filter, to filter the signal X and output the filtered signal Y.
%   NUM must be a 3-by-N numeric matrix and DEN must be a 2-by-N numeric
%   matrix, where N is the number of biquad filter sections. The object
%   assumes the first denominator coefficient of each section to be 1. This
%   configuration is applicable when the SOSMatrixSource property is 'Input
%   port' and the ScaleValuesInputPort property is false.
%
%   Y = step(HBQD, X, NUM, DEN, G) performs filtering using NUM as the
%   numerator coefficients, DEN as the denominator coefficients and G as
%   the scale values of the biquad filter, to filter the signal X and
%   output the filtered signal Y. NUM must be a 3-by-N numeric matrix, DEN
%   must be a 2-by-N numeric matrix and G must be a 1-by-(N+1) numeric
%   vector, where N is the number of biquad filter sections. The object
%   assumes the first denominator coefficient of each section to be 1. This
%   configuration is applicable when the SOSMatrixSource property is 'Input
%   port' and the ScaleValuesInputPort property is true.
%
%   BiquadFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create biquadratic filter object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset filter states to initial conditions
%
%   BiquadFilter properties:
%
%   Structure                    - Filter structure
%   SOSMatrixSource              - SOS Matrix source
%   SOSMatrix                    - SOS matrix
%   ScaleValues                  - Scale values for each biquad section
%   InitialConditions            - Initial conditions for direct form II
%                                  structures
%   NumeratorInitialConditions   - Initial conditions on zeros side
%   DenominatorInitialConditions - Initial conditions on poles side
%   OptimizeUnityScaleValues     - Optimize unity scale values
%   ScaleValuesInputPort         - How to specify scale values
%   FrameBasedProcessing         - Process input in frames or as samples
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.BiquadFilter.helpFilterAnalysis.
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.BiquadFilter.helpFixedPoint.
%
%   % EXAMPLE 1: Remove high-frequency sinusoid using a biquad filter.
%   % Initialize
%   f1 = 1000; f2 = 3000; Fs = 8000; Fcutoff = 2000;
%   hSR   = dsp.SineWave('Frequency',[f1,f2],'SampleRate',Fs,...
%       'SamplesPerFrame',1024); % Input composed of 1 KHz and 3 KHz sinusoids.
%   [z,p,k] = butter(10,Fcutoff/(Fs/2)); [s,g] = zp2sos(z,p,k);
%   hBqdFilter = dsp.BiquadFilter('Structure', 'Direct form I', ...
%       'SOSMatrix', s,'ScaleValues', g);
%   hplot = dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',...
%       false,'ShowLegend',true,'YLimits',[-150 30],...
%       'Title','Input Signal (Channel 1) Output Signal (Channel 2)');
%   % Stream
%   for k = 1:100
%       input = sum(step(hSR),2); % Add the two sinusoids together
%       filteredOutput = step(hBqdFilter,input);
%       step(hplot,[input,filteredOutput]);
%   end
% 
%   % EXAMPLE 2: Design an elliptic IIR lowpass filter, filter white
%   % Gaussian noise with the resulting dsp.BiquadFilter and estimate the
%   % transfer function.
%   % Initialize
%   Fs = 96e3;filtSpecs = fdesign.lowpass(20e3,22.05e3,1,80,Fs);
%   hBF = design(filtSpecs,'ellip','SystemObject',true);                                                                 
%   htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided',...
%           'SpectralAverages',50);
%   hplot = dsp.ArrayPlot('PlotType','Line','YLimits',[-100 5],...
%           'YLabel','Magnitude (dB)','XLabel','Frequency (Hz)',...
%           'SampleIncrement',Fs/1024,'ShowLegend',true,...
%           'Title',...
%           'Magnitude Response; Exact (channel 1), Estimate (channel 2)');
%   Htrue = freqz(hBF,513); % Compute exact transfer function
%   % Stream
%   Niter = 1000;
%   for k = 1:Niter
%       x = randn(1024,1);  % Input signal = white Gaussian noise
%       y = step(hBF,x);    % Filter noise with Biquad filter
%       H = step(htfe,x,y); % Compute transfer function estimate
%       step(hplot,20*log10(abs([Htrue,H]))); % Plot estimate
%   end
%
%   See also dsp.DigitalFilter,
%            dsp.BiquadFilter.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=BiquadFilter
            %BiquadFilter Biquadratic IIR (SOS) filter structures
            %   HBQD = dsp.BiquadFilter returns a biquadratic IIR (SOS) filter System
            %   object, HBQD, which independently filters each channel of the input
            %   over successive calls to step method using a specified biquadratic
            %   structure.
            %
            %   HBQD = dsp.BiquadFilter('PropertyName', PropertyValue, ...) returns a
            %   biquadratic filter object, HBQD, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HBQD, X) filters the real or complex input signal X, and
            %   outputs the filtered values, Y. The System object filters each channel
            %   of the input signal independently over successive calls to step method.
            %
            %   Y = step(HBQD, X, NUM, DEN) performs filtering using NUM as the
            %   numerator coefficients, and DEN as the denominator coefficients of the
            %   biquad filter, to filter the signal X and output the filtered signal Y.
            %   NUM must be a 3-by-N numeric matrix and DEN must be a 2-by-N numeric
            %   matrix, where N is the number of biquad filter sections. The object
            %   assumes the first denominator coefficient of each section to be 1. This
            %   configuration is applicable when the SOSMatrixSource property is 'Input
            %   port' and the ScaleValuesInputPort property is false.
            %
            %   Y = step(HBQD, X, NUM, DEN, G) performs filtering using NUM as the
            %   numerator coefficients, DEN as the denominator coefficients and G as
            %   the scale values of the biquad filter, to filter the signal X and
            %   output the filtered signal Y. NUM must be a 3-by-N numeric matrix, DEN
            %   must be a 2-by-N numeric matrix and G must be a 1-by-(N+1) numeric
            %   vector, where N is the number of biquad filter sections. The object
            %   assumes the first denominator coefficient of each section to be 1. This
            %   configuration is applicable when the SOSMatrixSource property is 'Input
            %   port' and the ScaleValuesInputPort property is true.
            %
            %   BiquadFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create biquadratic filter object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset filter states to initial conditions
            %
            %   BiquadFilter properties:
            %
            %   Structure                    - Filter structure
            %   SOSMatrixSource              - SOS Matrix source
            %   SOSMatrix                    - SOS matrix
            %   ScaleValues                  - Scale values for each biquad section
            %   InitialConditions            - Initial conditions for direct form II
            %                                  structures
            %   NumeratorInitialConditions   - Initial conditions on zeros side
            %   DenominatorInitialConditions - Initial conditions on poles side
            %   OptimizeUnityScaleValues     - Optimize unity scale values
            %   ScaleValuesInputPort         - How to specify scale values
            %   FrameBasedProcessing         - Process input in frames or as samples
            %
            %   This System object supports several filter analysis methods. For more
            %   information, type dsp.BiquadFilter.helpFilterAnalysis.
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.BiquadFilter.helpFixedPoint.
            %
            %   % EXAMPLE 1: Remove high-frequency sinusoid using a biquad filter.
            %   % Initialize
            %   f1 = 1000; f2 = 3000; Fs = 8000; Fcutoff = 2000;
            %   hSR   = dsp.SineWave('Frequency',[f1,f2],'SampleRate',Fs,...
            %       'SamplesPerFrame',1024); % Input composed of 1 KHz and 3 KHz sinusoids.
            %   [z,p,k] = butter(10,Fcutoff/(Fs/2)); [s,g] = zp2sos(z,p,k);
            %   hBqdFilter = dsp.BiquadFilter('Structure', 'Direct form I', ...
            %       'SOSMatrix', s,'ScaleValues', g);
            %   hplot = dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',...
            %       false,'ShowLegend',true,'YLimits',[-150 30],...
            %       'Title','Input Signal (Channel 1) Output Signal (Channel 2)');
            %   % Stream
            %   for k = 1:100
            %       input = sum(step(hSR),2); % Add the two sinusoids together
            %       filteredOutput = step(hBqdFilter,input);
            %       step(hplot,[input,filteredOutput]);
            %   end
            % 
            %   % EXAMPLE 2: Design an elliptic IIR lowpass filter, filter white
            %   % Gaussian noise with the resulting dsp.BiquadFilter and estimate the
            %   % transfer function.
            %   % Initialize
            %   Fs = 96e3;filtSpecs = fdesign.lowpass(20e3,22.05e3,1,80,Fs);
            %   hBF = design(filtSpecs,'ellip','SystemObject',true);                                                                 
            %   htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided',...
            %           'SpectralAverages',50);
            %   hplot = dsp.ArrayPlot('PlotType','Line','YLimits',[-100 5],...
            %           'YLabel','Magnitude (dB)','XLabel','Frequency (Hz)',...
            %           'SampleIncrement',Fs/1024,'ShowLegend',true,...
            %           'Title',...
            %           'Magnitude Response; Exact (channel 1), Estimate (channel 2)');
            %   Htrue = freqz(hBF,513); % Compute exact transfer function
            %   % Stream
            %   Niter = 1000;
            %   for k = 1:Niter
            %       x = randn(1024,1);  % Input signal = white Gaussian noise
            %       y = step(hBF,x);    % Filter noise with Biquad filter
            %       H = step(htfe,x,y); % Compute transfer function estimate
            %       step(hplot,20*log10(abs([Htrue,H]))); % Plot estimate
            %   end
            %
            %   See also dsp.DigitalFilter,
            %            dsp.BiquadFilter.helpFixedPoint.
        end

        function convertToDFILT(in) %#ok<MANU>
            % Convert the System object to a dfilt object for analysis
        end

        function cumsec(in) %#ok<MANU>
            %CUMSEC  Cumulative second-order section of BiquadFilter System object
            %   H = cumsec(H) returns a cell array, H, of BiquadFilter System
            %   objects containing the cumulative sections of the BiquadFilter
            %   System object, H.
            %
            %   H = cumsec(H, INDICES) returns a cell array of BiquadFilter Systems
            %   whose indices into the original filter are in INDICES.
            %
            %   H = cumsec(H, INDICES, SECONDARY) uses the secondary scaling points
            %   to determine where the sections should be split when SECONDARY is
            %   true. SECONDARY is false by default. This option only applies for
            %   BiquadFilter objects with 'Direct form II' and 'Direct form I
            %   transposed' structures. For these structures, the secondary scaling
            %   points refer to the location between the recursive and the
            %   nonrecursive part (i.e. the "middle" of the section).
            %
            %   H = cumsec(H,'Arithmetic',ARITH,...) analyzes the filter System
            %   object, H, based on the arithmetic specified in the ARITH input.
            %   ARITH can be set to one of 'double', 'single', or 'fixed'. The
            %   analysis tool assumes a double precision filter when the arithmetic
            %   input is not specified and the filter System object is in an
            %   unlocked state.
            %
            %   cumsec(H,...) with no output arguments plots the magnitude response
            %   of the cumulative sections using FVTool.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.BiquadFilter System object
            %               fixed-point information
            %   dsp.BiquadFilter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   dsp.BiquadFilter System object.
        end

        function infoImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function reorder(in) %#ok<MANU>
            %REORDER Reorder second-order sections of BiquadFilter System object
            %   reorder(H, ORDER) reorders the sections of the BiquadFilter System
            %   object, H, using the vector of double precision indices in ORDER.
            %   ORDER does not need to contain all of the indices of the filter,
            %   the sections that correspond to missing indices will be removed
            %   from the filter.
            %
            %   reorder(H, ORDER), when ORDER is a vector of logicals, removes the
            %   sections of the filter that correspond to the index values where
            %   ORDER is equal to false.
            %
            %   HNEW = reorder(H, ORDER) generates a new BiquadFilter System
            %   object, HNEW, that contains the re-ordered sections. In this case,
            %   the original filter, H, is not changed.
            %
            %   reorder(H, NUMORDER, DENORDER) reorders the numerator and
            %   denominator of the filter separately using the vector of indices in
            %   NUMORDER and DENORDER respectively. These vectors must be of the
            %   same length.
            %
            %   reorder(H, NUMORDER, DENORDER, SVORDER) independently reorders the
            %   scale values of the BiquadFilter System object. If SVORDER is not
            %   specified the ScaleValues will be reordered in the same way as the
            %   numerator. The output scale value will always remain at the end
            %   when NUMORDER is used to reorder the scale values.
            %
            %   reorder(H, FILTER_TYPE) where FILTER_TYPE is one of:
            %   'auto','lowpass', 'highpass', 'bandpass', or 'bandstop', reorders
            %   the BiquadFilter System object, H, in a way suitable for the given
            %   filter type. This mode is intended for fixed-point implementations
            %   where the ordering of the sections can have a significant impact in
            %   the filter performance. Automatic reordering only applies when H
            %   was obtained using FDESIGN. The sections will be automatically
            %   reordered depending on the response type of the design (lowpass,
            %   highpass, etc.).
            %
            %   reorder(H, DIR_FLAG) reorders the filter sections such that the
            %   first section will contain the poles closest to the origin, and the
            %   last section will contain the poles closest to the unit circle when
            %   DIR_FLAG is 'UP'. When DIR_FLAG is 'DOWN', the sections are ordered
            %   in the opposite direction. The zeros are always paired with the
            %   poles closest to them.
            %
            %   reorder(H, DIR_FLAG, SV) reorders the scale values following the
            %   reordering of the poles when SV is set to 'poles', or following the
            %   reordering of the zeros when SV is set to 'zeros'. The scale values
            %   are not reordered when using the DIR_FLAG option unless SV is
            %   specified.
            %
            %   reorder(H,'Arithmetic',ARITH,...) assumes that the filter
            %   arithmetic is equal to ARITH. ARITH can be set to one of 'double',
            %   'single', or 'fixed'. The method assumes a double precision filter
            %   when the arithmetic input is not specified and the filter System
            %   object is in an unlocked state. The overflow action used in the
            %   reorder operation will be set to the one specified in the filter
            %   System object when ARITH is 'fixed'.
        end

        function scale(in) %#ok<MANU>
            %SCALE   Scale second-order sections of BiquadFilter System object
            %   scale(H) scales the BiquadFilter System object, H, using peak
            %   magnitude response scaling (L-infinity), in order to reduce the
            %   possibility of overflow when H operates with fixed-point inputs.
            %
            %   HNEW = scale(H) generates a new filter System object, Hnew, with
            %   scaled second-order sections. The original filter System object, H,
            %   is not changed.
            %
            %   scale(H,Pnorm) specifies the norm used to scale the filter. Pnorm
            %   can be either a discrete-time-domain norm or a frequency-domain
            %   norm. Valid time-domain norms are 'l1','l2', and 'linf'. Valid
            %   frequency-domain norms are 'L1','L2', and 'Linf'. Note that L2-norm
            %   is equal to l2-norm (Parseval's theorem) but the same is not true
            %   for other norms.
            %
            %   The different norms can be ordered in terms of how stringent they
            %   are as follows: 'l1' >= 'Linf' >= 'L2' = 'l2' >= 'L1' >= 'linf'.
            %
            %   Using the most stringent scaling, 'l1', the filter is the least
            %   prone to overflow, but also has the worst signal-to-noise ratio.
            %   Linf-scaling is the most commonly used scaling in practice.
            %
            %   scale(H,Pnorm,P1,V1,P2,V2,...) specifies optional scaling
            %   parameters via parameter-value pairs. Valid pairs are:
            %
            %   Parameter               Default     Description/Valid values
            %   ---------               -------     ------------------------
            %   'sosReorder'            'auto'      Reorder section prior to scaling.
            %                                       {'auto','none','up','down','lowpass',
            %                                       'highpass','bandpass','bandstop'}
            %   'MaxNumerator'          2           Maximum value for numerator
            %                                       coefficients
            %   'NumeratorConstraint'   'none'      {'none', 'unit', 'normalize','po2'}
            %   'OverflowMode'          'wrap'      {'wrap','saturate'}
            %   'ScaleValueConstraint'  'unit'      {'unit','none','po2'}
            %   'MaxScaleValue'         'Not used'  Maximum value for scale values
            %
            %   Automatic reordering will only take effect when H was obtained as a
            %   result from a design using FDESIGN. The sections will be
            %   automatically reordered depending on the response type of the
            %   design (lowpass, highpass, etc.).
            %
            %   Note that 'MaxScaleValue' will only be used when
            %   'ScaleValueConstraint' is set to something other than 'unit'. If
            %   'MaxScaleValue' is set to a number, the 'ScaleValueConstraint' will
            %   be changed to 'none'.
            %
            %   scale(H,Pnorm,OPTS) uses an options object to specify the optional
            %   scaling parameters in lieu of specifying parameter-value pairs. The
            %   OPTS object can be created using the SCALEOPTS method: OPTS =
            %   scaleopts(H).
            %
            %   scale(H,'Arithmetic',ARITH,...) assumes that the filter arithmetic
            %   is equal to ARITH. ARITH can be set to one of 'double', 'single',
            %   or 'fixed'. The scale method assumes a double precision filter when
            %   the arithmetic input is not specified and the filter System object
            %   is in an unlocked state. If 'Arithmetic' is 'double' or 'single',
            %   the default values shown in the table above will be used for all
            %   scaling options that are not specified as an input to the scale
            %   method. If 'Arithmetic' is 'fixed', the values used for the scaling
            %   options will be set according to the settings in the filter System
            %   object, H. However, if a scaling option is specified that differs
            %   from the settings in H, this option will be used for scaling
            %   purposes but will not change the setting in H. For example, if you
            %   do not specify the 'OverflowMode' scaling option, the scale method
            %   will assume that the 'OverflowMode' is equal to the value in the
            %   OverflowAction property of the System object, H. If you do specify
            %   an 'OverflowMode' scaling option, then the scale method will use
            %   this overflow mode value regardless of the value in the
            %   OverflowAction property of the System object.
        end

        function scalecheck(in) %#ok<MANU>
            %SCALECHECK Check scaling of BiquadFilter System object
            %   S = scalecheck(H,PNORM) for a BiquadFilter System object, H, and
            %   'Direct form I' or 'Direct form II transposed' structures, returns
            %   a row vector S that computes the p-norm of the filter from its
            %   input to the output of each second-order section. Note that this
            %   computation does not include the trailing scale value
            %   H.ScaleValues(end).
            %  
            %   Input PNORM can be either frequency-domain norms: 'L1', 'L2',
            %   'Linf' or discrete-time-domain norms: 'l1', 'l2', 'linf'. Note that
            %   the L2-norm of a filter is equal to its l2-norm (Parseval's
            %   theorem), but this is not true for other norms. PNORM defaults to
            %   'Linf' when omitted.
            %  
            %   For 'Direct form II' and 'Direct form I transposed' structures, S
            %   is a row vector containing the p-norm from the filter input to the
            %   input of the recursive part of each second-order section. This
            %   corresponds to the input to the multipliers in these structures and
            %   are the points where overflow should be avoided. If H has
            %   non-trivial scale values, i.e. if not all scale values are equal to
            %   one, S is a two-row matrix containing in the second row the p-norm
            %   from the input of the filter to the input of each scale value
            %   between the sections. Note that for these structures, the last
            %   numerator and the trailing scale value are not included when
            %   checking the scale.
            %
            %   S = scalecheck(H,'Arithmetic',ARITH,...) analyzes the filter System
            %   object, H, based on the arithmetic specified in the ARITH input.
            %   ARITH can be set to one of 'double', 'single', or 'fixed'. The
            %   analysis tool assumes a double precision filter when the arithmetic
            %   input is not specified and the filter System object is in an
            %   unlocked state.
            %
            %   For a given p-norm, an optimally scaled filter will have partial
            %   norms equal to one, so S will contain all ones.
        end

        function scaleopts(in) %#ok<MANU>
            %SCALEOPTS Create an options object for second-order section scaling
            %   OPTS = scaleopts(H) uses the current settings in the BiquadFilter
            %   System object, H, to create an options object OPTS that contains
            %   scaling options for second-order section scaling. The OPTS object
            %   can be passed in as an argument to the SCALE method.
            %
            %   OPTS = scaleopts(H,'Arithmetic',ARITH,...) assumes that the filter
            %   arithmetic is equal to ARITH. ARITH can be set to one of 'double',
            %   'single', or 'fixed'. The method assumes a double precision filter
            %   when the arithmetic input is not specified and the filter System
            %   object is in an unlocked state. The scaleopts method will choose
            %   the default values of the scaling options according to the
            %   'Arithmetic' value and the System object, H, settings.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Cache input data type for filter analysis
        end

    end
    methods (Abstract)
    end
    properties
        %CustomDenominatorAccumulatorDataType Denominator Accumulator word and
        %                                     fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the 
        %   DenominatorAccumulatorDataType property is 'Custom'. The word
        %   length of the CustomNumeratorAccumulatorDataType and 
        %   CustomDenominatorAccumulatorDataType properties must be the same. 
        %   The default value of this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomDenominatorAccumulatorDataType;

        %CustomDenominatorCoefficientsDataType Denominator Coefficients word
        %                                      and fraction lengths
        %   Specify the denominator coefficients fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   SOSMatrixSource property is 'Property' and the
        %   DenominatorCoefficientsDataType property is 'Custom'. The word
        %   length of the CustomNumeratorCoefficientsDataType, 
        %   CustomDenominatorCoefficientsDataType and CustomScaleValuesDataType
        %   properties must be the same. The default value of this property is 
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomDenominatorCoefficientsDataType;

        %CustomDenominatorProductDataType Denominator Product word and fraction
        %                                 lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the 
        %   ProductDataType property is 'Custom'. The word length of the
        %   CustomNumeratorProductDataType and CustomDenominatorProductDataType
        %   properties must be the same. The default value of this property is
        %   numerictype([],32,30).
        %
        %   See also numerictype.
        CustomDenominatorProductDataType;

        %CustomDenominatorStateDataType Denominator State word and fraction
        %                               lengths
        %   Specify the state fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   StateDataType property is 'Custom'. The word length of the
        %   CustomNumeratorStateDataType and CustomDenominatorStateDataType
        %   properties must be the same. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomDenominatorStateDataType;

        %CustomMultiplicandDataType Multiplicand word and fraction lengths
        %   Specify the multiplicand fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   MultiplicandDataType property is 'Custom'. The default value of
        %   this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomMultiplicandDataType;

        %CustomNumeratorAccumulatorDataType Numerator Accumulator word and
        %                                   fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the 
        %   NumeratorAccumulatorDataType property is 'Custom'. The word length
        %   of the CustomNumeratorAccumulatorDataType and 
        %   CustomDenominatorAccumulatorDataType properties must be the same. 
        %   The default value of this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomNumeratorAccumulatorDataType;

        %CustomNumeratorCoefficientsDataType Numerator Coefficients word and
        %                                    fraction lengths
        %   Specify the numerator coefficients fixed-point type as an
        %   auto-signed numerictype object. This property is applicable when
        %   the SOSMatrixSource property is 'Property' and the
        %   NumeratorCoefficientsDataType property is 'Custom'. The word length
        %   of the CustomNumeratorCoefficientsDataType,
        %   CustomDenominatorCoefficientsDataType and CustomScaleValuesDataType
        %   properties must be the same. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomNumeratorCoefficientsDataType;

        %CustomNumeratorProductDataType Numerator Product word and fraction
        %                               lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the 
        %   ProductDataType property is 'Custom'.The word length of the 
        %   CustomNumeratorProductDataType and CustomDenominatorProductDataType
        %   properties must be the same. The default value of this property is
        %   numerictype([],32,30).
        %
        %   See also numerictype.
        CustomNumeratorProductDataType;

        %CustomNumeratorStateDataType Numerator State word and fraction lengths
        %   Specify the state fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   StateDataType property is 'Custom'. The word length of the
        %   CustomNumeratorStateDataType and CustomDenominatorStateDataType
        %   properties must be the same. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomNumeratorStateDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomScaleValuesDataType Scale values word and fraction lengths
        %   Specify the scale values fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   SOSMatrixSource property is 'Property' and the ScaleValuesDataType
        %   property is 'Custom'. The word length of the
        %   CustomNumeratorCoefficientsDataType, 
        %   CustomDenominatorCoefficientsDataType and CustomScaleValuesDataType
        %   properties must be the same. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomScaleValuesDataType;

        %CustomSectionInputDataType Section input word and fraction lengths
        %   Specify the section input fixed-point type as an auto-signed,
        %   scaled numerictype object. This property is applicable when the
        %   SectionInputDataType property is 'Custom'. The default value of
        %   this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomSectionInputDataType;

        %CustomSectionOutputDataType Section Output word and fraction lengths
        %   Specify the section output fixed-point type as an auto-signed,
        %   scaled numerictype object. This property is applicable when the
        %   SectionOutputDataType property is 'Custom'.The default value of
        %   this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomSectionOutputDataType;

        %CustomStateDataType State word and fraction lengths
        %   Specify the state fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   StateDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomStateDataType;

        %DenominatorAccumulatorDataType Denominator Accumulator word- and
        %                               fraction-length designations
        %   Specify the accumulator fixed-point data type as one of ['Same as
        %   input' | {'Same as product'} | 'Custom']. Setting this property 
        %   will set also set the NumeratorAccumulatorDataType property to the
        %   same value.
        DenominatorAccumulatorDataType;

        %DenominatorCoefficientsDataType Denominator Coefficients word- and
        %                                fraction-length designations
        %   Specify the denominator coefficients fixed-point data type as one
        %   of [{'Same word length as input'} | 'Custom']. This property is
        %   applicable when the SOSMatrixSource property is 'Property'.
        %   Setting this property will also set the
        %   NumeratorCoefficientsDataType and ScaleValuesDataType properties to
        %   the same value.
        DenominatorCoefficientsDataType;

        %DenominatorInitialConditions Initial conditions on poles side
        %   Specify the initial conditions of the filter states on the side of
        %   the filter structure with the poles. This property is applicable
        %   when the Structure property is 'Direct form I' or 'Direct form I
        %   transposed'. The number of states or delay elements in a biquad
        %   filter is equal to twice the number of filter sections. The initial
        %   conditions can be specified as a scalar, vector or matrix.
        %   - If this property is set to a scalar value, the System object
        %   initializes all delay elements on the poles side in the filter to
        %   that value. 
        %   - If this property is set to a vector whose length is equal to the
        %   number of delay elements on the poles side in the filter, each
        %   vector element specifies a unique initial condition for a
        %   corresponding delay element on the poles side. The object applies
        %   the same vector of initial conditions to each channel of the input
        %   signal. 
        %   - If this property is set to a vector whose length is equal to the
        %   product of the number of input channels and the number of delay
        %   elements on the poles side in the filter, each element specifies a
        %   unique initial condition for a corresponding delay element on the
        %   poles side in a corresponding channel. 
        %   - If this property is set to a matrix with the same number of rows
        %   as the number of delay elements on the poles side in the filter,
        %   and one column for each channel of the input signal, each element
        %   specifies a unique initial condition for a corresponding delay
        %   element on the poles side in a corresponding channel. 
        %   The default value of this property is 0.
        DenominatorInitialConditions;

        %DenominatorProductDataType Denominator Product word- and
        %                           fraction-length designations
        %   Specify the product fixed-point data type as one of [ {'Same as
        %   input'} | 'Custom']. Setting this property will also set the
        %   NumeratorProductDataType property to the same value.
        DenominatorProductDataType;

        %DenominatorStateDataType Denominator State word- and fraction-length
        %                         designations
        %   Specify the state fixed-point data type as one of ['Same as input' 
        %   | {'Same as accumulator'} | 'Custom']. Setting this property will
        %   also set the NumeratorStateDataType property to the same value. 
        %   This property is applicable when the Structure property is 'Direct
        %   form I transposed'.
        DenominatorStateDataType;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. When
        %   this property is true, the System object treats each column as an
        %   independent channel. Set this property to false to enable
        %   sample-based processing. When this property is false, the object
        %   treats each element of the input as an individual channel. The
        %   default value of this property is true.
        FrameBasedProcessing;

        %InitialConditions Initial conditions for direct form II structures
        %   Specify the initial conditions of the filter states when the
        %   Structure property is 'Direct form II' or 'Direct form II
        %   transposed'. The number of states or delay elements in a biquad
        %   filter is equal to twice the number of filter sections. The
        %   initial conditions can be specified as a scalar, vector or matrix.
        %   - If this property is set to a scalar value, the System object
        %   initializes all delay elements in the filter to that value. 
        %   - If this property is set to a vector whose length is equal to the
        %   number of delay elements in the filter, each vector element
        %   specifies a unique initial condition for a corresponding delay
        %   element. The object applies the same vector of initial
        %   conditions to each channel of the input signal. 
        %   - If this property is set to a vector whose length is equal to the
        %   product of the number of input channels and the number of delay
        %   elements in the filter, each element specifies a unique initial
        %   condition for a corresponding delay element in a corresponding
        %   channel.  
        %   - If this property is set to a matrix with the same number of rows
        %   as the number of delay elements in the filter, and one column for
        %   each channel of the input signal, each element specifies a unique
        %   initial condition for a corresponding delay element in a
        %   corresponding channel. 
        %   The default value of this property is 0.
        InitialConditions;

        %MultiplicandDataType Multiplicand word- and fraction-length
        %                     designations
        %   Specify the multiplicand fixed-point data type as one of [{'Same as
        %   output'} | 'Custom']. This property is applicable when the
        %   Structure property is 'Direct form I transposed'.
        MultiplicandDataType;

        %NumeratorAccumulatorDataType Numerator Accumulator word- and
        %                             fraction-length designations
        %   Specify the accumulator fixed-point data type as one of ['Same as
        %   input' | {'Same as product'} | 'Custom']. Setting this property 
        %   will also set the DenominatorAccumulatorDataType property to the 
        %   same value.
        NumeratorAccumulatorDataType;

        %NumeratorCoefficientsDataType Numerator coefficients word- and
        %                              fraction-length designations
        %   Specify the numerator coefficients fixed-point data type as one of
        %   [{'Same word length as input'} | 'Custom']. This property is
        %   applicable when the SOSMatrixSource property is 'Property'.
        %   Setting this property will also set the
        %   DenominatorCoefficientsDataType and ScaleValuesDataType properties
        %   to the same value.
        NumeratorCoefficientsDataType;

        %NumeratorInitialConditions Initial conditions on zeros side
        %   Specify the initial conditions of the filter states on the side of
        %   the filter structure with the zeros. This property is applicable
        %   when the Structure property is 'Direct form I' or 'Direct form I
        %   transposed'. The number of states or delay elements in a biquad
        %   filter is equal to twice the number of filter sections. The  
        %   initial conditions can be specified as a scalar, vector or matrix.
        %   - If this property is set to a scalar value, the System object
        %   initializes all delay elements on the zeros side in the filter to 
        %   that value. 
        %   - If this property is set to a vector whose length is equal to the
        %   number of delay elements on the zeros side in the filter, each
        %   vector element specifies a unique initial condition for a
        %   corresponding delay element on the zeros side. The object applies
        %   the same vector of initial conditions to each channel of the input
        %   signal. 
        %   - If this property is set to a vector whose length is equal to the
        %   product of the number of input channels and the number of delay
        %   elements on the zeros side in the filter, each element specifies a
        %   unique initial condition for a corresponding delay element on the
        %   zeros side in a corresponding channel. 
        %   - If this property is set to a matrix with the same number of rows
        %   as the number of delay elements on the zeros side in the filter,
        %   and one column for each channel of the input signal, each element
        %   specifies a unique initial condition for a corresponding delay
        %   element on the zeros side in a corresponding channel. 
        %   The default value of this property is 0.
        NumeratorInitialConditions;

        %NumeratorProductDataType Numerator Product word- and fraction-length
        %                         designations
        %   Specify the product fixed-point data type as one of [ {'Same as 
        %   input'} | 'Custom']. Setting this property will set the
        %   DenominatorProductDataType property to the same value.
        NumeratorProductDataType;

        %NumeratorStateDataType Numerator State word- and fraction-length
        %                       designations
        %   Specify the state fixed-point data type as one of ['Same as input'
        %   | {'Same as accumulator'} | 'Custom']. Setting this property will 
        %   also set the DenominatorStateDataType property to the same value. 
        %   This property is applicable when the Structure property is 'Direct
        %   form I transposed'.
        NumeratorStateDataType;

        %OptimizeUnityScaleValues Optimize unity scale values
        %   When this logical property is set to true, the System object
        %   removes all unity scale gain computations. This reduces the object
        %   computations and increases the fixed-point accuracy. This property
        %   is applicable when the SOSMatrixSource property is 'Property'. The
        %   default value of this property is true.
        OptimizeUnityScaleValues;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of ['Same as
        %   input' | {'Same as accumulator'} | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %SOSMatrix SOS matrix 
        %   Specify the second-order section (SOS) matrix as an N-by-6 matrix,
        %   where N is the number of sections in the filter. Each row of the
        %   SOS matrix contains the numerator and denominator coefficients (bik
        %   and aik) of the corresponding section in the filter.
        %    SOSMatrix = [ b01 b11 b21  a01 a11 a21
        %                  b02 b12 b22  a02 a12 a22
        %                  ...
        %                  b0N b1N b2N  a0N a1N a2N ]
        %   The coefficients can be real or complex. This property is
        %   applicable when the SOSMatrixSource property is 'Property'. This
        %   System object assumes that the leading denominator coefficients
        %   [a01 a02 ... a0N] are equal to one, regardless of their actual
        %   values. The default value of this property is [1 0.3 0.4
        %   1 0.1 0.2].
        SOSMatrix;

        %SOSMatrixSource SOS Matrix source
        %   Specify the source of the SOS Matrix as one of [{'Property'} |
        %   'Input port'].
        SOSMatrixSource;

        %ScaleValues Scale values for each biquad section
        %   Specify the scale values to be applied before and after each
        %   section of a biquadratic filter. The scale values must be a scalar
        %   or a vector of length N+1, where N is the number of sections. If
        %   this property is set to a scalar, the value is used as the gain
        %   value before the first section of the second-order filter. The rest
        %   of the gain values are set to 1. If this property is set to a
        %   vector of N+1 values, each value is used for a separate section of
        %   the filter. This property is applicable when the SOSMatrixSource
        %   property is 'Property'. The default value of this property is 1.
        ScaleValues;

        %ScaleValuesDataType Scale Values word- and fraction-length
        %                    designations
        %   Specify the scale values fixed-point data type as one of [{'Same
        %   word length as input'} | 'Custom']. This property is applicable
        %   when the SOSMatrixSource property is 'Property'. Setting this
        %   property will also set the NumeratorCoefficientsDataType and
        %   DenominatorCoefficientsDataType properties to the same value.
        ScaleValuesDataType;

        %ScaleValuesInputPort How to specify scale values
        %   Select how scale values are specified. By default, this property is
        %   true, and the scale values are specified as an input port. If this
        %   property is false, the scale values are all assumed to be unity.
        %   This property is applicable when the SOSMatrixSource property is
        %   'Input port'.
        ScaleValuesInputPort;

        %SectionInputDataType Section input word- and fraction-length
        %                     designations
        %   Specify the section input fixed-point data type as one of [{'Same
        %   as input'} | 'Custom'].
        SectionInputDataType;

        %SectionOutputDataType Section output word- and fraction-length
        %                      designations
        %   Specify the section output fixed-point data type as one of [{'Same
        %   as section input'} | 'Custom'].
        SectionOutputDataType;

        %StateDataType State word- and fraction-length designations
        %   Specify the state fixed-point data type as one of ['Same as input'
        %   | {'Same as accumulator'} | 'Custom']. This property is applicable 
        %   when the Structure property is 'Direct form II' or 'Direct
        %   form II transposed'.
        StateDataType;

        %Structure Filter structure
        %   Specify the filter structure as one of ['Direct form I' | 'Direct
        %   form I transposed' | 'Direct form II' | {'Direct form II
        %   transposed'}].
        Structure;

    end
end
