function [argOut,param] = THRCorr(varargin)
% THRCORR			Cross correlation of two THR curves
%  DESCRIPTION	
%  Calculate X-Correlation of THR curves. First, the dB (SPL) values
%  are transformed to amplitude or power curves. The obtained curves are resampled and cross correlated. 
%  Additionally, the geometric centers of both THR curves are compared by
%  taking their average. 
%
%  INPUT
%	ds1 = [];			THR dataset 1
%	ds2 = [];			THR dataset 2
%	plot = true;			Create plots? true/false
%	smplfactor = 10;		Resampling factor. Number of samples = Nr of
%							frequencies * smplfactor
%	fit = 'none';			Fit THR curves? (see EvalTHR for options)
%	tailcutoff = 'no';		Remove tail from THR curve (see EvalTHR)
%   runav = 0;				Number of points to use in runav (see EvalTHR)
%	plotcolors = {'r', 'b'};	Colors for plots
%	freqrange = [];			Select frequency range for correlation.
%					Values can be: 
%						'overlap' (Default) select overlapping frequencies
%						'all' Use total frequency range [min(thr1 thr2):max(thr1 thr2)]
%                       [1:10]  Use a user defined range.
%	extrapolatemethod = 'linear';	Method used in interp1() for extrapolation
%	xcorrcurv = 'amplitude';	'amplitude' or 'power': Perform correlation on amplitude or power
%								curves.
%   dCFConvention = 'CF1 - CF2'; Convention for dCF calculation:  'CF1 - CF2' or 'CF2 - CF1'
%
%	extrapolate = false;		!ATTENTION extrapolation of THR curves is ambiguous, 
%                               enable this option for testing purposes only. 
%                               When 'false', any out-of-range SPL value is
%					            set to 0. If 'true', SPL values are extrapolated.
%  OUTPUT
%	argOut.thr1 = S1;		THR info (see EvalTHR)
%	argOut.thr2 = S2;
%	argOut.dfmax = dFmax;		frequency difference at max correlation
%	argOut.xcorr = xCorrVal;	max xcorrelation value
%
%  EXAMPLES
% 	DF='A0242';
% 	cells = [1:3 7:20];
% 	for n=cells
% 		t1 = getThr4Cell(DF, n);
% 		t2 = getThr4Cell(DF, n+1);
% 		ds1 = dataset(DF,t1.seqnr);
% 		ds2 = dataset(DF,t2.seqnr);
% 		T=THRCorr('ds1', ds1,'ds2', ds2, 'plot', true, 'fit', 'runav', 'runav', 10);
% 		pause
% 	end
%
%  SEE ALSO		EvalTHR	     interp1      trapz      xcorr


%% ---------------- CHANGELOG ------------------------
%  Mon Apr 4 2011  Abel
%  - Initial creation
%  Wed Apr 6 2011  Abel
%  - Added calculation of plot sizes (subplot)
%  Fri Apr 8 2011  Abel   
%  - Rewrite + Added TODO 1:4
%  Tue Apr 19 2011  Abel   
%   - Added legendObject handling 
%  Thu Apr 28 2011  Abel   
%   - Added dCF convention param/plot output 
%  Fri Apr 29 2011  Abel   
%   - Added geometric center comparison 
%  Wed Jun 8 2011  Abel   
%   - adapted for new headerObject() and pagePlot()


%% ---------------- TODO -----------------------------
% 1) Does interpolation/resampling have an effect on the outcome? > Should not
% be for X-Correlation.
% 2) Allow X-correlation on the total range without extrapolation. > Set
% dB(SPL) values to +inf in the data or to 0 in the power/amplitude curve.
% 3) Include X-Correlation based on the amplitude curve instead of the
% power. In the latter, the noise jitter between points in the THR curve is
% enhanced.
% 4) Change work flow, create positive normalized THR curves first and
% perform resampling on these curves.

