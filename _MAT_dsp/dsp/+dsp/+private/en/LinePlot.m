classdef LinePlot< handle
%   Copyright 2009-2013 The MathWorks, Inc.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=LinePlot
            %   Copyright 2009-2013 The MathWorks, Inc.
        end

        function close(in) %#ok<MANU>
            % Update the xticks for the subplot corresponding to this axesobj
        end

        function getTunableProps(in) %#ok<MANU>
        end

        function setup(in) %#ok<MANU>
            % Number of line plots in this subplot
        end

        function step(in) %#ok<MANU>
            % Call the relevant function corresponding to the data plot mode
            %       set(this,varargin{:});
        end

        function validatePropertiesImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        AxisScaling;

        DataPlot;

        FrameSize;

        Legend;

        PlotColor;

        PlotMarker;

        Title;

        X0;

        % XData & YData are cell vectors with each element corresponding to a
        % particular HG line object in an axis
        XData;

        XDataLimit;

        XLabel;

        XResolution;

        YData;

        YLabel;

    end
end
