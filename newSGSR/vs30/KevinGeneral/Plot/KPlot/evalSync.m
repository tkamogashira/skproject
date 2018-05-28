function T = evalSync(ds, varargin)
% evalSync
%
% Parameters: (see source of CalcVSPH for detailed explanation)
%    anwin       : specify the analysis window, default: burstdur
%    binfreq     : specify the binning frequency, see help expandBinFreq for
%                  the possibilities
%    plot        : [yes]/no
%    logX        : yes/[no]
%    logY        : yes/[no]
%    johnson     : yes/[no], whether to plot the vectorstrength on a Johnson scale
%    isubseqs    : default all
%	 xrange      : range of indepvalues to include (leave empty for all) 
%    ireps       : default all
%    minisi      : minimum interspike interval, default 0 ms
%    timesubtr   : subtraction of a constant time from all spiketimes,
%                  default 0 ms
%    intncycles  : use an integer number of cycles for the calculation of the
%                  periodhistogram, yes/[no]
%    raycrit     : criterion for rayleigh significance, default 0.001;
%    compdelay   : compensating delay, default: 0 ms
%    phaseconv   : lead/[lag]
%    phaselinreg : if weighted regression is requested, the weight of each
%                  datapoint is determined by the synchronicity rate
%                  (= vector strength multiplied by rate),
%                  [normal]/weighted
%    runav       : number of datapoints used in smoothing the curves.
%                  Smoothing changes the extracted calculation parameters,
%                  default 0
%    cutoffthr   : default 3 dB
%    sort        : whether the output should be sorted by indepval,
%                  [yes]/no

% RdN

%% ---------------- CHANGELOG -----------------------
% 07/12/2010    Abel            Added support for RCM, MTF, RAM, RCNM, NMTF
%  Mon Jan 24 2011  Abel   
%   - bugfix:  params.binfreq transformed to row vector
%	- Z-values added to output struct
%  Fri Jan 28 2011  Abel   
%   - Added stim param to output struct
%	- Draw lin regression on vector strength phase plot 
%	- Use GetSPL(ds) for SPL;
%  Mon Feb 14 2011  Abel   
%   - make sure stim param are sorted according to indepval
%  Mon Feb 14 2011  Abel   
%  - added xrange option
%  Wed Feb 16 2011  Abel   
%  - Added support for 2Dim EDF datasets
%  Wed Jun 8 2011  Abel   
%  - Adapted to use plotPage()

%% detect 'filename - iseq' input, needed for execevalfnc in kstructplot
if nargin >= 2 && ischar(ds) && ...
        (ischar(varargin{1}) || ...
        (isnumeric(varargin{1}) && isequal(length(varargin{1}), 1)))
    ds = dataset(ds, varargin{1});
end

%% process params
% define structure of parameters: just fill with defaults
defparams.plot        = 'yes';
defparams.logX        = 'no';
defparams.logY        = 'no';
defparams.johnson     = 'no';

defparams.anwin       = 'burstdur';
defparams.binfreq     = 'auto';
defparams.isubseqs    = 'all';
defparams.xrange	  = [];
defparams.ireps       = 'all';
defparams.minisi      = 0;
defparams.timesubtr   = 0;
defparams.intncycles  = 'no';
defparams.raycrit     = 0.001;                                     
defparams.compdelay   = 0;
defparams.phaseconv   = 'lag';
defparams.phaselinreg = 'normal';
defparams.runav       = 0;
defparams.cutoffthr   = 3;
defparams.sort        = 'yes'; % This was the default behavior, we keep it this
                               % way to not break existing programs
defparams.ignoreuserdata = 0;  % by Abel: Thr/Userdata parameters
defparams.thrsequencenr = [];  % by Abel: Thr/Userdata parameters

defparams.split2dsetby = 'SPL';	% Split 2D datasets by their independent values 
								% Options: 'SPL'|'FCAR'|'FMOD'

%by Abel: Print factory
if (nargin == 1) && ischar(ds) && strcmpi(ds, 'factory')
    disp('Properties and their factory defaults:')
    disp(defparams);
    return;
end

% Parameters given as arguments are placed in the params structure.
% Other entries remain 'def'. This def value is replaced when plotting.
params = varargin;
params = processParams(params, defparams);

% Some constants
SYNC = 2;
RATE = 1;
PHASE = 3;
HIST = 4;

