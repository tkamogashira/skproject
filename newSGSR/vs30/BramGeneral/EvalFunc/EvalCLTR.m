function [S, Param] = EvalCLTR(varargin)
%EVALCLTR   evaluate dataset with click train responses
%
%
% DESCRIPTION
%                           Evaluate dataset with click train responses 
%                            
%                            
% INPUT
%        varargin:          First parameter should be a dataset of type EDF, followed by a struct or array list of type ['parameter', 'value'] containing function options. 
%                           varargin = ['factory'] || '',  prints the default settings for this function.
%        varargin(1):       dataset object
%        varargin(2:end)    Struct or parameter list containing options:                   
%                           'isubseqs'              select subsequences        'all' or numerical vector ...
%                           'subseq'                select subsequence input   'indepval' or 'subseq' ...
%                           'ratecor'               correction for frequency (Needed for Madison data) 'yes' or 'no'
%                           'psthanwin'             select analysis window                            
%                           'prdhnbin'              select binning frequency   'burstdur' or two-element numerical vector
%                           'plot'                  plot output                'yes'/'no'
%                           'maxnticks'             select maximum amount of tics (15 default)
%                           'repetitionrange'       select repetitions to
%                                                   analyse
%                           'ignoreuserdata'        Connect to userdata to select the THR sequence number                            
%                           'thrsequencenr'         To manually specify the thr sequence number to calculate CF
%							'maxrayleigh' 			Rayleigh criterion used
%													for calculation of
%													R-max values	
%							'xrange'				range of indepvalues to include (leave empty for all) 
%
% OUTPUT
%        datasetobj:        Translated dataset object
%        Param:             Struct containing input parameters in struct form, along with altered values.
%
%
% EXAMPLES
%        ds = dataset('S0425', '4-8')
%        newdataset = ds2edf(ds)
%
% SEE ALSO          EDFdataset dataset      ds2edf dsextract
%                                           
%B. Van de Sande 15-06-2004

%% ---------------- CHANGELOG ----------------
% 30/11/2010    Abel   Extended to Leuven datasets + bugfixes
% 06/12/2010    Abel   Added documentation + option to limit the number of
%                      repetitions
% 08/12/2010    Abel   Bugfix: ds.indepval can have NaN's which need to be
%                      eliminated in EffRepRate.
%                      Bugfix: S.Vs.SPLmax with only one SPL value
% 22/12/2010    Abel   Added stand dev to the output struct and updated
%                      code for THR/CF calculation
% 18/01/2011	Abel   Adapted to new syntax getThr4Cell
% 19/01/2011	Abel   Code cleanup
% 20/01/2011    Abel   Updated CheckDS
%						- no need for ds2edf
%					   Updated GetStimParam
%						- native support for leuven data
%					   Param2Str now separate function
%					   Include calculation of the values for the subsequence showing the maximum,
%					   significant( corrected by Rayleigh test) R value.
% 21/01/2011    Abel	- Added analysis windows to output struct   
%						- Added script params as second output
%						- Added graphical representation of Param.prdhanwin
%						- S.Vs.raysignmax renamed to S.Vs.raycrit and shows Param.maxrayleigh;
%  Mon Jan 24 2011  Abel   
%   Fix for colum/row difference in ds.spl and ds.indepvar between EDF and
%   IDF/SPK datasets
%  Mon Feb 14 2011  Abel   
%   Added xrange option


