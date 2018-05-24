classdef Autocorrelator< handle
%Autocorrelator Autocorrelation of inputs
%   HAC = dsp.Autocorrelator returns a System object, HAC, that computes
%   the autocorrelation of vectors or along the columns of input matrices.
%
%   HAC = dsp.Autocorrelator('PropertyName', PropertyValue, ...) returns an
%   autocorrelation object, HAC, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HAC, X) computes the autocorrelation, Y, for the columns of
%   input X.
%
%   Autocorrelator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create autocorrelation object with same property values
%   isLocked - Locked status (logical)
%
%   Autocorrelator properties:
%
%   MaximumLagSource - How to determine range of lags for autocorrelation
%   MaximumLag       - Maximum positive lag for autocorrelation computation
%   Scaling          - Scaling to apply to output
%   Method           - Domain for computing autocorrelations, time or
%                      frequency
%
%   This System object supports fixed-point operations when the Method
%   property is 'Time Domain'. For more information, type
%   dsp.Autocorrelator.helpFixedPoint.
%
%   % EXAMPLE #1: Compute autocorrelation for all positive lags
%      hac1 = dsp.Autocorrelator;
%      x = [1:100]';
%      y = step(hac1, x);
%
%   % EXAMPLE #2: Compute the autocorrelation for the lags [0:10]
%      hac2 = dsp.Autocorrelator;
%      hac2.MaximumLagSource = 'Property';
%      hac2.MaximumLag = 10;
%      x = [1:100]';
%      y = step(hac2, x);
%
%   See also dsp.Crosscorrelator,
%            dsp.Autocorrelator.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=Autocorrelator
            %Autocorrelator Autocorrelation of inputs
            %   HAC = dsp.Autocorrelator returns a System object, HAC, that computes
            %   the autocorrelation of vectors or along the columns of input matrices.
            %
            %   HAC = dsp.Autocorrelator('PropertyName', PropertyValue, ...) returns an
            %   autocorrelation object, HAC, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HAC, X) computes the autocorrelation, Y, for the columns of
            %   input X.
            %
            %   Autocorrelator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create autocorrelation object with same property values
            %   isLocked - Locked status (logical)
            %
            %   Autocorrelator properties:
            %
            %   MaximumLagSource - How to determine range of lags for autocorrelation
            %   MaximumLag       - Maximum positive lag for autocorrelation computation
            %   Scaling          - Scaling to apply to output
            %   Method           - Domain for computing autocorrelations, time or
            %                      frequency
            %
            %   This System object supports fixed-point operations when the Method
            %   property is 'Time Domain'. For more information, type
            %   dsp.Autocorrelator.helpFixedPoint.
            %
            %   % EXAMPLE #1: Compute autocorrelation for all positive lags
            %      hac1 = dsp.Autocorrelator;
            %      x = [1:100]';
            %      y = step(hac1, x);
            %
            %   % EXAMPLE #2: Compute the autocorrelation for the lags [0:10]
            %      hac2 = dsp.Autocorrelator;
            %      hac2.MaximumLagSource = 'Property';
            %      hac2.MaximumLag = 10;
            %      x = [1:100]';
            %      y = step(hac2, x);
            %
            %   See also dsp.Crosscorrelator,
            %            dsp.Autocorrelator.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.Autocorrelator System object
            %               fixed-point information
            %   dsp.Autocorrelator.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.Autocorrelator System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Full
        %   precision'} | 'Same as product' | 'Same as input' | 'Custom']. This
        %   property is applicable when the Method property is 'Time Domain'
        %   and the FullPrecisionOverride property is false.
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Time Domain', and the FullPrecisionOverride property
        %   is false, and the AccumulatorDataType property is 'Custom'. The
        %   default value of this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Time Domain', and the FullPrecisionOverride property
        %   is false, and the OutputDataType property is 'Custom'.
        %   The default value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Time Domain', and the FullPrecisionOverride property
        %   is false, and the ProductDataType property is 'Custom'.
        %   The default value of this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomProductDataType;

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

        %MaximumLag Maximum positive lag for autocorrelation computation
        %   Specify the maximum positive lag, for computing the
        %   autocorrelation, as a positive scalar integer value. This property
        %   is applicable when the MaximumLagSource property is 'Property'. The
        %   default value of this property is 1.
        MaximumLag;

        %MaximumLagSource How to determine range of lags for autocorrelation
        %   Specify how to determine range of lags for autocorrelation as one
        %   of [{'Auto'} | 'Property']. If this property is set to 'Auto', the
        %   System object computes the autocorrelation over all non-negative
        %   lags in the range [0, length(input)-1]. Otherwise, the object
        %   computes the autocorrelation using lags in the range [0,
        %   MaximumLag], where MaximumLag is specified by MaximumLag property.
        MaximumLagSource;

        %Method Domain for computing autocorrelations, time or frequency
        %   Specify the domain for computing autocorrelations as one of [{'Time
        %   Domain'} | 'Frequency Domain']. This property must be set to 'Time
        %   Domain' for fixed-point signals.
        Method;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as product' | 'Same as input' | 'Custom'].
        %   This property is applicable when the Method property is 'Time
        %   Domain' and the FullPrecisionOverride property is false.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is applicable when the Method property is 'Time Domain'
        %   and the object is not in a full precision configuration.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Full
        %   precision'} | 'Same as input' | 'Custom']. This property is
        %   applicable when the Method property is 'Time Domain' and the
        %   FullPrecisionOverride property is false.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. This
        %   property is applicable when the Method property is 'Time Domain'
        %   and the object is not in a full precision configuration.
        RoundingMethod;

        %Scaling Scaling to apply to output
        %   Specify the scaling to apply to the output as one of [{'None'} |
        %   'Biased' | 'Unbiased' | 'Unity at zero-lag']. Set this property to
        %   'None' to generate the raw autocorrelation without normalization,
        %   'Biased' to generate the biased estimate of the autocorrelation,
        %   'Unbiased' to generate the unbiased estimate of the
        %   autocorrelation, or 'Unity at zero-lag' to normalize the estimate
        %   of the autocorrelation for each channel so that the zero-lag sum is
        %   identically 1.
        Scaling;

    end
end