%% ---------------- Default parameters ---------------
defaultParams.ds1 = [];
defaultParams.ds2 = [];
defaultParams.plot = true;
defaultParams.smplfactor = 10;
defaultParams.fit = 'none';
defaultParams.tailcutoff = 'no';
defaultParams.plotcolors = {'r', 'b'};
defaultParams.help = { [mfilename '(''ds1'',ds1, ''ds2'', ds2)' ]};
defaultParams.freqrange = ['overlap'];		%Values can be: [range], 'all', 'overlap'
defaultParams.extrapolate = false;	%Set to true to get the range [min(thr1 th2):max(thr1 thr2)]
defaultParams.extrapolatemethod = 'linear';
defaultParams.xcorrcurve = 'amplitude'; % amplitude or power
defaultParams.runav      = 10;
defaultParams.dCFConvention = 'CF1 - CF2'; %Convention for dCF calculation:  'CF1 - CF2' or 'CF2 - CF1'
argOut = [];

%% ---------------- Main function --------------------
%% Load DATA via EvalTHR()
% Return factory defaults or get user supplied params
param = getarguments(defaultParams, varargin);

% Load THR data
S1 = EvalTHR(param.ds1, 'plot', 'no', 'fit', param.fit, 'tailcutoff', param.tailcutoff, 'runav', param.runav);
S2 = EvalTHR(param.ds2, 'plot', 'no', 'fit', param.fit, 'tailcutoff', param.tailcutoff, 'runav', param.runav);
argOut.thr1 = S1;
argOut.thr2 = S2;

% Get frequency and spl values
% - if ~empty(fit), use fitted results
if ~strcmpi(param.fit, 'none')
	%X-Values
	freq1 = S1.fit.freq;
	freq2 = S2.fit.freq;
	%Y-Values
	spl1 = S1.fit.thr;
	spl2 = S2.fit.thr;
	%CF
	CF1 = S1.fit.cf;
	CF2 = S2.fit.cf;
