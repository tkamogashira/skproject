classdef Scope< handle
%   DSP.PRIVATE.SCOPE is a demo utility object for visualizing
%   streaming data.

 
%   Copyright 2006-2011 The MathWorks, Inc.

    methods
        function out=Scope
            %   DSP.PRIVATE.SCOPE is a demo utility object for visualizing
            %   streaming data.
        end

        function close(in) %#ok<MANU>
        end

        function isLocked(in) %#ok<MANU>
        end

        function setup(in) %#ok<MANU>
            % addPlot(this, plotobj) adds the plot object plotobj to the scope at
            % the next available subplot position determined by the AxesLayout
            % position property.
        end

        function step(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        AxesLayout;

        Name;

        PlotObject;

        Position;

        UpdateRate;

    end
end
