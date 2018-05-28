function outPanel = headerPanel( varargin )
%headerPanel return a default panel for the headerObject
%
% INPUT 
% 		defParam.position = [ 0.1  0.9  0.8  0.1 ];
% 		defParam.text = 'default';
% 		defParam.dataset = [];
% SEE ALSO
%		panel headerObject textObject defaultPage

%% ---------------- CHANGELOG ------------------------
%  Wed May 4 2011  Abel
%   - initial creation
%  Thu Jun 9 2011  Abel   
%   - added options of headerObject()

%% ---------------- Default parameters ---------------
defParam = [];

% Panel() settings
outPanel = Panel('axes', false, 'nodraw');
panelParam = get(outPanel);
defParam = panelParam; %add to defParam

% HeaderObject settings
headObj = headerObject();
headParam = get(headObj);
defParam = updatestruct(defParam, headParam);

% headerPanel() settings
defParam.position = [ 0.1  0.9  0.8  0.1 ];
defParam.text = 'default';
defParam.dataset = [];


%% ---------------- Main function --------------------
%Check Params
param = getArguments(defParam, varargin);
panelParam = updatestruct(panelParam, param, 'skipnontemplate', true);

gotDS = isa(param.dataset, 'dataset');
gotDefault = strcmpi(param.text, 'default');

if ~gotDS && gotDefault
	error('For the default header, supply a dataset using the ''dataset'' option');
end

%Create new HeaderObject
headParam = updatestruct(headParam, param, 'skipnontemplate', true);
headObject = HeaderObject(param.text, param.dataset, headParam);

%Add box to panel
outPanel = addTextBox(outPanel, headObject, 'noredraw');

%Set panel options
panelFields = fieldnames(panelParam);
for n=1:length(panelFields)
	outPanel = set(outPanel, panelFields{n}, panelParam.(panelFields{n}), 'noredraw');
end


end
