function [ArgOut, OldForm] = EvalSAC(varargin)
%EVALSAC  calculate the SAC and the DFT of the SAC.
%   T = EVALSAC(ds) calculates the SAC and DFT for all subsequences.
%   E.g.:
%           ds = dataset('A0242', '8-2');
%           T = EvalSACXAC(ds);
% 
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%Ramses de Norre

%% ---------------- CHANGELOG ----------------
%  Thu Jan 13 2011  Abel    - Increased spkrate by factor 1000
%							- Updated userdata try/catch block
%  Mon Jan 17 2011  Abel    
%	- Output in single vectors instead of repetitions. Old format is still
%	given as second output option (for now).
%	
%  Tue Jan 18 2011  Abel   
%   - Added option to skip THR info gathering (for fake datasets)
%
%  Fri Jan 28 2011  Abel   
%   - Added sorted indepval column to output struct
%
%  Tue Feb 8 2011  Abel   
%   - Added NOT normalised sac (nonorm.max(n))
%	- Added "coincidence rate (CR)" = Same as DriesNorm (CI) but not
%	normalised by square of the rate. (ac.cr(n))
%	Name changes in output:
%		ac.max -> ac.ci
%		ds.spkrate -> ac.spkrate
%		ds.nspike -> ac.nspike
%%

%% -----------------------------------template-----------------------------
Template.ds.filename     = '';        %Datafile name for datasets
Template.ds.icell        = NaN;       %Cell number of datasets
Template.ds.iseq         = NaN;       %Sequence number of first dataset
Template.ds.seqid        = '';        %Identifier of first dataset
Template.ds.isubseq      = NaN;       %Subsequence number of spiketrain used for first dataset

%Template.ds.nspike      = NaN;
%Template.ds.spkrate      = NaN;
Template.ac.nspike      = NaN;
Template.ac.spkrate      = NaN;

Template.tag             = 0;         %General purpose tag field
Template.createdby       = mfilename; %Name of MATLAB function that generated the data
Template.stim.burstdur   = NaN;       %Stimulus duration in ms
Template.stim.repdur     = NaN;       %Repetition duration in ms
Template.stim.nrep       = NaN;       %Number of repetitions
Template.stim.spl        = NaN;       %Sound pressure level in dB

% Template.ac.max          = NaN;       
Template.ac.ci		 = NaN;	      %Maximum of shuffled autocorrelogram (DriesNorm: Correlation Index)
Template.ac.cr		 = NaN;		  %Maximum of shuffled autocorrelogram (Coincidence Rate)
Template.ac.nonorm.max   = NaN;		  %Maximum of shuffled autocorrelogram (No normalisation)

Template.ac.saczero      = NaN;       %Value at delay zero of shuffled autocorrelogram (DriesNorm)
Template.ac.peakratio    = NaN;       %Ratio of secundary versus primary peak in autocorrelogram
Template.ac.hhw          = NaN;       %Half height width on autocorrelogram (ms)
Template.ac.fft.df       = NaN;       %Dominant frequency in autocorrelogram (Hz)
Template.ac.fft.bw       = NaN;       %Bandwidth (Hz)
Template.thr.cf          = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr.sr          = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr.thr         = NaN;       %Threshold at characteristic frequency
Template.thr.q10         = NaN;       %Q10 retrieved from threshold curve
Template.thr.bw          = NaN;       %Width 10dB above threshold (Hz)
Template.rcn.thr         = NaN;       %Noise threshold (dB) derived from NSPL curve ...

%% -------------------------------default parameters-----------------------
%Calculation parameters ...
DefParam.anwin         = [0 +Inf];   %in ms (Inf designates stimulus duration)
DefParam.corbinwidth   = 0.05;       %in ms ...
DefParam.cormaxlag     = 15;         %in ms ...
DefParam.acfftrunav    = 1000;       %in Hz ...
DefParam.acfftcutoff   = 5000;       %in Hz
DefParam.calcdf        = NaN;        %in Hz, NaN (automatic), 'cf' or 'df' ...
%Plot parameters ...
DefParam.plot          = 'yes';      %'yes' or 'no' ...
DefParam.fftyunit      = 'dB';       %'dB' or 'P' ...
DefParam.ismashed      = false;      % Whether the dataset is mashed.
DefParam.ignorethr     = false;      % Don't look up any THR info. This option is needed for fake datasets (example: output of MergeDS)


