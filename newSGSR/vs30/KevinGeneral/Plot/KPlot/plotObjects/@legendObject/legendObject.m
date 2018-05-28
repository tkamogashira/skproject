function newLegend = legendObject(varargin)
% LEGENDBOXOBJECT Creates a legendObject instance.
%
% newTextBox = legendObject('textlabels', {'label1', 'label2'}, paramList) 
% Creates an legendObject object from the given textlabels. Parameter pairs can be
% given in paramList.
%
%           textlabels: The text that will appear in the legendObject. The
%                       labels must be given as a cell (for example: {'label1',
%                       'label2'}). If an empty label is introduced, the corresponding
%                       plot element will be unlabeled. So if a panel object contains a
%                       plot with 2 lines, adding the label object
%                       legendObject('textlabels', {'', 'label2'}) will leave the first
%                       line unlabeled. 
%            EdgeColor: Color of the border.
%            TextColor: Color of the labels
%             Position: Either a 1x2 numeric array (in units normalized to 
%                       the axes), or one of the following strings:
%                         'North'              inside plot box near top
%                         'South'              inside bottom
%                         'East'               inside right
%                         'West'               inside left
%                         'NorthEast'          inside top right (default)
%                         'NorthWest           inside top left
%                         'SouthEast'          inside bottom right
%                         'SouthWest'          inside bottom left
%             FontSize: integer number of points
%
% SEE ALSO	legend	panel 


%% ---------------- CHANGELOG ------------------------
%  Tue Apr 19 2011  Abel   
%   Initial creation based on code of Kevin Spiritus
%  Tue Jun 7 2011  Abel   
%   Added resize handling 


%% ---------------- Default parameters ---------------
% Assign data
newLegend.hdl = 0;
newLegend.size = 0;

% Define structure of parameters: just fill with defaults
% ML: matlab options
newLegend.params.ML.EdgeColor             = 'k';
newLegend.params.ML.TextColor             = 'k';
newLegend.params.ML.Location              = 'Best';
newLegend.params.ML.FontSize              = 8;
% newLegend.params.ML.FontUnits             = 'normalized'; %No effect? -> solved by adding resize function
% newLegend.params.ML.FontUnits             = 'points';     %This is the
% matlab default. Lets keep the user from changing this to simplify
% redraw()when resizing.
                                                  
% Local options
newLegend.params.textlabels               = {''}; %Empty placeholder for legend text
newLegend.params.RedrawOnResize          = true; %Redraw legend on resize 


%% ---------------- Main function --------------------
paramsIn = varargin;
% Parameters given as arguments are placed in the params structure.
% Other entries remain 'def'. This def value is replaced when plotting.
newLegend.params = processParams(paramsIn, newLegend.params);

%% Return object
newLegend = class(newLegend, 'LegendObject');
%% ---------------- Local functions ------------------
end