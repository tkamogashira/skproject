classdef VariableIntegerDelay< handle
%VariableIntegerDelay Delay input by time-varying integer number of sample
%periods
%   HVID = dsp.VariableIntegerDelay returns a variable integer delay System
%   object, HVID, that delays discrete-time input by a time-varying integer
%   number of sample periods.
%
%   HVID = dsp.VariableIntegerDelay('PropertyName', PropertyValue, ...)
%   returns a variable integer delay object, HVID, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HVID, X, D) delays the input X by D samples, where D should be
%   less than or equal to the value specified in the MaximumDelay property
%   and greater than or equal to 0. Delay values outside this range are
%   clipped appropriately and non-integer delays are rounded to the nearest
%   integer values.
%
%   VariableIntegerDelay methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create variable integer delay object with same property
%              values
%   isLocked - Locked status (logical)
%   reset    - Reset the states to initial conditions
%
%   VariableIntegerDelay properties:
%
%   MaximumDelay         - Maximum delay
%   InitialConditions    - Initial values in the memory
%   DirectFeedthrough    - Choice to enable direct feedthrough
%   FrameBasedProcessing - Process input in frames or as samples
%
%   % EXAMPLE: Use a VariableIntegerDelay System object to delay a signal by 
%   %          a varying integer number of sample periods. 
%       hvid = dsp.VariableIntegerDelay;
%       x = 1:100;
%       ii = 0;
%       k = 0;
%       yout = [];
%       while(ii+10 <= 100)
%           y = step(hvid, x(ii+1:ii+10)',k*ones(10,1));
%           yout = [yout;y];
%           ii = ii+10;
%           k = k+1;
%       end
%       stem(x,'b');
%       hold on; stem(yout,'r');
%       legend('Original Signal', 'Variable Integer Delayed Signal')
% 
%   See also dsp.VariableFractionalDelay, dsp.Delay,
%   dsp.DelayLine. 

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=VariableIntegerDelay
            %VariableIntegerDelay Delay input by time-varying integer number of sample
            %periods
            %   HVID = dsp.VariableIntegerDelay returns a variable integer delay System
            %   object, HVID, that delays discrete-time input by a time-varying integer
            %   number of sample periods.
            %
            %   HVID = dsp.VariableIntegerDelay('PropertyName', PropertyValue, ...)
            %   returns a variable integer delay object, HVID, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HVID, X, D) delays the input X by D samples, where D should be
            %   less than or equal to the value specified in the MaximumDelay property
            %   and greater than or equal to 0. Delay values outside this range are
            %   clipped appropriately and non-integer delays are rounded to the nearest
            %   integer values.
            %
            %   VariableIntegerDelay methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create variable integer delay object with same property
            %              values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states to initial conditions
            %
            %   VariableIntegerDelay properties:
            %
            %   MaximumDelay         - Maximum delay
            %   InitialConditions    - Initial values in the memory
            %   DirectFeedthrough    - Choice to enable direct feedthrough
            %   FrameBasedProcessing - Process input in frames or as samples
            %
            %   % EXAMPLE: Use a VariableIntegerDelay System object to delay a signal by 
            %   %          a varying integer number of sample periods. 
            %       hvid = dsp.VariableIntegerDelay;
            %       x = 1:100;
            %       ii = 0;
            %       k = 0;
            %       yout = [];
            %       while(ii+10 <= 100)
            %           y = step(hvid, x(ii+1:ii+10)',k*ones(10,1));
            %           yout = [yout;y];
            %           ii = ii+10;
            %           k = k+1;
            %       end
            %       stem(x,'b');
            %       hold on; stem(yout,'r');
            %       legend('Original Signal', 'Variable Integer Delayed Signal')
            % 
            %   See also dsp.VariableFractionalDelay, dsp.Delay,
            %   dsp.DelayLine. 
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %DirectFeedthrough Choice to enable direct feedthrough 
        %   Select if the System object should enable direct feedthrough.
        %   Setting this property to false increases the minimum possible delay
        %   by one. The default value of this property is true.
        DirectFeedthrough;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %   property to false to enable sample-based processing. The default
        %   value of this property is true. 
        FrameBasedProcessing;

        %InitialConditions Initial values in memory
        %   Specify the values with which the object's memory is initialized.
        %   The dimensions of this property can vary depending on the setting
        %   of the FrameBasedProcessing property, and whether you want fixed or
        %   time-varying initial conditions. The default value of this property 
        %   is 0.
        %   When you set the FrameBasedProcessing property to false, the object
        %   supports N-dimensional input arrays. For an M-by-N-by-P
        %   sample-based input array U, you can set the InitialConditions
        %   property as follows:  
        %   * To specify fixed initial conditions, set the InitialConditions
        %   property to a scalar value. The object initializes every sample of
        %   every channel in memory using the value you specify.
        %   * To specify time-varying initial conditions, set the
        %   InitialConditions property to an array of dimension
        %   M-by-N-by-P-by-D. The object uses the values in this array to
        %   initialize memory samples U(2:D+1), where D is the value of the
        %   MaximumDelay property. 
        %   When you set the FrameBasedProcessing property to true, the object
        %   treats each of the N input columns as a frame containing M
        %   sequential time samples from an independent channel. For an M-by-N
        %   frame-based input matrix U, you can set the InitialConditions
        %   property as follows:
        %   * To specify fixed initial conditions, set the InitialConditions
        %   property to a scalar value. The object initializes every sample of
        %   every channel in memory using the value you specify.
        %   * To specify different time-varying initial conditions for each
        %   channel, set the InitialConditions property to an array of size
        %   1-by-N-by-D, where D is the value of the MaximumDelay property.
        InitialConditions;

        %MaximumDelay Maximum delay
        %   Specify the maximum delay the object can produce for any input
        %   sample. The maximum delay must be a positive scalar integer value.
        %   The object clips input delay values greater than the MaximumDelay
        %   to the MaximumDelay. The default value of this property is 100.
        MaximumDelay;

    end
end