%% main program
% Evaluate input arguments ...
if (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'factory')
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
else
    [ds, Spt, Info, StimParam, Param] = ...
        EvalSacParseArgs(DefParam, varargin{:}); 
end

% Retrieving data from SGSR server ...(Ignore for fake datasets)
[Thr, Rcn] = getUserData(Info, Param.ignorethr);

% Calculate data
for n = 1:ds.nsub
    CalcData(n) = CalcDifCor(Spt(n, :), Thr, Rcn, Info, Param, StimParam(n));
    CalcData(n).ds.isubseq = n;
end

if isequal(Param.plot,'yes')
    PlotDifCor(CalcData, ds, Param);
end

% Return output if requested ...
if (nargout > 0)

	%Old format for testing
	for n = 1:ds.nsub
        teststruct(n) = structtemplate(structcat(CalcData(n), ...
            struct('stim', StimParam(n))), Template);
	end
	OldForm = teststruct;
	
	%%%%by Abel: Output as vectors
	% Initially construct ArgOut from template and populate 
	ArgOut = structtemplate(structcat(CalcData(1), struct('stim', StimParam(1))), ...
		Template);
	
	% Loop over changing properties to create vectors 
	% - Get subsequences, sorted according to ds.indepval
	iSubSeqs = 1:ds.nsub;
	[IndepVal, idx] = sort(ds.indepval); 
	iSubSeqs = iSubSeqs(idx);
	% - Start loop over sorted subs
	for n = 1:length(iSubSeqs)
		iSub = iSubSeqs(n);
		% Changing variables for RCN datasets		
		ArgOut.ds.isubseq(n) = CalcData(iSub).ds.isubseq;
		ArgOut.stim.spl(n) = StimParam(iSub).spl;
		ArgOut.ac.spkrate(n) = CalcData(iSub).ac.spkrate;
		ArgOut.ac.nspike(n) = CalcData(iSub).ac.nspike;
		ArgOut.ac.ci(n) = CalcData(iSub).ac.ci;
		ArgOut.ac.saczero(n) = CalcData(iSub).ac.saczero;
		ArgOut.ac.peakratio(n) = CalcData(iSub).ac.peakratio;
		ArgOut.ac.hhw(n) = CalcData(iSub).ac.hhw;
		ArgOut.ac.fft.df(n) = CalcData(iSub).ac.fft.df;
		ArgOut.ac.fft.bw(n) = CalcData(iSub).ac.fft.bw;	
		ArgOut.indepval = IndepVal(:).';
		
		%Not normalised
		ArgOut.ac.nonorm.max(n) = CalcData(iSub).ac.nonorm.max;
		
		%Coincidence rate
		ArgOut.ac.cr(n) = CalcData(iSub).ac.cr;
	end
end

%% getUserData
function [Thr, Rcn] = getUserData(Info, ignore)

%return NaN if we need to ignore thr info
if ignore
	Rcn = struct([]);
	[CF, SR, Thr, BW, Q10, Str] = deal(NaN);
	Thr = lowerFields(CollectInStruct(CF, SR, Thr, BW, Q10, Str));
	return;
end
%by Abel:
%Try/catch block for retieving THRseq number from the userdata server
%If nothing was found, go on with the default number provided by
%getTHRSeq(). See getThr4Cell() for inspiration. In this case we can't use
%this function directly since we need additional data from the userdata
%server.
 try
	UD = getuserdata(Info(1).ds.filename, Info(1).ds.icell);
	if isempty(UD)
		error('No information found in DataBase');
	end
	
	%%% Threshold curve information
	% - If a THRSeq was found in userdata, use this one. Otherwise use the
	% default from getTHRSeq()
	if ~isempty(UD.CellInfo) && ~isempty(UD.CellInfo.THRSeq) && ~isnan(UD.CellInfo.THRSeq),
		SeqNr = UD.CellInfo.THRSeq;
	else
		SeqNr = getTHRSeq(Info(1).ds.filename, Info(1).ds.icell);
		warning('SGSR:Info','Additional THR USERDATA information was not included.');
	end
	
	%%% Rate curve information ...
	% This is a value which is only present in the userdata DB
	if isfield(UD.CellInfo, 'RCNTHR')
		Rcn.thr = UD.CellInfo.RCNTHR;
		s = sprintf('Intensity curve:');
		s = char(s, sprintf('THR = %s', EvalSacParam2Str(UD.CellInfo.RCNTHR, ...
			'dB', 0)));
		Rcn.str = s;
	else
		Rcn = struct([]);
		warning('SGSR:Info','Additional USERDATA RCNTHR information was not included.');
	end
	
 catch exception
	warning('SGSR:Info','Additional USERDATA information was not included.');

	%%% Threshold curve information
	SeqNr = getTHRSeq(Info(1).ds.filename, Info(1).ds.icell);
	
	%%% Rate curve information ...
	Rcn = struct([]);
 end

