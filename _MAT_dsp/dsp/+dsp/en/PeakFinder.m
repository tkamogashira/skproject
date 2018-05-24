classdef PeakFinder< handle
%PeakFinder Determine extrema (maxima or minima) in input signal
%   HPEAKS = dsp.PeakFinder returns a peak finder System object, HPEAKS,
%   that compares the current signal value to the previous and next values
%   to determine if the current value is an extremum.
%
%   HPEAKS = dsp.PeakFinder('PropertyName', PropertyValue, ...) returns a
%   peak finder System object, HPEAKS, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   YCNT = step(HPEAKS, X) returns the number of extrema (minima, maxima or
%   both) YCNT in input signal X.
%
%   [YCNT, IDX] = step(HPEAKS, X) returns the number of extrema YCNT and
%   peak indices IDX in input signal X when the PeakType property is either
%   'Maxima' or 'Minima' and the PeakIndicesOutputPort property is true.
%
%   [..., VAL] = step(HPEAKS, X) also returns the peak values VAL in input
%   signal X when the PeakType property is either 'Maxima' or 'Minima' and
%   the PeakValuesOutputPort property is true.
%
%   [..., POL] = step(HPEAKS, X) also returns the extrema polarity POL in
%   input signal X when the PeakType property is 'Maxima and Minima' and
%   the PeakIndicesOutputPort property is true. The polarity is 1 for
%   maxima and 0 for minima.
%
%   PeakFinder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create peak finder object with same property values
%   isLocked - Locked status (logical)
%
%   PeakFinder properties:
%
%   PeakType              - Looking for maxima, minima, or both
%   PeakIndicesOutputPort - Enables output of the extrema indices
%   PeakValuesOutputPort  - Enables output of the extrema values
%   MaximumPeakCount      - Number of extrema to look for in each input
%                           signal
%   IgnoreSmallPeaks      - Enables ignoring peaks below a threshold
%   PeakThreshold         - Threshold below which peaks are ignored
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.PeakFinder.helpFixedPoint.
%
%   % EXAMPLE #1: Determine whether each value of an input signal is local 
%   % maximum or minimum. 
%       hpeaks1 = dsp.PeakFinder;
%       hpeaks1.PeakIndicesOutputPort = true;
%       hpeaks1.PeakValuesOutputPort = true;
%   
%       x1 = [9 6 10 3 4 5 0 12]';
%       % Find the peaks of each input [prev;cur;next]: {[9;6;10],[6;10;3],...} 
%       [cnt1, idx1, val1, pol1] = step(hpeaks1, x1);
%
%   % EXAMPLE #2: Determine peak values for a fixed-point input signal.
%       hpeaks2 = dsp.PeakFinder('PeakType', 'Maxima', ...
%               'PeakValuesOutputPort', true, ...
%               'MaximumPeakCount', 2, ...
%               'IgnoreSmallPeaks', true, ...
%               'PeakThreshold', 0.25, ...    
%               'OverflowAction', 'Saturate');
%       x2 = fi([-1;0.5;0],true,16,15);
%       [cnt2, val2] = step(hpeaks2, x2);
%
%   See also dsp.Maximum, dsp.Minimum, 
%            dsp.PeakFinder.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=PeakFinder
            %PeakFinder Determine extrema (maxima or minima) in input signal
            %   HPEAKS = dsp.PeakFinder returns a peak finder System object, HPEAKS,
            %   that compares the current signal value to the previous and next values
            %   to determine if the current value is an extremum.
            %
            %   HPEAKS = dsp.PeakFinder('PropertyName', PropertyValue, ...) returns a
            %   peak finder System object, HPEAKS, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   YCNT = step(HPEAKS, X) returns the number of extrema (minima, maxima or
            %   both) YCNT in input signal X.
            %
            %   [YCNT, IDX] = step(HPEAKS, X) returns the number of extrema YCNT and
            %   peak indices IDX in input signal X when the PeakType property is either
            %   'Maxima' or 'Minima' and the PeakIndicesOutputPort property is true.
            %
            %   [..., VAL] = step(HPEAKS, X) also returns the peak values VAL in input
            %   signal X when the PeakType property is either 'Maxima' or 'Minima' and
            %   the PeakValuesOutputPort property is true.
            %
            %   [..., POL] = step(HPEAKS, X) also returns the extrema polarity POL in
            %   input signal X when the PeakType property is 'Maxima and Minima' and
            %   the PeakIndicesOutputPort property is true. The polarity is 1 for
            %   maxima and 0 for minima.
            %
            %   PeakFinder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create peak finder object with same property values
            %   isLocked - Locked status (logical)
            %
            %   PeakFinder properties:
            %
            %   PeakType              - Looking for maxima, minima, or both
            %   PeakIndicesOutputPort - Enables output of the extrema indices
            %   PeakValuesOutputPort  - Enables output of the extrema values
            %   MaximumPeakCount      - Number of extrema to look for in each input
            %                           signal
            %   IgnoreSmallPeaks      - Enables ignoring peaks below a threshold
            %   PeakThreshold         - Threshold below which peaks are ignored
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.PeakFinder.helpFixedPoint.
            %
            %   % EXAMPLE #1: Determine whether each value of an input signal is local 
            %   % maximum or minimum. 
            %       hpeaks1 = dsp.PeakFinder;
            %       hpeaks1.PeakIndicesOutputPort = true;
            %       hpeaks1.PeakValuesOutputPort = true;
            %   
            %       x1 = [9 6 10 3 4 5 0 12]';
            %       % Find the peaks of each input [prev;cur;next]: {[9;6;10],[6;10;3],...} 
            %       [cnt1, idx1, val1, pol1] = step(hpeaks1, x1);
            %
            %   % EXAMPLE #2: Determine peak values for a fixed-point input signal.
            %       hpeaks2 = dsp.PeakFinder('PeakType', 'Maxima', ...
            %               'PeakValuesOutputPort', true, ...
            %               'MaximumPeakCount', 2, ...
            %               'IgnoreSmallPeaks', true, ...
            %               'PeakThreshold', 0.25, ...    
            %               'OverflowAction', 'Saturate');
            %       x2 = fi([-1;0.5;0],true,16,15);
            %       [cnt2, val2] = step(hpeaks2, x2);
            %
            %   See also dsp.Maximum, dsp.Minimum, 
            %            dsp.PeakFinder.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.PeakFinder System object 
            %               fixed-point information
            %   dsp.PeakFinder.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   dsp.PeakFinder System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %IgnoreSmallPeaks Enables ignoring peaks below a threshold
        %   Set this property to true if you want to eliminate the detection of
        %   peaks whose amplitudes are within a specified threshold of
        %   neighboring values. The default value of this property is false.
        IgnoreSmallPeaks;

        %MaximumPeakCount Number of extrema to look for in each input signal
        %   The object stops searching the input signal for extrema once the
        %   maximum number of extrema has been found. The value of this
        %   property must be an integer greater than or equal to one. The
        %   default value of this property is 10.
        MaximumPeakCount;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %PeakIndicesOutputPort Enables output of the extrema indices
        %   Set this property to true to output the extrema indices. The
        %   default value of this property is false.
        PeakIndicesOutputPort;

        %PeakThreshold Threshold below which peaks are ignored
        %   Specify the noise threshold value. This property defines the
        %   current input value to be a maximum if (current input value -
        %   previous input value) > threshold and (current input value - next
        %   input value) > threshold. This property is applicable when the
        %   IgnoreSmallPeaks property is set to true. The default value of this
        %   property is 0.
        PeakThreshold;

        %PeakType Looking for maxima, minima, or both
        %   Specify whether the object is looking for maxima, minima, or both.
        %   This property can be set to one of ['Maxima' | 'Minima' | {'Maxima
        %   and Minima'}].
        PeakType;

        %PeakValuesOutputPort Enables output of the extrema values 
        %   Set this property to true to output the extrema values. The default
        %   value of this property is false.
        PeakValuesOutputPort;

        %RoundingMethod Rounding method for fixed-point operations
        %   The rounding method is a constant property with value 'Floor'.
        RoundingMethod;

    end
end
