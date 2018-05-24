classdef Crosscorrelator< handle
%Crosscorrelator Cross-correlation of two inputs
%   HCORR = dsp.Crosscorrelator returns a System object, HCORR, that
%   computes the cross-correlation of two inputs in the time domain or
%   frequency domain.
%
%   HCORR = dsp.Crosscorrelator('PropertyName', PropertyValue, ...) returns
%   a correlation object, HCORR, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HCORR, A, B) computes Y as the cross-correlation of A and B.
%
%   Crosscorrelator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create cross-correlation object with same property values
%   isLocked - Locked status (logical)
%
%   Crosscorrelator properties:
%
%   Method - Domain for computing correlations, time or frequency
%
%   This System object supports fixed-point operations when the property
%   Method is set to 'Time Domain'. For more information, type
%   dsp.Crosscorrelator.helpFixedPoint.
%
%   % EXAMPLE: Compute correlation between two signals.
%      hcorr = dsp.Crosscorrelator;
%      t=[0:0.001:1];
%      x1=sin(2*pi*2*t)+0.05*sin(2*pi*50*t);
%      x2=sin(2*pi*2*t);
%      y=step(hcorr,x1',x2');       %computes cross-correlation of x1 and x2
%      figure,plot(t,x1,'b',t, x2, 'g'); 
%      legend('Input signal 1',' Input signal 2')  
%      figure, plot(y); title('Correlated output')
%
%   See also dsp.Autocorrelator, dsp.Convolver,
%            dsp.Crosscorrelator.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Crosscorrelator
            %Crosscorrelator Cross-correlation of two inputs
            %   HCORR = dsp.Crosscorrelator returns a System object, HCORR, that
            %   computes the cross-correlation of two inputs in the time domain or
            %   frequency domain.
            %
            %   HCORR = dsp.Crosscorrelator('PropertyName', PropertyValue, ...) returns
            %   a correlation object, HCORR, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HCORR, A, B) computes Y as the cross-correlation of A and B.
            %
            %   Crosscorrelator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create cross-correlation object with same property values
            %   isLocked - Locked status (logical)
            %
            %   Crosscorrelator properties:
            %
            %   Method - Domain for computing correlations, time or frequency
            %
            %   This System object supports fixed-point operations when the property
            %   Method is set to 'Time Domain'. For more information, type
            %   dsp.Crosscorrelator.helpFixedPoint.
            %
            %   % EXAMPLE: Compute correlation between two signals.
            %      hcorr = dsp.Crosscorrelator;
            %      t=[0:0.001:1];
            %      x1=sin(2*pi*2*t)+0.05*sin(2*pi*50*t);
            %      x2=sin(2*pi*2*t);
            %      y=step(hcorr,x1',x2');       %computes cross-correlation of x1 and x2
            %      figure,plot(t,x1,'b',t, x2, 'g'); 
            %      legend('Input signal 1',' Input signal 2')  
            %      figure, plot(y); title('Correlated output')
            %
            %   See also dsp.Autocorrelator, dsp.Convolver,
            %            dsp.Crosscorrelator.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.Crosscorrelator System object
            %               fixed-point information
            %   dsp.Crosscorrelator.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.Crosscorrelator System object.
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
        %   precision'} | 'Same as product' | 'Same as first input' |
        %   'Custom']. This property is applicable when the Method property is
        %   'Time Domain' and the FullPrecisionOverride property is false.
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Time Domain', the FullPrecisionOverride property is
        %   false, and the AccumulatorDataType property is 'Custom'. The
        %   default value of this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Time Domain', the FullPrecisionOverride property  is
        %   false, and the OutputDataType property is 'Custom'.
        %   The default value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths              
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Time Domain', the FullPrecisionOverride property is
        %   false, and the ProductDataType property is 'Custom'.
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

        %Method Domain for computing correlations, time or frequency
        %   Specify the domain in which the System object computes correlation
        %   as one of [{'Time Domain'} | 'Frequency Domain' | 'Fastest'].
        %   Computing correlations in the time domain minimizes memory use.
        %   Computing correlations in the frequency domain might require fewer
        %   computations than computing in the time domain, depending on the
        %   input length. If this property is set to 'Fastest', the object
        %   computes in the domain which minimizes the number of computations.
        Method;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as product' | 'Same as first input' |
        %   'Custom']. This property is applicable when the Method property is
        %   'Time Domain' and the FullPrecisionOverride property is false.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is applicable when the Method property is 'Time Domain'
        %   and the object is not in a full precision configuration.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Full
        %   precision'} | 'Same as first input' | 'Custom']. This property is
        %   applicable when the Method property is 'Time Domain' and the
        %   FullPrecisionOverride property is false.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. This
        %   property is applicable when the Method property is 'Time Domain'
        %   and the object is not in a full precision configuration.
        RoundingMethod;

    end
end
