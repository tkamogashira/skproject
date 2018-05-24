classdef GraphicalPropertyEditorArrayPlot < uiservices.GraphicalPropertyEditor
% GraphicalPropertyEditorArrayPlot  GraphicalPropertyEditorArrayPlot class
    
% Copyright 2012 The MathWorks, Inc.    
    
  methods    
    function this = GraphicalPropertyEditorArrayPlot(varargin)      
      this@uiservices.GraphicalPropertyEditor(varargin{:});
    end
  end
  methods (Access = protected)
      
    function create(this, ip, okCallback, applyCallback, ...
        displaySelectedCallback, closeCallback)
    % Create the graphical property editor GUI
    
    % Code is same as for GraphicalPropertyEditorSpectrumScope except that
    % the Plot Type label and selector is made visible.
            
      % Call super class create method to create the dialog
      create@uiservices.GraphicalPropertyEditor(this, ip, okCallback, applyCallback, ...
        displaySelectedCallback, closeCallback);  
      
      % Remove display selector and line visibility checkboxes and resize
      % the dialog.    
      this.Widgets.DisplaySelectorLabel.Visible = 'off';
      this.Widgets.DisplaySelector.Enable = false;
      this.Widgets.DisplaySelector.Visible = 'off';
      
      pf = uiservices.getPixelFactor;
                   
      offset1 = this.Widgets.DisplaySelectorLabel.Position(4) + 10*pf;
      
      editDlgPos = get(this.EditorDialog,'Position');
      newPos = [editDlgPos(1) editDlgPos(2) editDlgPos(3) editDlgPos(4)-offset1];
      set(this.EditorDialog,'Position',newPos);
      
      offset1 = this.Widgets.DisplaySelectorLabel.Position(4) - 19*pf;
      offFactor = 30*pf;
      
      this.Widgets.FigureColorLabel.Position(2) = this.Widgets.FigureColorLabel.Position(2) - offFactor;
      this.Widgets.FigureColorPicker.Position(2) = this.Widgets.FigureColorPicker.Position(2) - offFactor;
      
      % Restore Plot Type widget
      this.Widgets.PlotTypeLabel.Position(2) = this.Widgets.PlotTypeLabel.Position(2) - offFactor;
      this.Widgets.PlotTypeSelector.Position(2) = this.Widgets.PlotTypeSelector.Position(2) - offFactor;
      
      sepLinePos = get(this.Widgets.SeparatorLine2,'Position');
      newPos = [sepLinePos(1) sepLinePos(2)-offFactor sepLinePos(3:4)];
      set(this.Widgets.SeparatorLine2,'Position',newPos);      
      
      newAxesWidgetsBottom = newPos(2) + newPos(4) + 10*pf;
      this.Widgets.AxesColorsLabel.Position(2) = newAxesWidgetsBottom;
      this.Widgets.AxesBackgroundPicker.Position(2) = newAxesWidgetsBottom;
      this.Widgets.AxesForegroundPicker.Position(2) = newAxesWidgetsBottom;            
      this.Widgets.LineSelectorLabel.Position(2) = this.Widgets.LineSelectorLabel.Position(2) + offset1;
      this.Widgets.LineSelector.Position(2) = this.Widgets.LineSelector.Position(2) + offset1;
      
      this.Widgets.LinePanel.Position(2) = this.Widgets.LinePanel.Position(2) + offset1;
      sepLinePos = get(this.Widgets.SeparatorLine1,'Position');
      newPos = [sepLinePos(1) sepLinePos(2)+offset1 sepLinePos(3:4)];
      set(this.Widgets.SeparatorLine1,'Position',newPos);
      this.Widgets.OkButton.Position(2) = this.Widgets.OkButton.Position(2) + offset1;
      this.Widgets.CancelButton.Position(2) = this.Widgets.CancelButton.Position(2) + offset1;
      this.Widgets.ApplyButton.Position(2) = this.Widgets.ApplyButton.Position(2) + offset1; 
    end
  end
end