% by Abel: Split 2Dim datasets according to their indepedent values
if strcmp(ds.FileFormat, 'EDF')
	is2D = length(ds.EDFIndepVar) > 1;
	if is2D
		dsArray = split2ddataset(ds, 'splitby', params.split2dsetby);
		for n=1:length(dsArray)
			T(n) = evalSync(dsArray{n}, params);
		end
		return
	end
end

%by Abel: select isubsequences by indepval range
if ~isempty(params.xrange)
	params.isubseqs = find(ismember(ds.indepval, params.xrange));
	if isempty(params.isubseqs)
		error('No indepvalues found within given xrange');
	end
end

%% Calculation
vectorStrength = CalcVSPH(ds, 'anwin', params.anwin, 'binfreq', params.binfreq, ...
  'isubseqs', params.isubseqs, 'ireps', params.ireps, 'minisi', params.minisi, ...
  'timesubtr', params.timesubtr, 'intncycles', params.intncycles, ...
  'raycrit', params.raycrit, 'compdelay', params.compdelay, ...
  'phaseconv', params.phaseconv, 'phaselinreg', params.phaselinreg, ...
  'runav', params.runav, 'cutoffthr', params.cutoffthr, 'sort', params.sort);
rate = CalcRATE(ds, 'anwin', params.anwin, 'sort', params.sort, 'isubseqs', params.isubseqs);
cycleHist = CalcPRDH(ds, 'anwin', params.anwin, 'binfreq', params.binfreq);

if strcmpi(params.plot, 'yes')
    %% Create panels from new Panel objects
    panel(RATE) = ratePanel('dataset', ds, 'calcratestruct', rate,...
		'logx', params.logX, 'logy', params.logY, 'addLegend', true,...
		'Color', 'k', 'Location', 'SouthEast', 'FontSize', 8);
    panel(SYNC) = syncPanel(ds, vectorStrength, params.raycrit, params.logX, ...
        params.logY, params.johnson);
    % Phase is often negative, so no log scale on Y axis
    panel(PHASE) = phasePanel(ds, vectorStrength, params.raycrit, params.logX);
    
    % Cycle histograms: need multiple panels
    nHistPlots = length(cycleHist.hist);
    for cHistPlot = 1:nHistPlots
        panel(HIST + cHistPlot - 1) = chPanel(ds, cycleHist, cHistPlot);
        hist = cycleHist.hist(cHistPlot);
        textbox = textBoxObject(...
            sprintf('R: %f\nPh: %f\nRaySign: %f\nNSpk: %d\n IndepVal: %.2f', ...
            hist.r, hist.ph, hist.raysign, hist.nspk, ds.indepval(cHistPlot)), ...
            'LineStyle', 'none', 'BackgroundColor', 'none', ...
            'VerticalAlignment', 'top');
        panel(HIST + cHistPlot - 1) = ...
            addTextBox(panel(HIST + cHistPlot - 1), textbox, 'noredraw');
    end
    
    % Calculate rows and columns for the histplots
    % Use max 7 columns
    nHistPlotX = 7;
    nHistPlotY = ceil(nHistPlots / nHistPlotX);
    
    %% plot everything
	pageParam = [];
	pageParam.dateStringObject = dateStringPanel();
%     defaultPage(mfilename);
%     dateStringPosition = [0.1 0.1 0.001 0.001];
%     datePanel = Panel('position', dateStringPosition, 'axes', false, ...
%         'nodraw');
%     textbox = textBoxObject([' ' datestr(now) ' '], 'Rotation', 90, ...
%         'Margin', 0.1, 'FontSize', 8, 'LineStyle', 'none', ...
%         'BackgroundColor', 'none');
%     addTextBox(datePanel, textbox);
	pageParam.headerObject = headerPanel('dataset', ds);
    
%     subplot(nHistPlotY + 2, nHistPlotX, 1:7);
%     headerPosition = [ 0.13  0.9  1  0.001 ];
%     header = HeaderObject('default', ds);
%     headerPanel = Panel('position', headerPosition, 'axes', false, 'nodraw');
% 	headerP = headerPanel('dataset', ds);
%     addTextBox(headerP, header);
%     redraw(headerP);
%     subplot(nHistPlotY + 2, nHistPlotX, 8);
%     textPanel = getTextPanel(vectorStrength);
%     redraw(textPanel);

	%Matlab strangeness: 
	% putting pageParam.panelObjects(4) = getTextPanel(vectorStrength);
	% first redraws the panel? 
	pageParam.panelObjects(1) = panel(SYNC);
	pageParam.panelObjects(2) = panel(RATE);
	pageParam.panelObjects(3) = panel(PHASE);
	pageParam.panelObjects(4) = getTextPanel(vectorStrength);  
		
	
    
