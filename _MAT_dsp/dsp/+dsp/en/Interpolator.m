classdef Interpolator< handle
%Interpolator Interpolate values of real input samples
%   HINTERP = dsp.Interpolator returns an interpolation System object,
%   HINTERP, to interpolate values between real-valued input samples using
%   linear or FIR interpolation.
%
%   HINTERP = dsp.Interpolator('PropertyName', PropertyValue, ...) returns
%   an interpolation System object, HINTERP, with each specified property
%   set to the specified value.
%
%   Specify which values to interpolate by providing a vector of
%   interpolation points. An interpolation point of 1 refers to the first
%   sample in the input. To interpolate the value half-way between the
%   second and third sample in the input, specify an interpolation point of
%   2.5. Interpolation points that are not within the valid range are
%   replaced with the closest value in the valid range.
%
%   Step method syntax:
%
%   Y = step(H, X) outputs the interpolated sequence, Y, of the input
%   vector or matrix X as specified in the InterpolationPoints property.
%
%   Y = step(H, X, IPTS) outputs the interpolated sequence as specified by
%   the input argument IPTS when the InterpolationPointsSource property is
%   set to 'Input port'. IPTS is a row or column vector of interpolation
%   points.
%
%   Interpolator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create interpolation object with same property values
%   isLocked - Locked status (logical)
%
%   Interpolator properties:
%
%   InterpolationPointsSource    - Source of interpolation points
%   InterpolationPoints          - Interpolation points
%   Method                       - Interpolation method
%   FilterHalfLength             - Interpolation filter half-length
%   InterpolationPointsPerSample - Interpolation points per input sample
%   Bandwidth                    - Normalized input bandwidth
%
%   % EXAMPLE: Use Interpolator System object to interpolate a subsampled
%   % signal.
%       t = 0:.0001:.0511;
%       x = sin(2*pi*20*t);
%       x1 = x(1:50:end);
%       I = 1:0.1:length(x1);
%       hinterp = ...
%       dsp.Interpolator('InterpolationPointsSource' , 'Input port');
%       y = hinterp.step(x1',I');
%       stem(I',y, 'r');  title('Original and Interpolated Signal'); 
%       hold; stem(x1, 'Linewidth', 2);legend('Interpolated','Original');  

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=Interpolator
            %Interpolator Interpolate values of real input samples
            %   HINTERP = dsp.Interpolator returns an interpolation System object,
            %   HINTERP, to interpolate values between real-valued input samples using
            %   linear or FIR interpolation.
            %
            %   HINTERP = dsp.Interpolator('PropertyName', PropertyValue, ...) returns
            %   an interpolation System object, HINTERP, with each specified property
            %   set to the specified value.
            %
            %   Specify which values to interpolate by providing a vector of
            %   interpolation points. An interpolation point of 1 refers to the first
            %   sample in the input. To interpolate the value half-way between the
            %   second and third sample in the input, specify an interpolation point of
            %   2.5. Interpolation points that are not within the valid range are
            %   replaced with the closest value in the valid range.
            %
            %   Step method syntax:
            %
            %   Y = step(H, X) outputs the interpolated sequence, Y, of the input
            %   vector or matrix X as specified in the InterpolationPoints property.
            %
            %   Y = step(H, X, IPTS) outputs the interpolated sequence as specified by
            %   the input argument IPTS when the InterpolationPointsSource property is
            %   set to 'Input port'. IPTS is a row or column vector of interpolation
            %   points.
            %
            %   Interpolator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create interpolation object with same property values
            %   isLocked - Locked status (logical)
            %
            %   Interpolator properties:
            %
            %   InterpolationPointsSource    - Source of interpolation points
            %   InterpolationPoints          - Interpolation points
            %   Method                       - Interpolation method
            %   FilterHalfLength             - Interpolation filter half-length
            %   InterpolationPointsPerSample - Interpolation points per input sample
            %   Bandwidth                    - Normalized input bandwidth
            %
            %   % EXAMPLE: Use Interpolator System object to interpolate a subsampled
            %   % signal.
            %       t = 0:.0001:.0511;
            %       x = sin(2*pi*20*t);
            %       x1 = x(1:50:end);
            %       I = 1:0.1:length(x1);
            %       hinterp = ...
            %       dsp.Interpolator('InterpolationPointsSource' , 'Input port');
            %       y = hinterp.step(x1',I');
            %       stem(I',y, 'r');  title('Original and Interpolated Signal'); 
            %       hold; stem(x1, 'Linewidth', 2);legend('Interpolated','Original');  
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
            % if in Linear mode hide filter properties
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Bandwidth Normalized input bandwidth
        %   Specify the bandwidth to which the interpolated output samples
        %   should be constrained as numeric scalar between 0 and 1. This
        %   property can be used to take advantage of the bandlimited frequency
        %   content of the input. For example, if the input signal does not
        %   have frequency content above Fs/4 (where Fs is the sampling
        %   frequency), a value of 0.5 can be specified. A value of 1 specifies
        %   half the sample frequency. This property is applicable when the
        %   InterpolationMethod property is 'FIR'. The default value is 0.5.
        Bandwidth;

        %FilterHalfLength Interpolation filter half-length
        %   See help on the Method property for more information. This property
        %   is applicable when the Method property is 'FIR'. The default value
        %   is 3.
        %
        %   See also dsp.Interpolator.Method.
        FilterHalfLength;

        %InterpolationPoints Interpolation points
        %   Specify the interpolation points as a row or column vector. The
        %   valid range of the values in the interpolation vector is from 1 to
        %   the number of samples in each channel of the input. This property
        %   is applicable when the InterpolationPointsSource property is
        %   'Property'. The default value of this property is
        %   [1.1;4.8;2.67;1.6;3.2]. This property is tunable.
        InterpolationPoints;

        %InterpolationPointsPerSample Interpolation points per input sample
        %   See help on the Method property for more information. This property
        %   is applicable when the Method property is 'FIR'. The default value
        %   is 3.
        %
        %   See also dsp.Interpolator.Method.
        InterpolationPointsPerSample;

        %InterpolationPointsSource Source of interpolation points
        %   This property can be set to one of [{'Property'} | 'Input port'].
        InterpolationPointsSource;

        %Method Interpolation method
        %   Specify the interpolation method as one of [{'Linear'} | 'FIR'].
        %   When this property is 'Linear', the System object interpolates data
        %   values by assuming that the data varies linearly between samples
        %   taken at adjacent sample times. When this property is 'FIR', the
        %   System object computes a value at the desired interpolation point
        %   by applying an FIR filter of order 2P to the input samples on
        %   either side of the desired interpolation point, where P is the
        %   Interpolation filter half-length. A vector of 2P filter tap weights
        %   is precomputed for each Q discrete points between input samples,
        %   where you specify Q in the InterpolationPointsPerSample property.
        %   For an interpolation point corresponding to one of the Q points,
        %   the unique filter computed for that point is applied to obtain a
        %   value for the sample at the specified interpolation point. For
        %   interpolation points that fall between Q points, the value computed
        %   at the nearest Q point is used. For interpolation points less than
        %   P-1, the output is computed using linear interpolation.
        Method;

    end
end
