classdef Histogram< handle
%Histogram Histogram of input or sequence of inputs
%   HHIST = dsp.Histogram returns a histogram System object, HHIST, that
%   computes the frequency distribution of the elements in each input
%   matrix.
%
%   HHIST = dsp.Histogram('PropertyName', PropertyValue, ...) returns a
%   histogram object, HHIST, with each specified property set to the
%   specified value.
%
%   HHIST = dsp.Histogram(MIN, MAX, NUMBINS, 'PropertyName', PropertyValue,
%   ...) returns a histogram object, HHIST, with the LowerLimit property
%   set to MIN, UpperLimit property set to MAX, NumBins property set to
%   NUMBINS and other specified properties set to the specified values.
%
%   Step method syntax:
%
%   Y = step(HHIST, X) returns a histogram Y for the input data X. When you
%   set the RunningHistogram property to true, the object computes the
%   histogram of the input elements over successive calls to the step
%   method.
%
%   Y = step(HHIST, X, R) computes the histogram of the input elements over
%   successive calls to the step method. The object optionally resets its
%   state based on the value of reset input signal R and the object's
%   ResetCondition property. This option is available when you set both the
%   RunningHistogram and the ResetInputPort properties to true.
%
%   Histogram methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create histogram object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the states of running histogram
%
%   Histogram properties:
%
%   LowerLimit       - Lower boundary
%   UpperLimit       - Upper boundary
%   NumBins          - Number of bins in the histogram
%   Dimension        - Dimension to operate along
%   Normalize        - Enables output vector normalization
%   RunningHistogram - Calculation over successive calls to step method
%   ResetInputPort   - Enables resetting in running histogram mode
%   ResetCondition   - Reset condition for running histogram mode
%
%   This System object supports fixed-point operations when the property
%   Normalize is set to false. For more information, type
%   dsp.Histogram.helpFixedPoint.
%
%   % EXAMPLE: Compute a Histogram with four bins, for possible input 
%   %          values 1 through 4.
%       hhist = dsp.Histogram(1,4,4);
%       y = step(hhist, [1 2 2 3 3 3 4 4 4 4]');
%       % y is equal to [1; 2; 3; 4] - one ones, two twos, etc.
%
%   See also dsp.Maximum, dsp.Minimum, dsp.Mean,
%            dsp.Histogram.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Histogram
            %Histogram Histogram of input or sequence of inputs
            %   HHIST = dsp.Histogram returns a histogram System object, HHIST, that
            %   computes the frequency distribution of the elements in each input
            %   matrix.
            %
            %   HHIST = dsp.Histogram('PropertyName', PropertyValue, ...) returns a
            %   histogram object, HHIST, with each specified property set to the
            %   specified value.
            %
            %   HHIST = dsp.Histogram(MIN, MAX, NUMBINS, 'PropertyName', PropertyValue,
            %   ...) returns a histogram object, HHIST, with the LowerLimit property
            %   set to MIN, UpperLimit property set to MAX, NumBins property set to
            %   NUMBINS and other specified properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HHIST, X) returns a histogram Y for the input data X. When you
            %   set the RunningHistogram property to true, the object computes the
            %   histogram of the input elements over successive calls to the step
            %   method.
            %
            %   Y = step(HHIST, X, R) computes the histogram of the input elements over
            %   successive calls to the step method. The object optionally resets its
            %   state based on the value of reset input signal R and the object's
            %   ResetCondition property. This option is available when you set both the
            %   RunningHistogram and the ResetInputPort properties to true.
            %
            %   Histogram methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create histogram object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states of running histogram
            %
            %   Histogram properties:
            %
            %   LowerLimit       - Lower boundary
            %   UpperLimit       - Upper boundary
            %   NumBins          - Number of bins in the histogram
            %   Dimension        - Dimension to operate along
            %   Normalize        - Enables output vector normalization
            %   RunningHistogram - Calculation over successive calls to step method
            %   ResetInputPort   - Enables resetting in running histogram mode
            %   ResetCondition   - Reset condition for running histogram mode
            %
            %   This System object supports fixed-point operations when the property
            %   Normalize is set to false. For more information, type
            %   dsp.Histogram.helpFixedPoint.
            %
            %   % EXAMPLE: Compute a Histogram with four bins, for possible input 
            %   %          values 1 through 4.
            %       hhist = dsp.Histogram(1,4,4);
            %       y = step(hhist, [1 2 2 3 3 3 4 4 4 4]');
            %       % y is equal to [1; 2; 3; 4] - one ones, two twos, etc.
            %
            %   See also dsp.Maximum, dsp.Minimum, dsp.Mean,
            %            dsp.Histogram.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.Histogram System object
            %               fixed-point information
            %   dsp.Histogram.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.Histogram
            %   System object.
        end

        function operateDim(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Dimension Dimension to operate along
        %   Specify how the histogram calculation is performed over the data as
        %   one of ['All' | {'Column'}]. The default value of this property is
        %   'Column'.
        Dimension;

        %NumBins Number of bins in the histogram
        %   Specify the number of bins in the histogram. The default value of
        %   this property is 11.
        NumBins;

        %UpperLimit Upper boundary
        %   Specify the upper boundary of the highest-valued bin as a
        %   real-valued scalar value. NaN and Inf are not valid values for this
        %   property. The default value of this property is 10. This property
        %   is tunable.
        UpperLimit;

    end
end
