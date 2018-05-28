function [XYLineObject, param] = horizontalLine(varargin)
%% ---------------- CHANGELOG ------------------------
%  Tue May 3 2011  Abel   
%   - Initial creation

%% ---------------- Default parameters ---------------
% XYPlotObject() defaults
XYLineObject = XYPlotObject();
defParam = get(XYLineObject);
% horizontalLine specific settings
defParam.X = [];
defParam.Y = [];
defParam.Ymin = 0;
defParam.YFillFactor = 1;

defParam.Marker = 'none';
defParam.LineStyle = {':'};
defParam.Color = 'k';



%% ---------------- Main function --------------------
% return params if nargin<1 / factory
if nargin<1 || strcmpi('factory', varargin{1})
	XYLineObject = defParam;
	return;
end

%% Param checking
% update defaults
param = getarguments(defParam, varargin);
if isempty(param.X) || isempty(param.Y)
	error('You need to supply at least an X and Y value for horizontalLine()');
end

%% XYPlotObject creation
% Determine number of Y points
Y = [param.Ymin : param.YFillFactor : round(param.Y)];
X = repmat(param.X, 1, length(Y));

%Create XYPlotObject() based on X/Y values 
XYLineObject = XYPlotObject(X, Y);
%Set XYPlotObject options
xyFields = fieldnames(get(XYLineObject));
for n=1:length(xyFields)
	XYLineObject = set(XYLineObject, xyFields{n}, param.(xyFields{n}));
end
%% ---------------- Local functions ------------------

end