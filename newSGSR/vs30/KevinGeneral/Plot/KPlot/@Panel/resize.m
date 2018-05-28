function panel = resize(panel)
%RESIZE         Resizes the elements of a panel based on their
%               RedrawOnResize parameter. 

%% ---------------- CHANGELOG ------------------------
%  Tue Jun 7 2011  Abel   
%   Initial creation 
%% ---------------- Default parameters ---------------

%% ---------------- Main function --------------------
% Redraw textObjects if needed
% - for positioning of headerObject (Obsolete)
panel.textObjects = doRedrawIfNeeded_(panel.textObjects, panel);

% - for zoom of legendObjects
panel.legendObjects = doRedrawIfNeeded_(panel.legendObjects, panel);

end

%% ---------------- Local functions ------------------
function redrawObject = doRedrawIfNeeded_(redrawObject, panel)
	nrObj = size(redrawObject, 2);
	for i = 1:nrObj
		doRedraw = getRedrawOnResize(redrawObject{i});
		if doRedraw
			redrawObject{i} = redraw(redrawObject{i}, panel);
		end
	end
end