function outPanel = dateStringPanel(varargin)
%dateStringPanel returns a date panel for plotting
%
%panel textObject defaultPage

%% ---------------- CHANGELOG ------------------------
%  Wed May 4 2011  Abel   
%   - initial creation
%% ---------------- Default parameters ---------------
defParam = [];

% Panel() settings
outPanel = Panel('axes', false, 'nodraw');
panelParam = get(outPanel);
defParam = panelParam; %add to defParam

% textBoxObject() settings
textBox = textBoxObject();
textBoxParam = get(textBox());
textBoxParam.Position = 'West';
defParam = updatestruct(defParam, textBoxParam); %add to defParam

% dateStringPanel() settings
%for Panel()
defParam.position = [0.02 0.02 0.001 0.001];
%for textBoxObject()
defParam.text = datestr(now);
defParam.Rotation = 90;
defParam.Margin = 0.1;
defParam.FontSize = 8;
defParam.LineStyle = 'none';
defParam.BackgroundColor = 'none';

%% ---------------- Main function --------------------
%Check Params
param = getArguments(defParam, varargin);
panelParam = updatestruct(panelParam, param, 'skipnontemplate', true);
textBoxParam = updatestruct(textBoxParam, param, 'skipnontemplate', true);

%Create new textbox
textbox = textBoxObject(param.text, textBoxParam);

%Add box to panel
outPanel = addTextBox(outPanel, textbox, 'noredraw');

%Set panel options
panelFields = fieldnames(panelParam);
for n=1:length(panelFields)
	outPanel = set(outPanel, panelFields{n}, panelParam.(panelFields{n}), 'noredraw');
end



%% ---------------- Local functions ------------------



