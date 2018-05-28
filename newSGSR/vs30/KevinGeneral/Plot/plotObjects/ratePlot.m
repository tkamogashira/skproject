function [plotOut, param] = ratePlot(varargin)
% RATEPLOT	Plots the rate of a dataset. The calculations are done by
% CalcRATE() and the plotting by ratePanel(). First argument should be a dataset. Optional arguments are
% identical to those of CalcRATE() and ratePanel()
% 
% SEE ALSO 
% CalcRATE ratePanel

%% ---------------- CHANGELOG ------------------------
%  Tue May 3 2011  Abel   
%   - Rewrite to use new ratePanel() syntax
%% ---------------- Default parameters ---------------
calcRateParam = CalcRate();
ratePanelParam = ratePanel();
defParam = updatestruct(calcRateParam, ratePanelParam);
% defParam.
defParam.help = 'ratePlot(ds)';

param = [];
panel = [];
%% ---------------- Main function --------------------
% Return params if nargin<1 / factory
if nargin<1 || strcmpi('factory', varargin{1})
	plotOut = defParam;
	return;
end

%% Check arguments
%First argument should be a dataset
ds = varargin{1};
if ~isa(ds, 'dataset')
    error(['First argument of ' upper(mfilename) ' should be a dataset.']);
end
defParam.dataset = ds;	%We've already confirmed this 

%Check arguments
if nargin > 1
	argIn = varargin{2:end};
else
	argIn = [];
end
param = getArguments(defParam, argIn);


%% Calculate rate 
calcRateParam = updatestruct(calcRateParam, param, 'skipnontemplate', true);
rate = CalcRATE(ds, calcRateParam);
param.calcratestruct = rate;


%% Plot rate
ratePanelParam = updatestruct(ratePanelParam, param, 'skipnontemplate', true);
%ratePanel
pageParam.panelObjects = ratePanel(ratePanelParam);
%headerPanel
pageParam.headerObject = headerPanel('dataset', param.dataset);
%stringPanel
pageParam.dateStringObject = dateStringPanel();

plotOut = plotPage(pageParam);


%% ---------------- Local functions ------------------
