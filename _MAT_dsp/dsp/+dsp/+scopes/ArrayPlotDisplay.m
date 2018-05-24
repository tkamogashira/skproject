classdef ArrayPlotDisplay < scopeextensions.TimeDomainDisplay
%ArrayPlotDisplay  ArrayPlotDisplay  class    
    
% Copyright 2012 The MathWorks, Inc.
    
%     properties
%      
    properties
        DefaultMarker;
    end
    
    methods
        
        function this = ArrayPlotDisplay(hContainer, placementNum)
            
            % Call the superclass CTOR
            this = this@scopeextensions.TimeDomainDisplay(hContainer, placementNum);
            
            this.DefaultMarker = 'o';
            
            % This gets (sec) out of the lower right  display dialog
            % element.
            this.TimeUnits = '';
            
        end
        
        function set.DefaultMarker(this, defaultMarker)                                    
            this.DefaultMarker = defaultMarker;
            this.LinePropertyDefaults.Marker = this.DefaultMarker;
        end
        
        function updateCachedLinePropertiesMarkers(this)            
            for i=1:length(this.LinePropertiesCache)
                this.LinePropertiesCache{i}.Marker = this.DefaultMarker;
            end            
        end
        
        function newXLim = calculateXLim(this, ~)
            
            timeDisplayOffset = this.TimeDisplayOffset;
            timeSpan          = this.TimeSpan;
            
            % Set limits slightly inside the display to prevent clipping
            % and non-display of markers at edges.
            newXLim = max(timeDisplayOffset) + timeSpan*[-0.003 1+0.003];                        
        end
     end
    
    methods(Static)
        function delegate = getDelegate    
            % getDelegate   Return delegate for ArrayPlotDisplay
            
            delegate = dsp.scopes.ArrayPlotDisplayDelegate;
        end
                
    end
    
    methods
        
    function propStruct = getCloneProperties(this)
            %getCloneProperties   Get properties struct to create clone
            %   PROPS = getCloneProperties(THIS) returns a structure of
            %   properties PROPS that may be passed into ArrayPlotDisplay 
            %   in order to create a clone of THIS display.  The clone will 
            %   have the same display properties as THIS display but will 
            %   not have the same content.
            
            propStruct = getCloneProperties@scopeextensions.TimeDomainDisplay(this);
            
            % Add XLabel property
            propStruct.XLabel = this.XLabel;                       
    end
    
        function updateTimeOffsetReadout(~,~)            
        % Overrides updateTimeOffsetReadout in TimeDomainPlotter.
        % Does not update the readout because it is disabled.
        end                
    
    end
   
    
    methods (Access=protected)        
    
    function updateXLabel(this)
            %UPDATEXLABEL
            
            % Delete existing label texts, since these will either be unnecessary (if
            % axes not maximized) or need to be replaced (if axes maximized).
            if ~isempty(this.XLabelText)
                delete(this.XLabelText);
                this.XLabelText = [];
            end
            
            % Return early if not showing labels
            if ~this.ShowTimeAxisLabels
                return;
            end
            
            xLabel = this.privXLabel;
            
            if this.MaximizeAxes
                
                setXLabelAndVisibility(this, xLabel, 'off');
                
                if ~isempty(this.privXLabel)
                    hAxes = getInsideLabelsAxes(this);
                    
                    % Create xlabel text in lower-right corner
                    [~, textColor] = getLegendColors(this);
                    this.XLabelText = text(1, 0, [this.privXLabel ' '], ...
                        'Interpreter', 'none', ...
                        'Tag', 'XTextLabel', ...
                        'Units', 'norm', ...
                        'Color', textColor, ...
                        'HorizontalAlignment', 'right', ...
                        'VerticalAlignment', 'bottom', ...
                        'FontName', get(hAxes, 'FontName'), ...
                        'FontSize', get(hAxes, 'FontSize'), ...
                        'Parent', hAxes);
                end                                
            else
                setXLabelAndVisibility(this, xLabel, 'on');
                axLabelColor = this.AxesTickColor;
                for ax = this.Axes
                    set(get(ax, 'XLabel'), 'Color', axLabelColor);
                end
            end
    end 
        
    function setXLabelAndVisibility(this, newLabel, visibility)

    if this.PlotMagPhase
        % Font size of labels must be consistent with axes font size
        xlabel(this.Axes(1),newLabel, 'Visible', visibility, ...
            'Interpreter', 'none');
        xlabel(this.Axes(2),newLabel, 'Visible', visibility, ...
            'Interpreter', 'none');
    else
       xlabel(this.Axes(1),newLabel, 'Visible', visibility, ...
            'Interpreter', 'none');         
    end
    
    end   
    
end
    
end

%[EOF]