%%% Threshold curve information
% - If no THR found, set all to NaN.
if isempty(SeqNr) || isnan(SeqNr)
	[CF, SR, Thr, BW, Q10, Str] = deal(NaN);
else
% - If THR found, extract params and provide output string.
	dsTHR = dataset(Info(1).ds.filename, SeqNr);
	[CF, SR, Thr, BW, Q10] = EvalTHR(dsTHR, 'plot', 'no');
	s = sprintf('Threshold curve:');
	s = char(s, sprintf('%s <%s>', dsTHR.FileName, dsTHR.seqID));
	s = char(s, sprintf('CF = %s @ %s', EvalSacParam2Str(CF, 'Hz', 0), ...
		EvalSacParam2Str(Thr, 'dB', 0)));
	s = char(s, sprintf('SR = %s', EvalSacParam2Str(SR, 'spk/sec', 1)));
	s = char(s, sprintf('BW = %s', EvalSacParam2Str(BW, 'Hz', 1)));
	s = char(s, sprintf('Q10 = %s', EvalSacParam2Str(Q10, '', 1)));
	Str = s;
end
Thr = lowerFields(CollectInStruct(CF, SR, Thr, BW, Q10, Str));

%% CalcData
function CalcData = CalcDifCor(Spt, Thr, Rcn, Info, Param, StimParam)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...

%Correlation of noise token responses of a cell with the responses of that same
%cell to that same noise token. The spiketrains are derived from the same cell
%so this is called a Shuffled AutoCorrelogram (or SAC).
[Ysac, T, NC] = SPTCORR(anwin(Spt, Param.anwin), 'nodiag', ...
    Param.cormaxlag, Param.corbinwidth, WinDur);
spkrate = NC.Rate1;
nspike = NC.Nspike1;

%by Abel: save not normalised
CalcData.ac.nonorm.co = Ysac;
CalcData.ac.nonorm.max = max(Ysac);

%by Abel: "coincidence rate" = same as normalised to Driesnorm (correlation
%index)(see SPTCORR()) but no normalised for average rate (square rate)
NRep = StimParam.nrep;
CalcData.ac.cr = (1000*Ysac)/((NRep*(NRep-1))*WinDur);
CalcData.ac.cr = max(CalcData.ac.cr);

%Apply Driesnorm
Ysac = ApplyNorm(Ysac, NC);

%Performing spectrum analysis on the SAC. Because an autocorrelogram has a DC
%component this is removed first ...
FFTsac = spectana(T, detrend(Ysac, 'constant'), 'RunAvUnit', 'Hz', ...
    'RunAvRange', Param.acfftrunav);
%The magnitude spectrum of a correlogram function is actually a power spectrum,
%therefore all magnitude units need to be changed ...
FFTsac.Magn.P  = FFTsac.Magn.A;
FFTsac.Magn.A  = sqrt(FFTsac.Magn.A);
FFTsac.Magn.dB = FFTsac.Magn.dB/2;

%Determine which dominant frequency to be used in the calculation ...
if ~isempty(Thr)
    DomFreq = DetermineCalcDF(Param.calcdf, Thr.cf, NaN, FFTsac.DF);
else
    DomFreq = DetermineCalcDF(Param.calcdf, NaN, NaN, FFTsac.DF);
end

if (DomFreq ~= 0)
    DomPer = 1000/DomFreq; 
else
    DomPer = NaN; 
end %Dominant period in ms ...