%% --------------------------------default parameters------------------------------
%Calculation parameters ... 
DefParam.isubseqs     = 'all';       %'all' or numerical vector ...
DefParam.xrange       = [];          %range of indepvals to include ...
DefParam.subseqinput  = 'indepval';  %'indepval' or 'subseq' ...
DefParam.ratecor      = 'yes';       %'yes' or 'no' ...
DefParam.psthanwin    = 'burstdur';  %'burstdur' or two-element numerical vector ...
DefParam.psthnbin     = 500;         %in # ...
DefParam.prdhanwin    = 'burstdur';  %'burstdur' or two-element numerical vector ...
DefParam.prdhnbin     = 250;         %in # ...
%Plot parameters ...
DefParam.plot         = 'yes';       %'yes' or 'no' ...
DefParam.maxnticks    = 15;
DefParam.bf           = 0;
DefParam.repetitionrange = [];
%Thr/Userdata parameters
DefParam.ignoreuserdata = 0;
DefParam.thrsequencenr = [];
DefParam.maxrayleigh = 0.001;
%Plot graphical parameters
DefParam.plotsettings = struct();
DefParam.plotsettings.drawprdhanwin = 0;
DefParam.plotsettings.prdhanwin = struct(				...
	'FaceColor',		[0.9 0.9 0.9],					...
	'EdgeColor',		[0 0 0],						...
	'LineStyle',		'-',							...
	'LineWidth',		0.5,							...							
	'Marker',			'none'							...
	);

%% -----------------------------------main program---------------------------------
%Evaluate input arguments ...
if (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'factory')
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
else
    [Spt, IndepVal, Param, DSParam, StimParam] = ParseArgs(DefParam, varargin{:}); 
end

%Retrieving THR information
Thr = getThr4Cell(DSParam.datafile, DSParam.cellnr, Param.ignoreuserdata, Param.thrsequencenr);
            
%Perform actual calculations ...
NPlots = length(IndepVal);
for n = 1:NPlots
    CalcData(n) = CalcCurves(Spt(n, :), Param, StimParam(n)); 
end    

S.RowIdx            = n;
S.Ds.filename       = DSParam.datafile;
S.Ds.icell          = DSParam.cellnr;
S.Ds.iseq           = DSParam.iseq;
S.Ds.seqid          = DSParam.seqid;
S.Class             = 'z';
S.Morph             = 'z';
S.Param.repdur      = StimParam(1).repdur;
S.Param.burstdur    = StimParam(1).burstdur;
S.Param.nrep        = StimParam(1).nrep;

S.Param.psthanwin	= Param.psthanwin;		%Analysis windows
S.Param.prdhanwin	= Param.prdhanwin;

S.Param.spl         = deNaN(DSParam.spl);	%Sorting as in dataset
S.Param.indepval	= IndepVal;				%Sorted indep values 

S.Tag               = 0;
S.CreatedBy         = mfilename;

%by Abel for Leuven data of stimtype CFS, the binfrequency is set to the
%repetition frequency and since the frequency in now indepvar, the S.Vs.bf
%field should be updated for each plot
for n = 1:NPlots
    if ~isequal(0, Param.bf)
        S.Vs.bf(n)         = Param.bf;
    elseif strcmpi(Param.ratecor, 'yes')
        S.Vs.bf(n)         = StimParam(n).effreprate;
    else
        S.Vs.bf(n)         = StimParam(n).reqreprate;
    end
end


for n = 1:NPlots
    S.Vs.r(n)       = CalcData(n).prdh.hist.r;
    S.Vs.ph(n)      = CalcData(n).prdh.hist.ph;
    S.Vs.raysign(n) = CalcData(n).prdh.hist.raysign;
    S.Vs.nspk(n)    = CalcData(n).prdh.hist.nspk;
end
S.Vs.sdc            = NaN;
S.Vs.sdt            = NaN;

%By Abel: Calculate the values for the subsequence showing the maximum,
%significant( corrected by Rayleigh test) R value. First calculate Max
%R-value -> SPLmax, phmax, nspkmax, raysignmax are the values for the
%subsequence corresponding to the Indepval showing this Max R-value.
idx = S.Vs.raysign <= Param.maxrayleigh;		%logical index for values within criterion
[S.Vs.rmax]      = max(S.Vs.r(idx));			%their max value
i = find(S.Vs.r == S.Vs.rmax);					%index of the max value within the original set

%Calculate Z-values 
N = cat(1, S.Vs.nspk);
R = cat(1, S.Vs.r);
S.Vs.Z    = N .* (R .^2);


%by Abel bugfix: When CFS data, clicktrain freq is varied while SPL is
%fixed. Spl has only 2 values which are idential.
%S.Vs.SPLmax         = S.Param.spl(i);
if ( length(unique(S.Param.spl)) == 1 )
    %SPL is not indepvar unless only 1 subsequence was measured
    S.Vs.SPLmax = S.Param.spl(1);