%     for cPanel = [SYNC RATE PHASE]
%         positions = [cPanel*2 - 1, cPanel*2] + 8;
%         subplot(nHistPlotY + 2, nHistPlotX, positions);
%         panel(cPanel) = redraw( panel(cPanel) );
%     end
    
%     for cPanel=1:nHistPlots
	for cPanel = 1:nHistPlots
%         subplot(nHistPlotY + 2, nHistPlotX, nHistPlotX + cPanel + 7);
%         panel(cPanel + HIST - 1) = redraw( panel(cPanel + HIST - 1) );
		pageParam.panelObjects(4+cPanel) =  panel(cPanel + HIST - 1);
	end
	plotPage(pageParam);
end

%% output struct
T.ds.filename = ds.filename;
T.ds.icell = ds.icell;
T.ds.iseq = ds.iseq;
T.ds.seqid = ds.seqid;
T.tag = 0;
T.createdby = mfilename;
T.curve       = vectorStrength.curve;
T.params      = vectorStrength.param;
T.dsinfo      = vectorStrength.dsinfo;
T.calcfunc    = vectorStrength.calcfunc;
T.rate        = rate.curve;

%By Abel: Calculate CF and format THR title string
T.thr = getThr4Cell(ds.Filename, ds.icell, params.ignoreuserdata, params.thrsequencenr);

%By Abel: Add stimulus info
%data may be sorted, which is reflected in the order of isubsequence.
idx = vectorStrength.param.isubseqs;

stimParam.spl = sortByIdx_(GetSPL(ds), idx);
stimParam.spl = stimParam.spl(:).';
stimParam.fcar = sortByIdx_(ds.fcar, idx);
stimParam.fmod = sortByIdx_(ds.fmod, idx);
stimParam.fmod = stimParam.fmod(:).';
stimParam.repdur = sortByIdx_(ds.repdur, idx);
stimParam.burstdur = sortByIdx_(ds.burstdur, idx);
stimParam.nrep = sortByIdx_(ds.nrep, idx);

T.stim = stimParam;

function panel = getTextPanel(vectorStrength)
calcParamTxt{1} = ...
	sprintf('\n'); %Do a blank line to layout reasons
calcParamTxt{end+1} = ...
    sprintf('\\itReps:\\rm %s', range2Str(vectorStrength.param.ireps{1}));
calcParamTxt{end+1} = ...
    sprintf('\\itAnWin:\\rm %s', win2Str([vectorStrength.param.anwin]));
calcParamTxt{end+1} = sprintf('\\itMinISI:\\rm %s', ...
    sprintf('%.2f ms', vectorStrength.param.minisi));
calcParamTxt{end+1} = sprintf('\\itConSub:\\rm %s', sprintf('%.2f ms', 0));
calcParamTxt{end+1} = ...
    sprintf('\\itBinFreq:\\rm %s', freq2Str(vectorStrength.param.binfreq));
calcParamTxt{end+1} = ...
    sprintf('\\itIntNCycles:\\rm %s', vectorStrength.param.intncycles);
calcParamTxt{end+1} = ...
    sprintf('\\itRayCrit:\\rm %s', sprintf('%.3f', vectorStrength.param.raycrit));
calcParamTxt{end+1} = ...
    sprintf('\\itPhaseConv:\\rm %s', vectorStrength.param.phaseconv);
calcParamTxt{end+1} = ...
    sprintf('\\itCompDelay:\\rm %d ms', vectorStrength.param.compdelay);
calcParamTxt{end+1} = sprintf('\\itRunAv:\\rm %d #', vectorStrength.param.runav);
calcParamTxt{end+1} = ...
    sprintf('\\itCutOffThr:\\rm %d dB', vectorStrength.param.cutoffthr);
calcParamTextBox = ...
    textBoxObject(calcParamTxt', 'Position', 'SouthEast', 'LineStyle', 'none', ...
    'BackgroundColor', 'none', 'VerticalAlignment', 'bottom');

panel = addTextBox(Panel('axes', false, 'nodraw'), calcParamTextBox, 'noredraw');

function sortedValues = sortByIdx_(values, idx)
if length(values) == 1
	sortedValues = values;
	return
end
sortedValues = values(idx);


	
	