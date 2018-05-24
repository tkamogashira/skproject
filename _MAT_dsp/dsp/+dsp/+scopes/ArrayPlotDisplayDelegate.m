classdef ArrayPlotDisplayDelegate < scopeextensions.TimeDomainDisplayDelegate
    %ArrayPlotDisplayDelegate   ArrayPlotDisplayDelegate class 

% Copyright 2012 The MathWorks, Inc.
    
    methods

    end
    
    methods(Static)
        function hDisplay = create(displayContainer, displayPlacement)
            %create   Factory method to create new ArrayPlotDisplay
            %   DISPLAY = create(CONTAINER, PLACEMENT) creates new display
            %   with parent CONTAINER and placement PLACEMENT.
            
            hDisplay = dsp.scopes.ArrayPlotDisplay(displayContainer, displayPlacement);
            
        end
        
        function hDisplay = deserialize(gridContainer, serializedDisplay)
            %deserialize   Reconstruct display
            %   [DISPLAY, PROPS] = ArrayPlotDisplay.deserialize(HPARENT, SERIALIZED)
            %   returns ArrayPlottDisplay object DISPLAY that is parented
            %   to HPARENT and reconstructed from serialized display
            %   SERIALIZED.  
            
            displayPlacement = serializedDisplay.Placement;
            hDisplay = dsp.scopes.ArrayPlotDisplay(gridContainer, displayPlacement);
            
        end
    end

end
