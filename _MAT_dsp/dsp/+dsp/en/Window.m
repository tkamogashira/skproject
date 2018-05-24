classdef Window< handle
%Window Apply window to input signal
%   HWIN = dsp.Window returns a System object, HWIN, that applies a window
%   function to an input signal.
%
%   HWIN = dsp.Window('PropertyName', PropertyValue, ...) returns a window
%   System object, HWIN, with each specified property set to the specified
%   value.
%
%   HWIN = dsp.Window(WINDOW, 'PropertyName', PropertyValue, ...) returns a
%   window System object, HWIN, with the WindowFunction property set to
%   WINDOW and other specified properties set to the specified values.
%
%   Step method syntax:
%
%   Y = step(HWIN, X) generates the windowed output, Y, of input X using
%   the specified window.
%
%   [Y, W] = step(HWIN, X) also returns the window values W when the
%   WeightsOutputPort property is true.
%
%   Window methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create window object with same property values
%   isLocked - Locked status (logical)
%
%   Window properties:
%
%   WindowFunction       - Type of window
%   WeightsOutputPort    - Enable the output of window weights
%   StopbandAttenuation  - Level of stopband attenuation in decibels
%   Beta                 - Kaiser window parameter
%   NumConstantSidelobes - Number of constant sidelobes
%   MaximumSidelobeLevel - Maximum sidelobe level relative to mainlobe in
%                          decibels
%   Sampling             - Window sampling for generalized-cosine windows
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.Window.helpFixedPoint.
%
%   % EXAMPLE: Apply a Hamming window to an input signal.
%       hwin = dsp.Window( ...
%               'WindowFunction', 'Hamming', ...
%               'WeightsOutputPort',true);
%       x = rand(64,1);
%       [y, w] = step(hwin, x);
%       wvtool(w);  % View the window's time and frequency domain responses
%
%   See also dsp.FFT, wvtool, dsp.Window.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Window
            %Window Apply window to input signal
            %   HWIN = dsp.Window returns a System object, HWIN, that applies a window
            %   function to an input signal.
            %
            %   HWIN = dsp.Window('PropertyName', PropertyValue, ...) returns a window
            %   System object, HWIN, with each specified property set to the specified
            %   value.
            %
            %   HWIN = dsp.Window(WINDOW, 'PropertyName', PropertyValue, ...) returns a
            %   window System object, HWIN, with the WindowFunction property set to
            %   WINDOW and other specified properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HWIN, X) generates the windowed output, Y, of input X using
            %   the specified window.
            %
            %   [Y, W] = step(HWIN, X) also returns the window values W when the
            %   WeightsOutputPort property is true.
            %
            %   Window methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create window object with same property values
            %   isLocked - Locked status (logical)
            %
            %   Window properties:
            %
            %   WindowFunction       - Type of window
            %   WeightsOutputPort    - Enable the output of window weights
            %   StopbandAttenuation  - Level of stopband attenuation in decibels
            %   Beta                 - Kaiser window parameter
            %   NumConstantSidelobes - Number of constant sidelobes
            %   MaximumSidelobeLevel - Maximum sidelobe level relative to mainlobe in
            %                          decibels
            %   Sampling             - Window sampling for generalized-cosine windows
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.Window.helpFixedPoint.
            %
            %   % EXAMPLE: Apply a Hamming window to an input signal.
            %       hwin = dsp.Window( ...
            %               'WindowFunction', 'Hamming', ...
            %               'WeightsOutputPort',true);
            %       x = rand(64,1);
            %       [y, w] = step(hwin, x);
            %       wvtool(w);  % View the window's time and frequency domain responses
            %
            %   See also dsp.FFT, wvtool, dsp.Window.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.Window System object fixed-point
            %               information
            %   dsp.Window.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.Window
            %   System object
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
            % WindowFunction properties
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Beta Kaiser window parameter
        %   Specify the Kaiser window parameter. Increasing this parameter
        %   widens the mainlobe and decreases the amplitude of the window
        %   sidelobes in the window's frequency magnitude response. This
        %   property is applicable when WindowFunction property is 'Kaiser'.
        %   The default value of this property is 10. This property is tunable.
        Beta;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomProductDataType;

        %CustomWindowDataType Window word and fraction lengths        
        %   Specify the window fixed-point type as an auto-signed numerictype
        %   object. This property is applicable when the WindowDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomWindowDataType;

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

        %MaximumSidelobeLevel Maximum sidelobe level relative to mainlobe
        %   Specify, in decibels, the maximum sidelobe level relative to the
        %   mainlobe as a scalar less than or equal to zero. The default value
        %   of this property is -30, that produces sidelobes with peaks 30 dB
        %   down from the mainlobe peak. This property is applicable when
        %   WindowFunction property is 'Taylor'. This property is tunable.
        MaximumSidelobeLevel;

        %NumConstantSidelobes Number of constant sidelobes
        %   Specify the number of constant sidelobes as a scalar integer value
        %   greater than zero. This property is applicable when WindowFunction
        %   property is 'Taylor'. The default value of this property is 4. This
        %   property is tunable.
        NumConstantSidelobes;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   product'} | 'Same as input' | 'Custom']. This property is
        %   applicable when the FullPrecisionOverride property is false.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is applicable when the object is not in a full precision
        %   configuration.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Full
        %   precision'} | 'Same as input' | 'Custom']. This property is
        %   applicable when the FullPrecisionOverride property is false.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. This
        %   property is applicable when the object is not in a full precision
        %   configuration.
        RoundingMethod;

        %Sampling Window sampling for generalized-cosine windows
        %   Specify the window sampling for generalized-cosine windows as
        %   [{'Symmetric'} | 'Periodic']. This property is applicable when
        %   WindowFunction property is 'Blackman', 'Hamming', 'Hann', or
        %   'Hanning'. This property is tunable.
        Sampling;

        %StopbandAttenuation Level of stopband attenuation in decibels
        %   Specify the level of stopband attenuation in decibels. This
        %   property is applicable when the WindowFunction property is
        %   'Chebyshev'. The default value of this property is 50. This
        %   property is tunable.
        StopbandAttenuation;

        %WeightsOutputPort Enable the output of window weights
        %   Set this property to true to output the window weights. The weights
        %   is an M-by-1 vector with M equal to the first dimension of the
        %   input. The default value of this property is false.
        WeightsOutputPort;

        %WindowDataType Window word- and fraction-length designations
        %   Specify the window fixed-point data type as one of [{'Same word
        %   length as input'} | 'Custom'].
        WindowDataType;

        %WindowFunction Type of window
        %   Specify the type of window to apply as one of ['Bartlett' |
        %   'Blackman' | 'Boxcar' | 'Chebyshev' | {'Hamming'} | 'Hann' |
        %   'Hanning' | 'Kaiser' | 'Taylor' | 'Triang']. This property is
        %   tunable.
        WindowFunction;

    end
end