else
    S.Vs.SPLmax = S.Param.spl(i);
end

S.Vs.phmax          = S.Vs.ph(i);
S.Vs.nspkmax        = S.Vs.nspk(i);
S.Vs.raycrit		= Param.maxrayleigh;

if ~isempty(Thr)
    S.Thr           = rmfield(Thr, 'str');
else
    S.Thr.cf        = NaN;
    S.Thr.sr        = NaN;
    S.Thr.thr       = NaN;
    S.Thr.bw        = NaN;
    S.Thr.q10       = NaN;
end

%by Abel, increase Java mem for large amounts of plots
if (NPlots > 10)
    warning('SGSR:Info', 'Your are trying to display 10 plots or more, if you receive a Java heap space memory error, increase the Java memory: http://www.mathworks.com/support/solutions/en/data/1-18I2C/');
end

%Display data if requested ...
if strcmpi(Param.plot, 'yes')
    for n = 1:NPlots
        PlotCurves(CalcData(n), Thr, DSParam, StimParam(n), Param, S, n); 
    end
else
    %By Abel: calculate standard dev. even if we are not plotting
    for n = 1:NPlots
        % standard deviation of a cyclic histogram: just move it to the center and
        % then calculate std
        xData = CalcData(n).prdh.hist.bincenters + 0.5 - S.Vs.ph(n);
        for cX = 1:length(xData)
            if xData(cX) < 0
                xData(cX) = xData(cX) + 1;
            elseif xData(cX) > 1
                xData(cX) = xData(cX) - 1;
            end
        end
        yData = CalcData(n).prdh.hist.rate;
        stdCyc = histStd(xData, yData);
        stdTime = 1000*stdCyc/StimParam(n).effreprate;
        S.Vs.sdc(n) = stdCyc;
        S.Vs.sdt(n) = stdTime;
    end
end

%% ----------------------------------local functions-------------------------------
function [Spt, IndepVal, Param, DSParam, StimParam] = ParseArgs(DefParam, varargin)

%Check dataset and extract general information...
ds = varargin{1};
if ~isa(ds, 'dataset')
    error('First argument should be dataset.'); 
else
    [ds, DefParam] = CheckDS(ds, DefParam); 
end

%Retrieving properties and checking their values ...
Param = checkproplist(DefParam, varargin{2:end});
CheckParam(Param);

%by Abel, select repetitions if needed
if ~isempty(Param.repetitionrange)
    warning('SGSR:Info',...
        'Extracting repetitionrange from dataset');
    ds = dsextract(ds, 'repetitionrange', Param.repetitionrange );
end

%Disassemble dataset ...
%Extract general information ...
DSParam = GetDSParam(ds);

%Extract spiketimes ...
%by abel: add xrange (=select range of indepvals) option for clarity
if ~isempty(Param.xrange)
	iSubSeqs = find(ismember(ds.indepval, Param.xrange));
	if isempty(iSubSeqs)
		error('No indepvalues found within given xrange');
	end
end

Nrec = ds.nrec;
if strcmpi(Param.isubseqs, 'all')
    iSubSeqs = 1:Nrec;
elseif strcmpi(Param.subseqinput, 'indepval')
    iSubSeqs = find(ismember(ds.indepval, Param.isubseqs));
    if length(iSubSeqs) < length(Param.isubseqs)
        error('One of the requested subsequences doesn''t exist or wasn''t recorded.');
    end        
else
    if ~all(ismember(1:Nrec, Param.isubseqs))
        error('One of the requested subsequences doesn''t exist or wasn''t recorded.');
    else
        iSubSeqs = Param.isubseqs; 
    end
end    
[IndepVal, idx] = sort(ds.indepval(iSubSeqs)); 
IndepVal = IndepVal(:).';			% v=v(:); % <- always a COL vec
iSubSeqs = iSubSeqs(idx);			% v=v(:).'; % <- always a ROW vec... note: proper transpose .'
Spt = ds.spt(iSubSeqs, :);


