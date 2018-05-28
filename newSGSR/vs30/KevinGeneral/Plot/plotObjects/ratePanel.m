function [outPanel, param] = ratePanel(varargin)
%ratePanel(ds, rate, logX, logY)
%RATEPANEL		Returns an Panel() object specific for rate plots
%
%DESCRIPTION
%               Kplot inplementation of calcRATE(). 
%               Rate: You need to supply either an output struct from calcRATE()
%                     OR indep values and rate values
%               xLabel: You need to supply either a dataset OR specify the
%               label manually.
%
%INPUT
% % ratePanel specific settings
%	defParam.dataset = [];          %dataset (optional)
%	defParam.calcratestruct = [];	%Output structure from calcRATE()
%	                                (optional)
%	defParam.indepval = [];         %independent values (needed if calcratestruct was omitted) 
%	defParam.rate = [];             %rate values (needed if calcratestruct was omitted) 
% % Panel() settings
%	defParam.xlabel = [];           %label for X (optional: 
%                                    If dataset = dataset(), the label will
%                                    be autogenarated using syncXLabel() )
%	defParam.ylabel = 'spk/sec';    %Y-label
%	defParam.title = 'Rate Curve';  %title
%	defParam.ticksDir = 'out';      %tics direction
% % XYPlotObject() settings
%	defParam.Marker = 'x';
% % autoLimits() settings
%	defParam.xmargin = 0;
%	defParam.ymargin = 0.05;
% % plot settings
%	defParam.addHorizontalLine = true; %Add a horizontal line at max rate
%	defParam.addLegend = true;         %Add legend with value for max rate
%
%OUTPUT
%   outPanel                      %Panel() kplot object 
%   param                         %struct of used parameters 
%
%SEE ALSO
% panel calcRATE syncXLabel

%% ---------------- CHANGELOG ------------------------
% 30/11/2010    Abel    Extended first argument checking to allow
% EDFdatasets
%  Tue Apr 26 2011  Abel   
%   - rewrite to generic function 


%% ---------------- Default parameters ---------------
% get Panel() settings
outPanel = Panel('nodraw');
defParam = get(outPanel);
% Add XYPlotObject() settings
XYPLines = XYPlotObject();
defParam = updatestruct(defParam, get(XYPLines));
% Add legendObject() settings
legendObj = legendObject();
defParam = updatestruct(defParam, get(legendObj));
% ratePanel specific settings
defParam.dataset = [];
defParam.calcratestruct = [];	%Output structure from calcRATE()
defParam.indepval = [];
defParam.rate = [];
% Panel() settings
defParam.xlabel = [];           %To be determined lateron by syncXLabel()
defParam.ylabel = 'spk/sec';
defParam.title = 'Rate Curve';
defParam.ticksDir = 'out';
% XYPlotObject() settings
defParam.Marker = 'x';
% autoLimits() settings
defParam.xmargin = 0;
defParam.ymargin = 0.05;
% plot settings
defParam.addHorizontalLine = true;
defParam.addLegend = true;

%% ---------------- Main function --------------------
% return params if nargin<1 / factory
if nargin<1 || strcmpi('factory', varargin{1})
	outPanel = defParam;
	return;
end

%% Param checking
% update defaults
param = getarguments(defParam, varargin);

% determine if all needed params are supplied and get their values
param = checkParams_(param);

%% Panel creation
%Create XYPlotObject() based on X/Y values 
XYPLines = XYPlotObject(param.indepval, param.rate);

%Set XYPlotObject options
xyFields = fieldnames(get(XYPLines));
for n=1:length(xyFields)
	XYPLines = set(XYPLines, xyFields{n}, param.(xyFields{n}));
end

%add XYPlotObject() to panel
outPanel = addPlot(outPanel, XYPLines, 'noredraw');

%Set Panel options 
panelFields = fieldnames(get(outPanel));
for n=1:length(panelFields)
	outPanel = set(outPanel, panelFields{n}, param.(panelFields{n}), 'noredraw');
end

%Set axis limits
outPanel = autoLimits(outPanel, param.xmargin, param.xmargin, 'noredraw');

%% Panel additions
% Dotted line at maximum
if param.addHorizontalLine
	XYMaxLine = horizontalLine('X', param.valatmax, 'Y', param.maxrate);
	outPanel = addPlot(outPanel, XYMaxLine, 'noredraw');
end

% Red dot at maximum with max rate value as legend
if param.addLegend
	%Add red dot at maximum
	XYDot  = XYPlotObject(param.valatmax, param.maxrate, 'Color', 'r', 'Marker', 'o','LineStyle', 'none');
	outPanel = addPlot(outPanel, XYDot, 'noredraw');
	%Calculate nr of XYPlot() objects
	nrPlotElements = length(getFirstHandles(outPanel));
	%build textlabels
	labels = repmat({''}, 1, nrPlotElements -1);
	labels{end+1} = sprintf('Max = %.2f%s\n @ %s:%.2f', param.maxrate, param.ylabel, param.xlabel, param.valatmax);
	%create object
	legendObj  = legendObject('textlabels', labels);
	%set legendObject() options
	legendFields = fieldnames(get(legendObj));
	for n=1:length(legendFields)
		legendObj = set(legendObj, legendFields{n}, param.(legendFields{n}));
	end
	%add to panel
	outPanel = addLegend(outPanel, legendObj, 'noredraw');
end

%% ---------------- Local functions ------------------
function param = checkParams_(param)
gotCalcStruct = ~isempty(param.calcratestruct);
gotDS = ~isempty(param.dataset);

% X:indepval && Y:rate
%If we've got a calcRATE() result, use those values. Otherwise the user
%must suppy the values.
inputField = {'indepval', 'rate'};
for n=1:length(inputField)
	gotParam = ~isempty(param.(inputField{n}));
	
	if  ~gotParam && ~gotCalcStruct
		error('If no output struct from calcRATE() is given, %s must be supplied as input', inputField{n});
	end
	
	if ~gotParam
		param.(inputField{n}) = param.calcratestruct.curve.(inputField{n});
	end
end

% Set X-Label if it was not supplied by the user
gotXlabel = ~isempty(param.xlabel);
%subseqs is needed for xlabel determination using syncXLabel()
%if NOT user supplied, get the values from the calcRATE() struct or the
%dataset.
if ~gotXlabel
	
	%We need either an XLabel or a Dataset
	if ~gotDS
		error('If no dataset was given, you need to suppy an Xlabel');
	end
	
	if  gotCalcStruct
		param.isubseqs = param.calcratestruct.param.isubseqs;
	elseif gotDS
		param.isubseqs = 1:param.dataset.nrec;
	else
		error('If no dataset or calcRATE() result was given, you need to suppy an Xlabel');
	end
	
	param.xlabel = syncXLabel(param.dataset, param.isubseqs);
end

% Max rate
if gotCalcStruct
	param.maxrate = param.calcratestruct.curve.maxrate;
	param.valatmax = param.calcratestruct.curve.valatmax;
else
	[param.maxrate, idx] = max(rate);
	param.valatmax = param.indepval(idx);
end
