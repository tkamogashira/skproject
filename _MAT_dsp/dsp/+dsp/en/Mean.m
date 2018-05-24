classdef Mean< handle
%Mean Mean value of an input or sequence of inputs
%   HMEAN = dsp.Mean returns a System object, HMEAN, that computes the mean
%   of an input or a sequence of inputs.
%
%   HMEAN = dsp.Mean('PropertyName', PropertyValue, ...) returns a mean
%   System object, HMEAN, with each specified property set to the specified
%   value.
%
%   Step method syntax:
%
%   Y = step(HMEAN, X) computes mean of X. When the RunningMean property is
%   true, Y corresponds to the mean of the input elements over successive
%   calls to the step method.
%
%   Y = step(HMEAN, X, R) computes the mean value, Y, of the input elements
%   over successive calls to the step method. The object optionally resets
%   its state based on the value of reset input signal, R, and the
%   ResetCondition property. This option is available when you set both the
%   RunningMean and the ResetInputPort properties to true.
%
%   Y = step(HMEAN, X, ROI) computes the mean of input image X within the
%   given region of interest ROI when the ROIProcessing property is true
%   and the ROIForm property is 'Lines', 'Rectangles' or 'Binary mask'.
%   Note that full ROI processing support requires a Computer Vision
%   System Toolbox license. With only a DSP System Toolbox
%   license, the ROIForm property's value is limited to 'Rectangles'.
%
%   Y = step(HMEAN, X, LABEL, LABELNUMBERS) computes the mean of input
%   image, X, for region whose labels are specified in vector LABELNUMBERS.
%   The regions are defined and labeled in matrix LABEL. This option is
%   available when the ROIProcessing property is true and the ROIForm
%   property is 'Label matrix'.
%
%   % [Y, FLAG] = step(HMEAN, X, ROI) also returns FLAG which indicates
%   whether the given ROI is within the image bounds when both the
%   ROIProcessing and ValidityOutputPort properties are true and the
%   ROIForm property is 'Lines', 'Rectangles' or 'Binary mask'.
%
%   [Y, FLAG] = step(HMEAN, X, LABEL, LABELNUMBERS) also returns FLAG which
%   indicates whether the input label numbers are valid when both the
%   ROIProcessing and ValidityOutputPort properties are true and the
%   ROIForm property is 'Label matrix'.
%
%   Mean methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create mean object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the states of running mean
%
%   Mean properties:
%
%   RunningMean          - Calculation over successive calls to step method
%   ResetInputPort       - Enables resetting in running mean mode
%   ResetCondition       - Reset condition for running mean mode
%   Dimension            - Dimension to operate along
%   CustomDimension      - Numerical dimension to operate along
%   ROIProcessing        - Enables region of interest processing
%   ROIForm              - Type of region of interest
%   ROIPortion           - Calculate over entire ROI or just perimeter
%   ROIStatistics        - Statistics for each ROI, or one for all ROIs
%   ValidityOutputPort   - Return validity check of ROI or label numbers
%   FrameBasedProcessing - Process input in frames or as samples
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.Mean.helpFixedPoint.
%
%   % EXAMPLE #1: Compute mean of a signal.
%       hmean1 = dsp.Mean;
%       x = randn(100,1);
%       y = step(hmean1, x);
%
%   % EXAMPLE #2: Compute running mean of a signal.
%       hmean2 = dsp.Mean;
%       hmean2.RunningMean = true;
%       x = randn(100,1);
%       y = step(hmean2, x);    % Find running mean
%       % y(i) is the mean of all values in the vector x(1:i)
%
%   See also dsp.Maximum, dsp.Minimum, 
%            dsp.Mean.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Mean
            %Mean Mean value of an input or sequence of inputs
            %   HMEAN = dsp.Mean returns a System object, HMEAN, that computes the mean
            %   of an input or a sequence of inputs.
            %
            %   HMEAN = dsp.Mean('PropertyName', PropertyValue, ...) returns a mean
            %   System object, HMEAN, with each specified property set to the specified
            %   value.
            %
            %   Step method syntax:
            %
            %   Y = step(HMEAN, X) computes mean of X. When the RunningMean property is
            %   true, Y corresponds to the mean of the input elements over successive
            %   calls to the step method.
            %
            %   Y = step(HMEAN, X, R) computes the mean value, Y, of the input elements
            %   over successive calls to the step method. The object optionally resets
            %   its state based on the value of reset input signal, R, and the
            %   ResetCondition property. This option is available when you set both the
            %   RunningMean and the ResetInputPort properties to true.
            %
            %   Y = step(HMEAN, X, ROI) computes the mean of input image X within the
            %   given region of interest ROI when the ROIProcessing property is true
            %   and the ROIForm property is 'Lines', 'Rectangles' or 'Binary mask'.
            %   Note that full ROI processing support requires a Computer Vision
            %   System Toolbox license. With only a DSP System Toolbox
            %   license, the ROIForm property's value is limited to 'Rectangles'.
            %
            %   Y = step(HMEAN, X, LABEL, LABELNUMBERS) computes the mean of input
            %   image, X, for region whose labels are specified in vector LABELNUMBERS.
            %   The regions are defined and labeled in matrix LABEL. This option is
            %   available when the ROIProcessing property is true and the ROIForm
            %   property is 'Label matrix'.
            %
            %   % [Y, FLAG] = step(HMEAN, X, ROI) also returns FLAG which indicates
            %   whether the given ROI is within the image bounds when both the
            %   ROIProcessing and ValidityOutputPort properties are true and the
            %   ROIForm property is 'Lines', 'Rectangles' or 'Binary mask'.
            %
            %   [Y, FLAG] = step(HMEAN, X, LABEL, LABELNUMBERS) also returns FLAG which
            %   indicates whether the input label numbers are valid when both the
            %   ROIProcessing and ValidityOutputPort properties are true and the
            %   ROIForm property is 'Label matrix'.
            %
            %   Mean methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create mean object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states of running mean
            %
            %   Mean properties:
            %
            %   RunningMean          - Calculation over successive calls to step method
            %   ResetInputPort       - Enables resetting in running mean mode
            %   ResetCondition       - Reset condition for running mean mode
            %   Dimension            - Dimension to operate along
            %   CustomDimension      - Numerical dimension to operate along
            %   ROIProcessing        - Enables region of interest processing
            %   ROIForm              - Type of region of interest
            %   ROIPortion           - Calculate over entire ROI or just perimeter
            %   ROIStatistics        - Statistics for each ROI, or one for all ROIs
            %   ValidityOutputPort   - Return validity check of ROI or label numbers
            %   FrameBasedProcessing - Process input in frames or as samples
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.Mean.helpFixedPoint.
            %
            %   % EXAMPLE #1: Compute mean of a signal.
            %       hmean1 = dsp.Mean;
            %       x = randn(100,1);
            %       y = step(hmean1, x);
            %
            %   % EXAMPLE #2: Compute running mean of a signal.
            %       hmean2 = dsp.Mean;
            %       hmean2.RunningMean = true;
            %       x = randn(100,1);
            %       y = step(hmean2, x);    % Find running mean
            %       % y(i) is the mean of all values in the vector x(1:i)
            %
            %   See also dsp.Maximum, dsp.Minimum, 
            %            dsp.Mean.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.Mean System object fixed-point 
            %               information
            %   dsp.Mean.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.Mean
            %   System object.
        end

        function isFrameBasedProcessing(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Dimension Dimension to operate along
        %   Specify how the mean calculation is performed over the data as one
        %   of ['All' | 'Row' | {'Column'} | 'Custom']. This property is
        %   applicable when the RunningMean property is false.
        Dimension;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %   property to false to enable sample-based processing. The default
        %   value of this property is true. This property is applicable when the
        %   RunningMean property is true.
        FrameBasedProcessing;

    end
end