%Extract stimulus parameters ...
StimParam = GetStimParam(ds, IndepVal, Param);

%Expand parameter shortcuts ...
if strcmpi(Param.psthanwin, 'burstdur')
    Param.psthanwin = [0 min([StimParam.burstdur])]; 
end
if strcmpi(Param.prdhanwin, 'burstdur')
    Param.prdhanwin = [0 min([StimParam.burstdur])];
else
	%By Abel: Draw analysis window when it's not the total burstduration
	Param.plotsettings.drawprdhanwin = 1;
end

%Format parameter information ...
Str = {sprintf('\\rm\\itAnWin(PSTH):\\rm %s', Param2Str(Param.psthanwin, 'ms', 0)); ...
        sprintf('\\itNBin(PSTH):\\rm %s', Param2Str(Param.psthnbin, '', 0)); ...
        sprintf('\\itAnWin(PRDH):\\rm %s', Param2Str(Param.prdhanwin, 'ms', 0)); ...
        sprintf('\\itNBin(PRDH):\\rm %s', Param2Str(Param.prdhnbin, '', 0)); ...
        sprintf('\\itRateCor:\\rm %s', upper(Param.ratecor))};
Param.str = Str;

%--------------------------------------------------------------------------------
function [dataSet, DefParam] = CheckDS(ds, DefParam)
isLeuvenData = ~strcmpi(ds.FileFormat, 'EDF');
if isLeuvenData
	DefParam.inleuven = 1;		
	DefParam.ratecor  = 'no';	%Skip repetition rate correction (not needed for Leuven Data)
else
    DefParam.inleuven = 0;
end
dataSet = ds;

%--------------------------------------------------------------------------------
function CheckParam(Param)

if (~isnumeric(Param.isubseqs) || (ndims(Param.isubseqs) ~= 2) || ~any(size(Param.isubseqs == 1))) && ...
        ~strcmpi(Param.isubseqs, 'all')
    error('Invalid value for property isubseqs.'); 
end
if ~any(strcmpi(Param.subseqinput, {'indepval', 'subseq'}))
    error('Property subseqinput must be ''indepval'' or ''subseq''.'); 
end
if ~any(strcmpi(Param.ratecor, {'yes', 'no'}))
    error('Property ratecor must be ''yes'' or ''no''.'); 
end
if (~isnumeric(Param.psthanwin) || ~isinrange(Param.psthanwin, [0, +Inf])) && ~strcmpi(Param.psthanwin, 'burstdur')
    error('Invalid value for property psthanwin.'); 
end    
if (~isnumeric(Param.prdhanwin) || ~isinrange(Param.prdhanwin, [0, +Inf])) && ~strcmpi(Param.prdhanwin, 'burstdur')
    error('Invalid value for property prdhanwin.'); 
end    
if ~isnumeric(Param.psthnbin) || (length(Param.psthnbin) ~= 1) || (Param.psthnbin <= 0)
    error('Invalid value for property nbin.'); 
end    
if ~isnumeric(Param.prdhnbin) || (length(Param.prdhnbin) ~= 1) || (Param.prdhnbin <= 0)
    error('Invalid value for property nbin.'); 
end    

if ~any(strcmpi(Param.plot, {'yes', 'no'}))
    error('Property plot must be ''yes'' or ''no''.'); 
end
if ~isnumeric(Param.maxnticks) || (length(Param.maxnticks) ~= 1) || (Param.maxnticks <= 0)
    error('Invalid value for property maxnticks.'); 
end 
%By Abel, extra test for 'repetitionrange'
if ~isnumeric(Param.repetitionrange)
    error('Invalid value for property repetitionrange');
end

%--------------------------------------------------------------------------------
function DSParam = GetDSParam(ds)

DSParam.datafile = upper(ds.filename);
DSParam.cellnr   = ds.icell;
[~, DSParam.testnr, DSParam.dsid] = unraveldsID(ds.SeqID);
DSParam.seqid = ds.SeqID;
DSParam.iseq = ds.iSeq;

