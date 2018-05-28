function headerObject = redraw(hdl, headerObject)
% REDRAW Draws a HeaderObject on the given handle.
%
% headerObject = redraw(hdl, headerObject)
% Redraws the given headerObject, and returns the new headerObject.
%
%      hdl: The handle on which you want to plot the headerObject. Typically a
%           figure or an axis.

% Written by Ramses de Norre

%% ---------------- CHANGELOG -----------------------
%  Wed Jun 8 2011  Abel   
%   - Rewritten to use annotation('textbox')

%% Check arguments
% number of arguments
if ~isequal(2, nargin)
    error('Incorrect number of arguments.');
end

% check given handle
try
    findobj(hdl);
catch objErr
    error(['Given handle for drawing headerObject is invalid. '...
        'Type ''help redraw'' for more information.']);
end

if ~isequal('HeaderObject', class(headerObject))
    error('Second argument should be a headerObject instance.');
end



%% Extract the different columns
%remove header if it was drawn
gotHead = getHandle(headerObject);
if any(gotHead) ~= 0
	delete(getHandle(headerObject));
end

%Split text based on '|' delimiter
[columns numOfColumns] = explode(headerObject.text,'|');

%Get font size
fontSize = get(headerObject, 'FontSize');

%% Draw annotation boxes
% Annotations are drawn based on the size of the underling Panel() object.
% Position of annotation == normalized figure units. 
% Here we get the axes position in normalized figure units and draw the annotation 
% box in the same place.
axesPos = get(hdl, 'Position');  %OuterPosition can't be used since its not between 0-1
pos = axesPos;
Ypos = pos(2);   %Y-position
Xincr = 0;       %Increment X-position (for adjacent boxes) 
Heigth = pos(4); %Heigth

myHld = cell(1, numOfColumns);
for n = 1:numOfColumns
	String = columns{n};
	Xpos = pos(1)+ Xincr; %New position
	
	%If the box moves of the figure (normalized X-pos > 1, reduce the
	%font size and redraw)
	if Xpos > 1
		headerObject = set(headerObject, 'FontSize', fontSize - 1);
 		redraw(hdl, headerObject);
		return;
	end
	
	%Draw box and let it fit to the text size 
 	myHld{n} = annotation('textbox', [pos(1)+ Xincr, Ypos, 0, Heigth] , 'String', String, 'FitBoxToText', 'on', 'FontSize', fontSize);

	%Get new size after Fitting
	pos =  get(myHld{n}, 'Position');
	Xincr = pos(3);
	set(myHld{n}, 'FitBoxToText', 'off'); %Needed otherwise the boxes 
	                                       %would remain aligned after resizing
	
	%Grow in UP direction, make font auto resize to textbox
	set(myHld{n},  'FontUnits', 'normalized');
	set(myHld{n},  'Position', [pos(1) Ypos pos(3) axesPos(4)]); 
	
	%Set 1,3,... Column bold 
	if isequal(mod(n-1,2),0)
		set(myHld{n},'FontWeight','bold');
	end

    %Set additional options / skip position since it was calculated
	textParams = get(headerObject);
	textParamsFields = fieldnames(textParams);
	for i=1:length(textParamsFields)
		if ~strcmpi(textParamsFields{i}, 'Position') && ~strcmpi(textParamsFields{i}, 'FontSize');
			set(myHld{n}, textParamsFields{i}, textParams.(textParamsFields{i}));
		end
	end
	
	%Save handles from textboxes (when drawn)
	headerObject.hdl(n) = myHld{n};
end
