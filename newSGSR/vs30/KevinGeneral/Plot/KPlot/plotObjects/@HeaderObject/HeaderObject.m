function newHeader = HeaderObject(text, ds, varargin)
% HEADEROBJECT Creates a HeaderObject instance.
%
% newHeader = HeaderObject(text, ds) 
% Creates a HeaderObject object from the given text.
%                 text: The text that will appear in the HeaderObject, this
%                       must be string and the columns are seperated by |
%                   ds: The dataset to get info from

% Created by: Ramses de Norre


%% ---------------- CHANGELOG -----------------------
%  Thu May 5 2011  Abel   
%   - Added new textBoxObject() options 
%  Wed Jun 8 2011  Abel   
%   - Rewrite to use  annotation('textbox') textbox



%% Parameters
% These are identical to annotation('textbox') with some differences in the
% default values. Some  annotation('textbox') settings are set within the redraw()
% function.
newHeader.params.ML.BackgroundColor       = 'w';
newHeader.params.ML.EdgeColor             = 'k';
newHeader.params.ML.Color                 = 'k';
newHeader.params.ML.HorizontalAlignment   = 'center';  
newHeader.params.ML.LineStyle             = '-';
newHeader.params.ML.LineWidth             = 1;
% newHeader.params.ML.Margin                = 1;
% newHeader.params.ML.Position              = 'North';   %Set automatically by redraw()
newHeader.params.ML.VerticalAlignment     = 'middle';
% newHeader.params.ML.FontWeight            = 'normal';  %Set automatically by redraw()
newHeader.params.ML.FontSize              = 7;
newHeader.params.ML.HorizontalAlignment   = 'left';      %Moved here from redraw()

%resize() function -> see defaultPage() 
newHeader.params.RedrawOnResize = false;

%internals: 
% All fields must be predefined, otherwise  HeaderObject() has fewer fields
% than HeaderObject('test'), which is not allowed.
newHeader.hdl = 0;
newHeader.size = 0;
newHeader.text = [];


%% Parameter checking
%if zero arguments, return the defaults
if nargin < 1
	newHeader = class(newHeader, 'HeaderObject');
	return;
end

if ~ischar(text)
    error(['The argument of HeaderObject constructor should be text.' ...
            'Type ''help HeaderObject'' for more information.']);
end

paramsIn = varargin; % these will be checked later, by processParams

%% Assign data
if isequal(lower(text), 'default')
    newHeader.text = getDefaultHeaderText(ds);
else
    newHeader.text = text;
end

newHeader.params = processParams(paramsIn, newHeader.params);

%% Return object
newHeader = class(newHeader, 'HeaderObject');