%by Abel: for Madison data (EDF), only intensity could be varied while
%leuven data may have intensity as IndepVar => SPL "sound pressure level"
%is intensity
%DSParam.spl = ds.EDFIndepVar.Values;
%DSParam.spl = ds.spl(:).';			%Allways row-vector (sometimes difference between EDF and IDF/SPK
DSParam.spl = GetSPL(ds);
DSParam.spl = DSParam.spl(:).';	

%by Abel: save indepvar for later use
DSParam.indepvar = ds.indepvar;

%Format dataset parameters ...
DSParam.idstr    = sprintf('%s <%d-%d>', DSParam.datafile, DSParam.cellnr, DSParam.testnr);
DSParam.titlestr = {sprintf('\\bfClick Train-curves for %s <%d-%d>\\rm', DSParam.datafile, DSParam.cellnr, DSParam.testnr); ...
    sprintf('\\fontsize{7}Created by %s @ %s', upper(mfilename), datestr(now))};

%--------------------------------------------------------------------------------
function StimParam = GetStimParam(ds, IndepVal, Param)

%Stimulus and repetition duration ...
BurstDur = ds.burstdur;
RepDur   = ds.repdur;

%Repetition number ...
Nrep = ds.nrep;

%Noise information ...

if ~Param.inleuven		%for Madison EDF format
	[~, ~, FileName1] = unravelVMSPath(ds.GWParam.FileName);
	NoiseToken = sprintf('%s<%s>', upper(FileName1), upper(ds.GWParam.ID));
else					%for Leuven data
	NoiseToken = sprintf('%s<%s>', upper(ds.filename), upper(ds.seqid));
end

%Click train repetion rate ...
%by abelius: For Madison data, a correction was needed to get the effective
%rate of the stimuli clicks (Hz). For Leuven this is not needed.
%Additionally, Madison data can only have intensity as IndepVar while
%Leuven may also vary the frequency
Param.indepval = IndepVal; %Save in Param for use in GetRepRate, IndepVal is sorted and has NaN taken out
[ReqRepRate, EffRepRate] = GetRepRate(ds, Param);

%Information on independent variable ...
IndepUnit = ds.indepunit;

N = length(IndepVal);
%Format stimulus parameters ...

%by abel:
%if the data is from leuven and the indepvar is a frequency change =>
%RepRate is a list equal to IndepVal.Values
if (Param.inleuven) && strcmpi(ds.StimType, 'CFS')
    for n = 1:N,
        Str{n} = {sprintf('\\bf%s\\rm', Param2Str(IndepVal(n), IndepUnit, 0)); ...
            sprintf('\\itBurstDur:\\rm %s', Param2Str(BurstDur, 'ms', 0)); ...
            sprintf('\\itIntDur:\\rm %s', Param2Str(RepDur, 'ms', 0)); ...
            sprintf('\\itWaveForm:\\rm %s', NoiseToken); ...
            sprintf('\\itRepRate:\\rm %s(%s)', Param2Str(ReqRepRate(n), 'Hz', 0), Param2Str(EffRepRate(n), '', 2));
            sprintf('\\it#Reps:\\rm %s', Param2Str(Nrep, '', 0))};
	end
else
    for n = 1:N,
        Str{n} = {sprintf('\\bf%s\\rm', Param2Str(IndepVal(n), IndepUnit, 0)); ...
            sprintf('\\itBurstDur:\\rm %s', Param2Str(BurstDur, 'ms', 0)); ...
            sprintf('\\itIntDur:\\rm %s', Param2Str(RepDur, 'ms', 0)); ...
            sprintf('\\itWaveForm:\\rm %s', NoiseToken); ...
            sprintf('\\itRepRate(Eff):\\rm %s(%s)', Param2Str(ReqRepRate, 'Hz', 0), Param2Str(EffRepRate, '', 2)); ...
            sprintf('\\it#Reps:\\rm %s', Param2Str(Nrep, '', 0))};
	end
