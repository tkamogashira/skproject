classdef FIRFilter< handle
%FIR Filter Static or time-varying FIR filters
%   HFIR = dsp.FIRFilter returns an FIR filter System object, HFIR, which
%   independently filters each channel of the input over time using a
%   specified FIR filter implementation.
%
%   HFIR = dsp.FIRFilter('PropertyName', PropertyValue, ...) returns an FIR
%   filter System object, HFIR, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HFIR, X) filters the real or complex input signal X using the
%   specified filter to produce the output Y. The System object filters
%   each channel of the input signal independently over time.
%
%   Y = step(HFIR, X, COEFF) uses the time-varying coefficients COEFF, to
%   filter the input signal X and produce the output Y. This option is
%   possible when the CoefficientsSource property is 'Input port'.
%
%   FIRFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create FIR filter object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   FIRFilter properties:
%
%   NumeratorSource              - Source of filter coefficients
%   Numerator                    - Filter coefficients
%   ReflectionCoefficientsSource - Source of Lattice filter coefficients
%   ReflectionCoefficients       - Lattice filter coefficients
%   InitialConditions            - Initial conditions
%   Structure                    - Filter structure
%   FrameBasedProcessing         - Process input in frames or as samples
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.FIRFilter.helpFilterAnalysis.
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.FIRFilter.helpFixedPoint.
%
%   % EXAMPLE 1: Remove high-frequency sinusoid using an FIR filter.
%   % Initialize
%   f1 = 1000; f2 = 3000; Fs = 8000; Fcutoff = 2000;
%   hSR   = dsp.SineWave('Frequency',[f1,f2],'SampleRate',Fs,...
%       'SamplesPerFrame',1024);  
%   hFIR  = dsp.FIRFilter('Numerator', fir1(130,Fcutoff/(Fs/2)));
%   hplot = dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',...
%       false,'ShowLegend',true,'YLimits',[-120 30],...
%       'Title','Input Signal (Channel 1) Output Signal (Channel 2)');
%   % Stream
%   for k = 1:100
%       input = sum(step(hSR),2); % Add the two sinusoids together
%       filteredOutput = step(hFIR,input);
%       step(hplot,[input,filteredOutput]);
%   end
%
%   % EXAMPLE 2: Design an equiripple lowpass FIR filter. Filter white
%   % Gaussian noise with the resulting dsp.FIRFilter and estimate the
%   % transfer function.
%   % Initialize
%   Fs = 96e3;filtSpecs = fdesign.lowpass(20e3,22.05e3,1,80,Fs);
%   hFIR = design(filtSpecs,'equiripple','SystemObject',true);                                                            
%   htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided',...
%           'SpectralAverages',50);
%   hplot = dsp.ArrayPlot('PlotType','Line','YLimits',[-100 5],...
%           'YLabel','Magnitude (dB)','XLabel','Frequency (Hz)',...
%           'SampleIncrement',Fs/1024,'ShowLegend',true,...
%           'Title',...
%           'Magnitude Response; Exact (Channel 1), Estimate (Channel 2)');
%   Htrue = freqz(hFIR,513); % Compute exact transfer function
%   % Stream
%   Niter = 1000;
%   for k = 1:Niter
%       x = randn(1024,1);  % Input signal = white Gaussian noise
%       y = step(hFIR,x);   % Filter noise with FIR filter
%       H = step(htfe,x,y); % Compute transfer function estimate
%       step(hplot,20*log10(abs([Htrue,H]))); % Plot estimate
%   end
%
%   See also dsp.BiquadFilter, dsp.FIRFilter.helpFixedPoint.

 
%   Copyright 2011-2013 The MathWorks, Inc.

    methods
        function out=FIRFilter
            %FIR Filter Static or time-varying FIR filters
            %   HFIR = dsp.FIRFilter returns an FIR filter System object, HFIR, which
            %   independently filters each channel of the input over time using a
            %   specified FIR filter implementation.
            %
            %   HFIR = dsp.FIRFilter('PropertyName', PropertyValue, ...) returns an FIR
            %   filter System object, HFIR, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HFIR, X) filters the real or complex input signal X using the
            %   specified filter to produce the output Y. The System object filters
            %   each channel of the input signal independently over time.
            %
            %   Y = step(HFIR, X, COEFF) uses the time-varying coefficients COEFF, to
            %   filter the input signal X and produce the output Y. This option is
            %   possible when the CoefficientsSource property is 'Input port'.
            %
            %   FIRFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create FIR filter object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the internal states to initial conditions
            %
            %   FIRFilter properties:
            %
            %   NumeratorSource              - Source of filter coefficients
            %   Numerator                    - Filter coefficients
            %   ReflectionCoefficientsSource - Source of Lattice filter coefficients
            %   ReflectionCoefficients       - Lattice filter coefficients
            %   InitialConditions            - Initial conditions
            %   Structure                    - Filter structure
            %   FrameBasedProcessing         - Process input in frames or as samples
            %
            %   This System object supports several filter analysis methods. For more
            %   information, type dsp.FIRFilter.helpFilterAnalysis.
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.FIRFilter.helpFixedPoint.
            %
            %   % EXAMPLE 1: Remove high-frequency sinusoid using an FIR filter.
            %   % Initialize
            %   f1 = 1000; f2 = 3000; Fs = 8000; Fcutoff = 2000;
            %   hSR   = dsp.SineWave('Frequency',[f1,f2],'SampleRate',Fs,...
            %       'SamplesPerFrame',1024);  
            %   hFIR  = dsp.FIRFilter('Numerator', fir1(130,Fcutoff/(Fs/2)));
            %   hplot = dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',...
            %       false,'ShowLegend',true,'YLimits',[-120 30],...
            %       'Title','Input Signal (Channel 1) Output Signal (Channel 2)');
            %   % Stream
            %   for k = 1:100
            %       input = sum(step(hSR),2); % Add the two sinusoids together
            %       filteredOutput = step(hFIR,input);
            %       step(hplot,[input,filteredOutput]);
            %   end
            %
            %   % EXAMPLE 2: Design an equiripple lowpass FIR filter. Filter white
            %   % Gaussian noise with the resulting dsp.FIRFilter and estimate the
            %   % transfer function.
            %   % Initialize
            %   Fs = 96e3;filtSpecs = fdesign.lowpass(20e3,22.05e3,1,80,Fs);
            %   hFIR = design(filtSpecs,'equiripple','SystemObject',true);                                                            
            %   htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided',...
            %           'SpectralAverages',50);
            %   hplot = dsp.ArrayPlot('PlotType','Line','YLimits',[-100 5],...
            %           'YLabel','Magnitude (dB)','XLabel','Frequency (Hz)',...
            %           'SampleIncrement',Fs/1024,'ShowLegend',true,...
            %           'Title',...
            %           'Magnitude Response; Exact (Channel 1), Estimate (Channel 2)');
            %   Htrue = freqz(hFIR,513); % Compute exact transfer function
            %   % Stream
            %   Niter = 1000;
            %   for k = 1:Niter
            %       x = randn(1024,1);  % Input signal = white Gaussian noise
            %       y = step(hFIR,x);   % Filter noise with FIR filter
            %       H = step(htfe,x,y); % Compute transfer function estimate
            %       step(hplot,20*log10(abs([Htrue,H]))); % Plot estimate
            %   end
            %
            %   See also dsp.BiquadFilter, dsp.FIRFilter.helpFixedPoint.
        end

        function convertToDFILT(in) %#ok<MANU>
            % Convert the System object to a dfilt object for analysis      
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.FIRFilter System object fixed-point
            %               information
            %   dsp.FIRFilter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.FIRFilter System
            %   object.
        end

        function infoImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Full
        %   precision'} | 'Same as product' | 'Same as input' | 'Custom']. This
        %   property is applicable when the  FullPrecisionOverride property is
        %   false.
        AccumulatorDataType;

        %CoefficientsDataType Numerator word- and fraction-length designations
        %   Specify the numerator fixed-point data type as one of [{'Same
        %   word length as input'} | 'Custom'].
        CoefficientsDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as a signed or unsigned,
        %   scaled numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype(true,32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomCoefficientsDataType Numerator word and fraction lengths
        %   Specify the numerator fixed-point type as a signed or unsigned
        %   numerictype object. This property is applicable when the
        %   CoefficientsDataType property is 'Custom'. The default value of
        %   this property is numerictype(true,16,15).
        %
        %   See also numerictype.
        CustomCoefficientsDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as a signed or unsigned, scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the OutputDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype(true,16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as a signed or unsigned,
        %   scaled numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype(true,32,30).
        %
        %   See also numerictype.
        CustomProductDataType;

        %CustomReflectionCoefficientsDataType Reflection coefficients word and
        %fraction lengths
        %   Specify the numerator fixed-point type as a signed or unsigned
        %   numerictype object. This property is applicable when the
        %   ReflectionCoefficientsDataType property is 'Custom'. The default
        %   value of this property is numerictype(true,16,15).
        %
        %   See also numerictype.
        CustomReflectionCoefficientsDataType;

        %CustomStateDataType State word and fraction lengths
        %   Specify the state fixed-point type as a signed or unsigned, scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the OutputDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype(true,16,15).
        %
        %   See also numerictype.
        CustomStateDataType;

        %FrameBasedProcessing Process input in frames or as samples
        %  Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %  property to false to enable sample-based processing. The default
        %  value of this property is true.
        FrameBasedProcessing;

        %FullPrecisionOverride Full precision override for fixed-point arithmetic
        %   Specify whether to use full precision rules. If you set
        %   FullPrecisionOverride to true the object computes all
        %   internal arithmetic and output data types using full
        %   precision rules. These rules guarantee that no quantization
        %   occurs within the object. Bits are added as needed to ensure
        %   that no round-off or overflow occurs. If you set
        %   FullPrecisionOverride to false, fixed-point data types
        %   are controlled through individual property settings.
        FullPrecisionOverride;

        %InitialConditions Initial conditions of the filter states
        %   Specify the initial conditions of the filter states. The default
        %   value of this property is 0. To learn how to specify initial
        %   conditions, see the help of the InitialConditions property.
        InitialConditions;

        %Numerator Filter coefficients
        %   Specify the filter coefficients as a real or complex numeric row
        %   vector. This property is applicable when the CoefficientsSource
        %   property is 'Property' and the Structure property is set to one of
        %   'Direct form', 'Direct form symmetric', 'Direct form
        %   antisymmetric', or 'Direct form transposed'. This property is
        %   tunable. The default value of this property is [0.5 0.5].
        Numerator;

        %NumeratorSource Source of filter coefficients
        %   Specify the source of the filter coefficients as one of
        %   [{'Property'} | 'Input port']. When the filter coefficients are
        %   specified via input port, the System object updates the
        %   time-varying filter once every frame if the FrameBasedProcessing
        %   property is true or once every sample otherwise.
        NumeratorSource;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as input' | 'Custom']. This property is
        %   applicable when the FullPrecisionOverride property is false.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Full
        %   precision'} | 'Same as input' | 'Custom']. This property is
        %   applicable when the FullPrecisionOverride property is false.
        ProductDataType;

        %ReflectionCoefficients Lattice filter coefficients
        %   Specify the lattice filter coefficients as a real or complex
        %   numeric row vector. This property is applicable when the
        %   ReflectionCoefficientsSource property is 'Property' and the
        %   Structure property is set to 'Lattice MA'. This property is
        %   tunable. The default value of this property is [0.5 0.5].
        ReflectionCoefficients;

        %ReflectionCoefficientsDataType Reflection coefficients word- and
        %fraction-length designations
        %   Specify the reflection coefficients fixed-point data type as one of
        %   [{'Same word length as input'} | 'Custom'].
        ReflectionCoefficientsDataType;

        %ReflectionCoefficientsSource Source of Lattice filter coefficients
        %   Specify the source of the Lattice filter coefficients as one of
        %   [{'Property'} | 'Input port']. When the filter coefficients are
        %   specified via input port, the System object updates the
        %   time-varying filter once every frame if the FrameBasedProcessing
        %   property is true or once every sample otherwise.
        ReflectionCoefficientsSource;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %StateDataType State word- and fraction-length designations
        %   Specify the state fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as input' | 'Custom']. This property is
        %   applicable when the FullPrecisionOverride property is false.
        StateDataType;

        %Structure Filter structure
        %   Specify the filter structure as one of [{'Direct form'} |'Direct
        %   form symmetric' | 'Direct form antisymmetric' | 'Direct form
        %   transposed' | 'Lattice MA']
        Structure;

    end
end
