classdef Variance< handle
%Variance Variance of input or sequence of inputs
%   HVAR = dsp.Variance returns a System object, HVAR, that computes the
%   variance of an input or a sequence of inputs.
%
%   HVAR = dsp.Variance('PropertyName', PropertyValue, ...) returns a
%   variance System object, HVAR, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HVAR, X) computes the variance of input X. It computes the
%   variance, Y, of the input elements over successive calls to the step
%   method when the RunningVariance property is true.
%
%   Y = step(HVAR, X, R) computes the variance, Y, of the input elements
%   over successive calls to the step method. The object optionally resets
%   its state based on the value of reset input signal, R, and the
%   ResetCondition property. This option is available when you set both the
%   RunningVariance and the ResetInputPort properties to true.
%
%   VAR2D = step(HVAR, X, ROI) computes the variance of input image, X,
%   within the given region of interest, ROI, when the ROIProcessing
%   property is true and the ROIForm property is 'Lines', 'Rectangles' or
%   'Binary mask'. Note that full ROI processing support requires a
%   Computer Vision System Toolbox license. With only the DSP System 
%   Toolbox license, the ROIForm property's value is limited to
%   'Rectangles'.
%
%   VAR2D = step(HVAR, X, LABEL, LABELNUMBERS) computes the variance of
%   input image, X, for region labels contained in vector LABELNUMBERS,
%   with matrix LABEL marking pixels of different regions. This option is
%   available when the ROIProcessing property is true and the ROIForm
%   property is 'Label matrix'.
%
%   [VAR2D, FLAG] = step(HVAR, X, ROI) also returns FLAG which indicates
%   whether the given region of interest is within the image bounds when
%   both the ROIProcessing and ValidityOutputPort properties are true and
%   the ROIForm property is 'Lines', 'Rectangles' or 'Binary mask'.
%
%   [VAR2D, FLAG] = step(HVAR, X, LABEL, LABELNUMBERS) also returns FLAG
%   which indicates whether the input label numbers are valid when both the
%   ROIProcessing and ValidityOutputPort properties are true and the
%   ROIForm property is 'Label matrix'.
%
%   Variance methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create variance object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the states of running variance
%
%   Variance properties:
%
%   RunningVariance      - Calculation over successive calls to step method
%   ResetInputPort       - Enables resetting in running variance mode
%   ResetCondition       - Reset condition for running variance mode
%   Dimension            - Dimension to operate along
%   CustomDimension      - Numerical dimension to operate along
%   ROIProcessing        - Enables region-of-interest processing
%   ROIForm              - Type of region of interest
%   ROIPortion           - Calculate over entire ROI or just perimeter
%   ROIStatistics        - Statistics for each ROI, or one for all ROIs
%   ValidityOutputPort   - Enables output of validity check of ROI or label
%                          numbers
%   FrameBasedProcessing - Process input in frames or as samples
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.Variance.helpFixedPoint.
%
%   % EXAMPLE: Compute running variance of a signal. 
%       hvar = dsp.Variance;
%       hvar.RunningVariance = true;
%       x = randn(100,1);
%       y = step(hvar, x);        
%       % y(i) is the running variance of all values in the vector x(1:i)
%
%   See also dsp.Mean, dsp.RMS, dsp.StandardDeviation,
%            dsp.Variance.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Variance
            %Variance Variance of input or sequence of inputs
            %   HVAR = dsp.Variance returns a System object, HVAR, that computes the
            %   variance of an input or a sequence of inputs.
            %
            %   HVAR = dsp.Variance('PropertyName', PropertyValue, ...) returns a
            %   variance System object, HVAR, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HVAR, X) computes the variance of input X. It computes the
            %   variance, Y, of the input elements over successive calls to the step
            %   method when the RunningVariance property is true.
            %
            %   Y = step(HVAR, X, R) computes the variance, Y, of the input elements
            %   over successive calls to the step method. The object optionally resets
            %   its state based on the value of reset input signal, R, and the
            %   ResetCondition property. This option is available when you set both the
            %   RunningVariance and the ResetInputPort properties to true.
            %
            %   VAR2D = step(HVAR, X, ROI) computes the variance of input image, X,
            %   within the given region of interest, ROI, when the ROIProcessing
            %   property is true and the ROIForm property is 'Lines', 'Rectangles' or
            %   'Binary mask'. Note that full ROI processing support requires a
            %   Computer Vision System Toolbox license. With only the DSP System 
            %   Toolbox license, the ROIForm property's value is limited to
            %   'Rectangles'.
            %
            %   VAR2D = step(HVAR, X, LABEL, LABELNUMBERS) computes the variance of
            %   input image, X, for region labels contained in vector LABELNUMBERS,
            %   with matrix LABEL marking pixels of different regions. This option is
            %   available when the ROIProcessing property is true and the ROIForm
            %   property is 'Label matrix'.
            %
            %   [VAR2D, FLAG] = step(HVAR, X, ROI) also returns FLAG which indicates
            %   whether the given region of interest is within the image bounds when
            %   both the ROIProcessing and ValidityOutputPort properties are true and
            %   the ROIForm property is 'Lines', 'Rectangles' or 'Binary mask'.
            %
            %   [VAR2D, FLAG] = step(HVAR, X, LABEL, LABELNUMBERS) also returns FLAG
            %   which indicates whether the input label numbers are valid when both the
            %   ROIProcessing and ValidityOutputPort properties are true and the
            %   ROIForm property is 'Label matrix'.
            %
            %   Variance methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create variance object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states of running variance
            %
            %   Variance properties:
            %
            %   RunningVariance      - Calculation over successive calls to step method
            %   ResetInputPort       - Enables resetting in running variance mode
            %   ResetCondition       - Reset condition for running variance mode
            %   Dimension            - Dimension to operate along
            %   CustomDimension      - Numerical dimension to operate along
            %   ROIProcessing        - Enables region-of-interest processing
            %   ROIForm              - Type of region of interest
            %   ROIPortion           - Calculate over entire ROI or just perimeter
            %   ROIStatistics        - Statistics for each ROI, or one for all ROIs
            %   ValidityOutputPort   - Enables output of validity check of ROI or label
            %                          numbers
            %   FrameBasedProcessing - Process input in frames or as samples
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.Variance.helpFixedPoint.
            %
            %   % EXAMPLE: Compute running variance of a signal. 
            %       hvar = dsp.Variance;
            %       hvar.RunningVariance = true;
            %       x = randn(100,1);
            %       y = step(hvar, x);        
            %       % y(i) is the running variance of all values in the vector x(1:i)
            %
            %   See also dsp.Mean, dsp.RMS, dsp.StandardDeviation,
            %            dsp.Variance.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.Variance System object fixed-point
            %               information
            %   dsp.Variance.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.Variance
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
        %   Specify how the variance calculation is performed over the data as
        %   one of ['All' | 'Row' | {'Column'} | 'Custom']. This property is
        %   applicable when the RunningVariance property is false.
        Dimension;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set
        %   this property to false to enable sample-based processing. This
        %   property is applicable when the RunningVariance property is true.
        %   The default value of this property is true. 
        FrameBasedProcessing;

    end
end