end
%num2cell renders array in this -> need to transfer it to colums to keep the correct number of parameters ()'
StimParam = struct('indepval', (num2cell(IndepVal))', 'indepunit', IndepUnit, 'burstdur', BurstDur, 'repdur', RepDur, ...
        'nrep', Nrep, 'noisetoken', NoiseToken, 'reqreprate', (num2cell(ReqRepRate))', 'effreprate', (num2cell(EffRepRate))', 'str', Str(:));
   
%--------------------------------------------------------------------------------
function [ReqRepRate, EffRepRate] = GetRepRate(ds, Param)
%Function to correct repetition rate in Madision data. This is not needed for
%Leuven data.
%stimuli types: CFS (leuven) = Click frequency 
%               RCC (Madison) = Intesity
%For leuven data, lets set ReqRepRate = EffRepRate and return
%We can't test for fileFormat since it was adapted by ds2edf()

if Param.inleuven
    if strcmpi(ds.stimtype, 'CFS')
        %the IndepVar is frequency, the rep. rate is thus =>
        %ds.IndepVar.Values
        %Use IndepVal stored in Param which is sorted and has NaN taken out
    EffRepRate = Param.indepval;
    ReqRepRate = EffRepRate;
    end
    return
end

%DSS-II specific information ...
MaxPbRate   = 2^19*10/12;    %in Hz ...
MaxPbPeriod = 1e6/MaxPbRate; %in microsec ...

%General waveform information ...
%sometimes, there is something like [JORIS.SO] leading the filename; we delete that part
if isequal('[', ds.GWParam.FileName(1))
    closeBrackPos = find(ds.GWParam.FileName == ']'); % position of the closing bracket
    if isempty(closeBrackPos) || ~isequal(1,length(closeBrackPos))
        error('Error in GWParam filename in dataset');
    end
    FN = ds.GWParam.FileName(closeBrackPos+1:end);
else
    FN = ds.GWParam.FileName;
end
% Then we get the given dataset
dsGEWAV = dataset(FN, ds.GWParam.ID);
GWNPoints  = dsGEWAV.NPoints;
GWPbPeriod = dsGEWAV.PbPer; %in microsec ...

%Extract requested repetition rate ...
ReqRepPeriod = GWNPoints*GWPbPeriod; %in microsec ...
ReqRepRate   = 1e6/ReqRepPeriod;

EffRepPeriod = ceil((ReqRepPeriod-GWPbPeriod)/MaxPbPeriod)*MaxPbPeriod;
EffRepRate   = 1e6/EffRepPeriod;

%--------------------------------------------------------------------------------
function CF = DetermineCF(ParamCF, ThrCF, DifDF, SacDF)

if isnumeric(ParamCF)
    if ~isnan(ParamCF)
        CF = ParamCF;
    elseif ~isnan(ThrCF)
        CF = ThrCF;
    elseif ~isnan(DifDF)
        CF = DifDF;
    else
        CF = SacDF; 
    end
elseif strcmpi(ParamCF, 'cf')
    CF = ThrCF;
elseif strcmpi(ParamCF, 'df')
    if ~isnan(DifDF)
        CF = DifDF;
    else
        CF = SacDF; 
    end    
else
    CF = NaN;
end

%--------------------------------------------------------------------------------
function CalcData = CalcCurves(Spt, Param, StimParam)   

%Raster plot ...
[X, Y] = deal([]); 
NRep   = StimParam.nrep;
YTicks = linspace(-0.4, +0.4, NRep+1);
for n = 1:NRep,
    NSpk = length(Spt{1, n});
    if (NSpk > 0)
        X  = [X, VectorZip(Spt{1, n}, Spt{1, n}, repmat(NaN, 1, NSpk))];
        Y1 = repmat(YTicks(n), 1, NSpk);
        Y2 = repmat(YTicks(n+1), 1, NSpk);
        Y  = [Y, VectorZip(Y1, Y2, repmat(NaN, 1, NSpk))];
    end
end
YTicks = YTicks(2:end) - 0.5*diff(YTicks([1 2]));
YLbls  = num2cell(1:NRep);
[YTicks, YLbls] = AdjustNTicks(YTicks, YLbls, Param.maxnticks);
RAS = lowerFields(CollectInStruct(X, Y, YTicks, YLbls));