else
	%Y-Values (may contain NaN's)
	[spl1, indx] = denan(S1.thr.thr);
	[spl2, indy] = denan(S2.thr.thr);
	%X-Values
	freq1 = S1.thr.freq(indx);
	freq2 = S2.thr.freq(indy);
	%CF
	CF1 = S1.thr.cf;
	CF2 = S2.thr.cf;
end
% - get dCF (CF1-CF2 or visa versa)
dCF = eval(param.dCFConvention);

% Add plot of original THR's
if param.plot
	%Parameters and options for plot
	param.plotobjects = [];
	param.plotpanel = [];
	panel = Panel('nodraw');
	colors =  ([repmat({param.plotcolors{1}}, 1, 3) repmat({param.plotcolors{2}}, 1, 3)])';
	markers = (repmat({'o', 'none', 'X'}, 1, 2))';
	linestyle =  (repmat({'none', '-', 'none'}, 1, 2))';
	markersize = (repmat({4, 4, 20}, 1, 2))';
	%for thr1
	Xdata{1,:} = freq1;
	Ydata{1,:} = spl1;
	Xdata{2,:} = freq1;
	Ydata{2,:} = spl1;
	Xdata{3,:} = CF1;
	Ydata{3,:} = min(spl1);
	%For thr 2
	Xdata{4,:} = freq2;
	Ydata{4,:} = spl2;
	Xdata{5,:} = freq2;
	Ydata{5,:} = spl2;
	Xdata{6,:} = CF2;
	Ydata{6,:} = min(spl2);
	
	%Generate XYPlotObject's
	param.plotobjects{1} = XYPlotObject(Xdata, Ydata, ...
		'marker', markers,...
		'linestyle', linestyle,...
		'MarkerSize', markersize,...
		'color', colors);
	
	%Create new panel & set options
	panel = addPlot(panel, param.plotobjects{1}, 'noredraw');
	yLabel = 'Threshold (dB SPL)';
	xLabel = 'Frequency';
	title = 'THR Curves';
	panel = set(panel, 'title', title, 'xlabel', xLabel, 'ylabel', yLabel, ...
		'noredraw');
	text = [sprintf('dCF = %.2f\n(%s)\n\n', dCF, param.dCFConvention)];
	subSeqTextBox = textBoxObject(text, ...
		'LineStyle', 'none', 'BackgroundColor', 'none', 'Position', 'SouthEast');
	panel =  addTextBox(panel, subSeqTextBox, 'noredraw');
	
	legendObj = legendObject('textlabels', {'', '', sprintf('CF1 = %.2f', S1.thr.cf), '', '', sprintf('CF2 = %.2f', S2.thr.cf)});
	panel =  addLegend(panel, legendObj, 'noredraw');
	
	%save panel for latter plotting
	param.plotpanel{1} = panel;
	
end

%% Transfer THR curves to normalized positive and lineair curves
% Options are: amplitude/power (i.e. squared) curves
Ymin1 = min(spl1);
Ymin2 = min(spl2);

% THR curves positive Ymax ~ inf dB -> Ymin ~ inf dB
% transformation:  reciprocal curve relative to minimum of threshold curve (--> 0dB)
Ypos1 = Ymin1 - spl1;  %(these are dB's!)
Ypos2 = Ymin2 - spl2;

if strcmpi(param.xcorrcurve, 'power')
	% transform to linear power values
	Y1 = 10.^( Ypos1 * 0.1 );
	Y2 = 10.^( Ypos2 * 0.1 );
elseif strcmpi(param.xcorrcurve, 'amplitude')
	% using amplitude instead of power (less amplification of jitter)
	Y1 = 10.^( Ypos1 * 0.05 );
	Y2 = 10.^( Ypos2 * 0.05 );
else
	error('Option: xcorrcurve must be ''power'' or ''amplitude''');
end

%Add plot of power/amplitude curves
if param.plot
	clear Xdata Ydata;
	panel = Panel('nodraw');
	colors = {param.plotcolors{1}; param.plotcolors{2}};
	
	Xdata{1,:}  = freq1;
	Ydata{1,:}  = Y1;
	Xdata{2,:}  = freq2;
	Ydata{2,:}  = Y2;
	
	param.plotobjects{end+1} = XYPlotObject(Xdata, Ydata, ...
		'marker', 'none',...
		'linestyle', {'-'},...
		'color', colors);
	panel = addPlot(panel, param.plotobjects{end}, 'noredraw');
	
	if strcmpi(param.xcorrcurve, 'power')
		% transform to linear power values
		yLabel = 'Power (10.^(^Y^*^0^.^1^))';
	elseif strcmpi(param.xcorrcurve, 'amplitude')
		% using amplitude instead of power (less amplification of jitter)
		yLabel = 'Amplitude (10.^(^Y^*^0^.^0^5^))';
	else
		error('Option: xcorrcurve must be ''power'' or ''amplitude''');
	end
	
	xLabel = 'Frequency';
	title = 'Power/Amplitude Curves';
	
	panel = set(panel, 'title', title, 'xlabel', xLabel, 'ylabel', yLabel, ...
		'noredraw');
	
	legendObj = legendObject('textlabels', {'ds1', 'ds2'});
	panel =  addLegend(panel, legendObj, 'noredraw');
	panel = addLegend(panel, legendObj, 'noredraw');
	
	param.plotpanel{end+1} = panel;
end

%% Frequency range resampling of the nomalized curves
% The resampling is achieved by interpolation using the interp1() and NOT
% by true resampling via the signal/resample() method. In the case of THR data the
% latter is not expected to influence the outcome because of the noisy
% data. True resampling is important for the retrieval of a real function
% (for example tones)
%
% Default: get the overlap in X-range of THR1 & THR2
% Option 1: extrapolate to maximum X-range
% Option 2: user defined range
% Option 3: maximum range without extrapolation (out of range frequencies
% are set to 0)

%Range && extrapolate?
doExtrapolate = param.extrapolate;
rangeAll = strcmpi(param.freqrange, 'all');
rangeOverlap = strcmpi(param.freqrange, 'overlap');
rangeUser = isa(param.freqrange, 'double');

if (rangeAll + rangeOverlap + rangeUser == 0)
	error('Option: ''freqrange'' should be either ''all'', ''overlap'' or [range]');
end

%Get X-range && N (number of elements) for interpolation
if rangeOverlap
	% Default option:
	%get overlap in freq range of THR curves
	[indfreq1 indfreq2] = overlap(freq1, freq2);
	
	% overlapping X/Y-values (freq)
	X1 = freq1(indfreq1);
	X2 = freq2(indfreq2);
	Y1 = Y1(indfreq1);
	Y2 = Y2(indfreq2);
	
	%Estimate number of freq elements: Get identical X-axis (max elements
	%= max resolution of frequency)
	if length(X1) > length(X2)
		X = X1;
	else
		X = X2;
	end
	N = length(X);
	
elseif rangeAll && doExtrapolate
	% Option 1:
	%estimate number of freq elements
	X = union(round(freq1), round(freq2));	%no repetitions
	N = length(X);
	
	%X-values (Y-Values remain equal)
	X1 = freq1;
	X2 = freq2;
	
elseif rangeAll && ~doExtrapolate
	% Option 3:
	% Extend the Y-Values with zeros to the total [X1 X2]
	[ X1, Y1, X2, Y2 ] = zeroFiller_(freq1, Y1, freq2, Y2);
	
	%Estimate number of freq elements: Get identical X-axis (max elements
	%= max resolution of frequency)
	if length(X1) > length(X2)
		X = X1;
	else
		X = X2;
	end
	N = length(X);
	
elseif rangeUser
	% Option 2:
	X = param.freqrange;
	outOfRange = any([(X) < min(freq1),...
		min(X) < min(freq2),...
		max(X) > max(freq1),...
		max(X) > max(freq2)]);
	
	%Fill with zeros when freqrange > Xrange && ~doExtrapolate
	if outOfRange && ~doExtrapolate
		Y = zeros(1, length(X));
		[ ~, ~, X1, Y1 ] = zeroFiller_(X, Y, freq1, Y1);
		[ ~, ~, X2, Y2 ] = zeroFiller_(X, Y, freq2, Y2);
	else
		%X-values (Y-Values remain equal)
		X1 = freq1;
		X2 = freq2;
	end
	N = length(X);
	
else
	error('Range parameters not compatible');
end

%Resample data:
%Get linear spaced X-range for resampling
X = linspace(min(X), max(X), param.smplfactor*N);

%Lineair interpolation/extrapolation
if doExtrapolate
	Yfit1 = interp1(X1,Y1,X, param.extrapolatemethod, 'extrap');
	Yfit2 = interp1(X2,Y2,X, param.extrapolatemethod, 'extrap');
else
	Yfit1 = interp1(X1,Y1,X);
	Yfit2 = interp1(X2,Y2,X);
end

%Warn if CF was not within selected frequency range
plotWarn = false;
if (CF1 < min(X)) || (CF2 < min(X)) || (CF1 > max(X)) || (CF2 > max(X))
	warning('SGSR:Critical', 'At least one of the CF values was not in range of the selected frequencies');
	plotWarn = true;
end

%Add plot of resampled THR's
if param.plot
	panel = Panel('nodraw');
	clear Xdata Ydata;
	colors =  ([repmat({param.plotcolors{1}}, 1, 2) repmat({param.plotcolors{2}}, 1, 2)])';
	markers = (repmat({'o', 'none'}, 1, 2))';
	linestyle =  (repmat({'none', '-'}, 1, 2))';
	markersize = (repmat({4, 4}, 1, 2))';
	%For thr 1
	Xdata{1,:} = X1;
	Ydata{1,:} = Y1;
	Xdata{2,:} = X;
	Ydata{2,:} = Yfit1;
	%For thr 2
	Xdata{3,:} = X2;
	Ydata{3,:} = Y2;
	Xdata{4,:} = X;
	Ydata{4,:} = Yfit2;
	
	%Draw horizontal dotted line at frequency cutoff's
	Ydata{5,:} = linspace(min([Yfit1 Yfit2]), max([Yfit1 Yfit2]), 100);
	Xdata{5,:} = repmat(min(X), 1, length(Ydata{5,:}));
	Ydata{6,:} = Ydata{5,:};
	Xdata{6,:} = repmat(max(X), 1, length(Ydata{6,:}));
	colors{end+1} = 'k';
	colors{end+1} = 'k';
	markers{end+1} = '.';
	markers{end+1} = '.';
	linestyle{end+1} = 'none';
	linestyle{end+1} = 'none';
	markersize{end+1} = 1;
	markersize{end+1} = 1;
	
	param.plotobjects{end+1} = XYPlotObject(Xdata, Ydata, ...
		'marker', markers,...
		'linestyle', linestyle,...
		'color', colors,...
		'MarkerSize', markersize);
	panel = addPlot(panel, param.plotobjects{end}, 'noredraw');
	
	if strcmpi(param.xcorrcurve, 'power')
		% transform to linear power values
		yLabel = 'Power (10.^(^Y^*^0^.^1^))';
	elseif strcmpi(param.xcorrcurve, 'amplitude')
		% using amplitude instead of power (less amplification of jitter)
		yLabel = 'Amplitude (10.^(^Y^*^0^.^0^5^))';
	else
		error('Option: xcorrcurve must be ''power'' or ''amplitude''');
	end
	
	xLabel = 'Frequency';
	title = 'Resampled Amplitude/Power Curves';
	panel = set(panel, 'title', title, 'xlabel', xLabel, 'ylabel', yLabel, ...
		'noredraw');
	
	%PLot warning if on of the CF's falls out of range
	if plotWarn
		text = '!ATTENTION: At least one of the CF values is not in the selected frequency range';
		subSeqTextBox = textBoxObject(text, ...
			'LineStyle', 'none', 'BackgroundColor', 'none');
		panel =  addTextBox(panel, subSeqTextBox, 'noredraw');
	end
	
	legendObj = legendObject('textlabels', {'ds1', '', 'ds2', ''});
	panel =  addLegend(panel, legendObj, 'noredraw');
	panel = addLegend(panel, legendObj, 'noredraw');
	
	param.plotpanel{end+1} = panel;
end


%% Xcorrelate & Normalize
% Remove nan's
[Yfit1, idx1] = denan(Yfit1);
[Yfit2, idx2] = denan(Yfit2);
Xfit1 = X(idx1);
Xfit2 = X(idx2);

% Cross-correlate THR power/amplitude curves
[c lags] = xcorr(Yfit1, Yfit2);

% normalized by auto correlation
auto1 = xcorr(Yfit1,0);
auto2 = xcorr(Yfit2,0);
normc = c/sqrt(auto1*auto2); % normalize cross correlation

% lags to delta frequencies
%X-axis identical: get increment
dF = X(2) - X(1);
%lags to frequency differences
deltaF = dF * lags;
%max correlation
[xCorrVal indc] = max(normc);
%dF (frequency difference) at max correlation
dFmax = deltaF(indc);

%% Center of gravity comparison
% Calculate the center of gravity of both power curves and take the their
% geometric and arithmetic average

% Get power curves
if strcmpi(param.xcorrcurve, 'amplitude')
	Ypower1 = Yfit1.^2;
	Ypower2 = Yfit2.^2;
else
	Ypower1 = Yfit1;
	Ypower2 = Yfit2;
end

% Get center of gravity (i.e. geometric center)
% COG = integral(Ypower * X) / integral(Ypower)
COG1 = (trapz(Xfit1, Ypower1 .*Xfit1)) / trapz(Xfit1, Ypower1);
COG2 = (trapz(Xfit2, Ypower2 .*Xfit2)) / trapz(Xfit2, Ypower2);

% Take geometric average
geoAverage = sqrt(COG1 * COG2);
% Take arithmetic average
arithAverage = (COG1 + COG2) / 2;
geoDiff = COG1 - COG2;

%Add plot of X-correlated curves
if param.plot
	clear Xdata Ydata;
	panel = Panel('nodraw');
	
	%Plot only values > 0.01
	ind = find(normc > 0.01);
	Xdata{1,:} = deltaF(ind);
	Ydata{1,:} = normc(ind);
	Xdata{2,:} = dFmax;
	Ydata{2,:} = xCorrVal;
	
	%Draw horizontal dotted line at frequency cutoff's
	Ydata{3,:} = (0:1:100)/100;
	Xdata{3,:} = zeros(1, length(Ydata{3,:}));
	
	param.plotobjects{end+1} = XYPlotObject(Xdata, Ydata, ...
		'marker', {'none', 'X', '.'},...
		'linestyle', {'-', 'none', 'none'},...
		'color', {'c', 'b', 'k'},...
		'MarkerSize', {1; 6; 1});
	panel = addPlot(panel, param.plotobjects{end}, 'noredraw');
	
	yLabel = 'Norm X-Corr';
	xLabel = 'Frequency diff';
	title = 'X-Corr';
	
	panel = set(panel, 'title', title, 'xlabel', xLabel, 'ylabel', yLabel, ...
		'noredraw');
	
	%Display convention
	if dFmax >= 0
		dConvention = 'Freq(1) > Freq(2)';
	else
		dConvention = 'Freq(1) < Freq(2)';
	end
	
	text = [ sprintf('dF_@_m_a_x = %.2f\n(%s)\nGeometric Average = %.2f\nArithmetic Average = %.2f\nDifference Centers(1)-(2) = %.2f\n\n\n\n\n', dFmax, dConvention, geoAverage, arithAverage,geoDiff)];
	subSeqTextBox = textBoxObject(text, ...
		'LineStyle', 'none', 'BackgroundColor', 'none', 'Position', 'SouthEast');
	panel =  addTextBox(panel, subSeqTextBox, 'noredraw');
	
	
	legendObj = legendObject('textlabels', {'', sprintf('X-corr = %.2f', xCorrVal) , '', ''});
	panel =  addLegend(panel, legendObj, 'noredraw');
	panel = addLegend(panel, legendObj, 'noredraw');
	
	param.plotpanel{end+1} = panel;
end


%Combine plot objects into final plot
if param.plot
	%Header 1
	header1 = HeaderObject('default', param.ds1);
	
	%Header 2
	header2 = HeaderObject('default', param.ds2);

	%Combine headers into one 
	text = [getText(header1), '|<DS1|{\bfDS2>}|', getText(header2)];
	headerP = headerPanel('text', text);
	
	%Date String 
	datestringP = dateStringPanel();
	
	%Build plotPage params
	ppParam.headerObject = headerP;
	ppParam.dateStringObject = datestringP;
	ppParam.panelObjects = [param.plotpanel{:}];
	ppParam.startPosHeader = 1;  %Start Header at first subplot position (header = entire row)

	%save in param && plotPage
	param.plothandle.fHD = plotPage(ppParam);
end

%Output params
argOut.dfmax = dFmax;
argOut.xcorr = xCorrVal;
end

%% ---------------- Local functions ------------------
function [indexa,indexb] = overlap(a,b)

% OVERLAP - Return an index of overlapping numbers
%   [IND1 IND2] = OVERLAP(A,B) - where A and B are numeric ascending vectors
%   OVERLAP returns an index IND1 into A of numbers which numerically
%   overlap in both A and B. IND2
%

% MMCL 03/11/2008

% get starting index
if min(a)>min(b) % start at min(a)
	startinda = 1;
	[~, startindb] = min(abs(b - a(1)));
elseif min(b)>min(a)  % start at min(b)
	[~, startinda] = min(abs(a - b(1)));
	startindb = 1;
elseif min(a) == min(b)
	startinda = 1;
	startindb = 1;
end

% get ending index
if max(a)>max(b) % end at max(b)
	[~, endinda] = min(abs(a - b(end)));
	endindb = length(b);
elseif max(b)>max(a)  % end at max(a)
	endinda = length(a);
	[~, endindb] = min(abs(b - a(end)));
elseif max(a) == max(b)
	endinda = length(a);
	endindb = length(b);
end

indexa = startinda:endinda;
indexb = startindb:endindb;
end

function [X1, Y1, X2, Y2] = zeroFiller_(X1, Y1, X2, Y2)
%% Determine the overlap between X1, X2 and set all Y-values outside the X-range to zero
%
% Get overlap
[ idx1, idx2 ] = overlap(X1, X2);

% Fill minimum edge
if min(X1) < min(X2)
	Y2 = [ zeros(1, idx1(1)-1), Y2 ];
	X2 = [ X1(1:idx1(1)-1), X2 ];
	idx2 = idx2 + (idx1(1)-1);
elseif min(X1) > min(X2)
	Y1 = [ zeros(1, idx2(1)-1), Y1 ];
	X1 = [ X2(1:idx2(1)-1), X1 ];
	idx1 = idx1 + (idx2(1)-1);
end

% Fill maximum edge
if max(X1) > max(X2)
	Y2 = [ Y2, zeros(1, length(X1)-idx1(end)) ];
	X2 = [ X2, X1(idx1(end)+1:end) ];
	idx2 = idx2 + length(X1)-idx1(end);
elseif max(X1) < max(X2)
	Y1 = [ Y1, zeros(1, length(X2)-idx2(end)) ];
	X1 = [ X1, X2(idx2(end)+1:end) ];
	idx1 = idx1 + length(X2)-idx2(end);
end
end