%Calculating the ratio of the secondary over the primary peak for the SAC and
%the half height width on the peak (relative to asymptote one)...
HalfMaxSac = ((max(Ysac)-1)/2)+1;
SacHHWx = cintersect(T, Ysac, HalfMaxSac);
SacHHW = abs(diff(SacHHWx));
[SacPeakRatio, SacXPeaks, SacYPeaks] = getpeakratio(T, Ysac, DomFreq);

%Reorganizing calculated data ...
CalcData.delay         = T;
CalcData.ac.normco     = Ysac;
CalcData.ac.saczero    = Ysac(T == 0);
CalcData.ac.ci		   = max(Ysac);
CalcData.ac.peakratio  = SacPeakRatio;
CalcData.ac.peakratiox = SacXPeaks;
CalcData.ac.peakratioy = SacYPeaks;
CalcData.ac.hhw        = SacHHW;
CalcData.ac.hhwx       = SacHHWx;
CalcData.ac.halfmax    = HalfMaxSac;
CalcData.ac.fft.freq   = FFTsac.Freq;
CalcData.ac.fft.p      = FFTsac.Magn.P;   
CalcData.ac.fft.db     = FFTsac.Magn.dB;
CalcData.ac.fft.df     = FFTsac.DF;
CalcData.ac.fft.bw     = FFTsac.BW;
CalcData.ds            = Info.ds;
CalcData.thr           = Thr;
CalcData.rcn           = Rcn;
%by Abel: increase spkrate by *1000 
CalcData.ac.spkrate    = spkrate * 1000;
CalcData.ac.nspike     = nspike;

%% ApplyNorm
function Y = ApplyNorm(Y, N)
if ~all(Y == 0)
    Y = Y/N.DriesNorm;
else
    Y = ones(size(Y));
end

%% DetermineCalcDF
function DF = DetermineCalcDF(ParamCalcDF, ThrCF, DifDF, SacDF)

if isnumeric(ParamCalcDF)
    if ~isnan(ParamCalcDF)
        DF = ParamCalcDF;
    elseif ~isnan(DifDF)
        DF = DifDF;
    elseif ~isnan(SacDF)
        DF = SacDF;
    else
        DF = ThrCF;
    end
elseif strcmpi(ParamCalcDF, 'cf')
    DF = ThrCF;
elseif strcmpi(ParamCalcDF, 'df')
    if ~isnan(DifDF)
        DF = DifDF;
    else
        DF = SacDF;
    end
else
    DF = NaN;
end

%% PlotDifCor
function PlotDifCor(CalcData, ds, Param)

% Get X and Y data and convert to cell arrays
Xsac = {CalcData.delay};
Ysac = [CalcData.ac];
Ysac = {Ysac.normco};

Xdft = [CalcData.ac];
Xdft = [Xdft.fft];
Xdft = {Xdft.freq};
Ydft = [CalcData.ac];
Ydft = [Ydft.fft];
if strcmpi(Param.fftyunit, 'dB')
    Ydft = {Ydft.db};
    YLblStr = 'Power (dB, {}^{10}log)'; 
else
    Ydft = {Ydft.p};
    YLblStr = 'Power';
end
Ydft = cellfun(@(x)x(2,:), Ydft, 'UniformOutput', false);

GridPlot(Xsac, Ysac, ds, 'xlabel', 'Delay (ms)', ...
    'ylabel', sprintf('Norm. Count'), 'mfileName', mfilename, ...
    'plotTypeHdl', @XYPlotObject, ...
    'plotParams', {'Marker', 'none', 'LineStyle', '-'});

% Cutoff the fft
Xdft = cellfun(@(x) x(x<=Param.acfftcutoff), Xdft, 'UniformOutput',false);
cutoffs = cellfun(@(x) length(x), Xdft, 'UniformOutput',false);
Ydft = cellfun(@(y, cutoff) y(1:cutoff), Ydft, cutoffs, 'UniformOutput', false);

GridPlot(Xdft, Ydft, ds, 'xlabel', {'Freq (Hz)'}, 'ylabel', {YLblStr}, ...
    'mfileName', mfilename, 'plotTypeHdl', @XYPlotObject, ...
    'plotParams', {'Marker', 'none', 'LineStyle', '-'});