%Post Stimulus Time histogram ...
PSTH = CalcPSTH(Spt, 'anwin', Param.psthanwin, 'nbin', Param.psthnbin);

if ~isequal(0, Param.bf)
    BinFreq         = Param.bf;
elseif strcmpi(Param.ratecor, 'yes')
    BinFreq         = StimParam(1).effreprate; 
else
    BinFreq         = StimParam(1).reqreprate; 
end 
BinPeriod = 1e3/BinFreq;

%Cycled Raster plot ...
Spks  = cat(2, Spt{1, :});
Spks  = Spks(Spks >= Param.prdhanwin(1) & Spks < Param.prdhanwin(2));
CycNr = floor((Spks-Param.prdhanwin(1))/BinPeriod)+1;
Phase = rem(Spks, BinPeriod)/BinPeriod;
CRAS  = lowerFields(CollectInStruct(Phase, CycNr));

%Period histogram ...
PRDH = CalcPRDH(Spt, 'anwin', Param.prdhanwin, 'nbin', Param.prdhnbin, 'binfreq', BinFreq);

CalcData = lowerFields(CollectInStruct(RAS, PSTH, CRAS, PRDH));

%--------------------------------------------------------------------------------
function [YTicks, YLbls] = AdjustNTicks(YTicks, YLbls, MaxNTicks)

NYTicks = length(YTicks);
if (NYTicks > MaxNTicks)
    NInc   = ceil(NYTicks/MaxNTicks);
    YTicks = YTicks(1:NInc:NYTicks);
    YLbls  = YLbls(1:NInc:NYTicks);
end    

%--------------------------------------------------------------------------------
function PlotCurves(CalcData, Thr, DSParam, StimParam, Param, S, nPlot)

%Creating figure ...
FigHdl = figure('Name', sprintf('%s: %s', upper(mfilename), DSParam.idstr), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'landscape');

%Header ...
AxHDR = axes('Position', [0.05 0.05 0.425 0.215], 'Visible', 'off');
text(0.5, 0.5, DSParam.titlestr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', 12);

%Extra information ...
AxINF = axes('Position', [0.525 0.05 0.425 0.215], 'Visible', 'off');
if ~isempty(Thr),
    text(0.0, 0.5, [Param.str; {''}; Thr.str], 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontWeight', 'demi', 'FontSize', 9);
else
    text(0.0, 0.5, [Param.str; {''; sprintf('THR data not present')}], 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontWeight', 'demi', 'FontSize', 9);
end    
text(0.5, 0.5, StimParam.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'demi', 'FontSize', 9);

%Post Stimulus Time Histogram ...
AxPSTH = axes('Position', [0.10 0.68 0.5 0.215]);
Hdl = bar(CalcData.psth.hist.bincenters, CalcData.psth.hist.rate, 1);
set(gca, 'box', 'off', 'TickDir', 'out', 'XLim', Param.psthanwin);
set(Hdl, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5]);
xlabel('Time (ms)', 'FontUnits', 'points', 'fontsize', 9);
ylabel('Rate (spk/sec)', 'FontUnits', 'points', 'fontsize', 9);
title('PST histogram', 'FontUnits', 'points', 'fontsize', 10);

%Raster Plot ...
AxRAS = axes('Position', [0.10 0.365 0.5 0.215], 'box', 'on', 'TickDir', 'out', 'XLim', Param.psthanwin, ...
    'YTick', CalcData.ras.yticks, 'YTickLabel', CalcData.ras.ylbls);
Hdl = line(CalcData.ras.x, CalcData.ras.y, 'linestyle', '-', 'marker', 'none', 'color', 'k');
xlabel('Time (ms)', 'FontUnits', 'points', 'fontsize', 9);
ylabel('Repetition Nr.', 'FontUnits', 'points', 'fontsize', 9);
title('Raster plot', 'FontUnits', 'points', 'fontsize', 10);

% %By Abel: Draw analysis window
% if Param.plotsettings.drawprdhanwin
% 	Xmin = Param.prdhanwin(1);
% 	Xmax = Param.prdhanwin(2);
% 	Ymin = 0;
% 	Ymax = 2*max(CalcData.ras.y);%1;%StimParam.nrep; %max(CalcData.ras.y);
% 	X = [Xmin Xmin Xmax Xmax];
% 	Y = [Ymin Ymax Ymax Ymin];
% 	Hdl = patch(X, Y, Param.plotsettings.prdhanwin.facecolor, Param.plotsettings.prdhanwin);
% end


%Period Histogram ...
AxPRDH = axes('Position', [0.70 0.68 0.25 0.215]);
Hdl = bar(CalcData.prdh.hist.bincenters, CalcData.prdh.hist.rate, 1);
set(gca, 'box', 'off', 'TickDir', 'out', 'XLim', [0 1]);
set(Hdl, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5]);
xlabel('Phase (cyc)', 'FontUnits', 'points', 'fontsize', 9);
ylabel('Rate (spk/sec)', 'FontUnits', 'points', 'fontsize', 9);
title('PRD histogram', 'FontUnits', 'points', 'fontsize', 10);

% standard deviation of a cyclic histogram: just move it to the center and
% then calculate std
xData = CalcData.prdh.hist.bincenters + 0.5 - S.Vs.ph(nPlot);
for cX = 1:length(xData)
    if xData(cX) < 0
        xData(cX) = xData(cX) + 1;
    elseif xData(cX) > 1
        xData(cX) = xData(cX) - 1;
    end
end
yData = CalcData.prdh.hist.rate;

stdCyc = histStd(xData, yData);
stdTime = 1000*stdCyc/StimParam.effreprate;

disp(['Mean: ' num2str(histMean(CalcData.prdh.hist.bincenters, CalcData.prdh.hist.rate))]);

%By Abel:
%bf: binning frequency = size of the period which is taken to overlay the
%periodic data. Thus frequency range over which the period histogram is
%created. For NON-Madison data this field must be updated since frequency
%can now be an indepvar.
%prdStr = {['Vs.bf: ' num2str(S.Vs.bf)]; ['Vs.r: ' num2str(S.Vs.r(nPlot))];['Vs.ph: ' num2str(S.Vs.ph(nPlot))];['Vs.raysign: ' num2str(S.Vs.raysign(nPlot))];['Vs.nspk: ' num2str(S.Vs.nspk(nPlot))]; ['Vs.sdc: ' num2str(stdCyc)];['Vs.sdt: ' num2str(stdTime) ' ms']};
prdStr = {['Vs.bf: ' num2str(S.Vs.bf(nPlot))]; ['Vs.r: ' num2str(S.Vs.r(nPlot))];['Vs.ph: ' num2str(S.Vs.ph(nPlot))];['Vs.raysign: ' num2str(S.Vs.raysign(nPlot))];['Vs.nspk: ' num2str(S.Vs.nspk(nPlot))]; ['Vs.sdc: ' num2str(stdCyc)];['Vs.sdt: ' num2str(stdTime) ' ms']};
text(0.6, 0.7, prdStr, 'units', 'normalized');


%Cycle Raster Plot ...
AxRAS = axes('Position', [0.70 0.365 0.25 0.215], 'box', 'on', 'TickDir', 'out', 'XLim', [0 1]);
Hdl = line(CalcData.cras.phase, CalcData.cras.cycnr, 'linestyle', 'none', 'marker', '.', 'markersize', 1, 'color', 'k');
xlabel('Phase (cyc)', 'FontUnits', 'points', 'fontsize', 9);
ylabel('Cycle Nr.', 'FontUnits', 'points', 'fontsize', 9);
title('Cycle Raster plot', 'FontUnits', 'points', 'fontsize', 10);

%--------------------------------------------------------------------------------
% function checkJavaMem()
% heapTotalMemory = java.lang.Runtime.getRuntime.totalMemory;
% heapFreeMemory = java.lang.Runtime.getRuntime.freeMemory;
% if(heapFreeMemory < (heapTotalMemory*0.01))
%     java.lang.Runtime.getRuntime.gc;
% end