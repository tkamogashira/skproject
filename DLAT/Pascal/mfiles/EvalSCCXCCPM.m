function ArgOut = EvalSCCXCC(varargin)
%EVALSCCXCC  calculate the SCC, XCC and DIFCOR.
%   T = EVALSCCXCC(ds1P, SubSeq1P, ds1N, SubSeq1N, ds2P, SubSeq2P, ds2N, SubSeq2N)
%   calculates the SCC, XCC and DIFCOR from the specified responses. The noise token
%   A+ response of the first cell is given by subsequence SubSeq1P from dataset ds1P.
%   Response to the A- token is given by subsequence SubSeq1N of dataset ds1N. Mutatis
%   mutandis for the second cell.
%   E.g.
%           ds1p = dataset('A0241', -128); %75-3-NSPL-A+
%           ds1n = dataset('A0241', -129); %75-4-NSPL-A-
%           ds2p = dataset('A0241', -133); %76-3-NSPL-A+
%           ds2n = dataset('A0241', -134); %76-4-NSPL-A-
%           EvalSCCXCC(ds1p, 50, ds1n, 50, ds2p, 50, ds2n, 50);
%
%   T = EVALSCCXCC(ds1, SubSeqs1, ds2, SubSeqs2) calculates the SCC, XCC and DIFCOR 
%   where the responses of a cell to the two noise tokens is located in the same
%   dataset at different subsequence numbers.
%   E.g.
%           ds1 = dataset('A0242', 60); %15-2-NRHO-A+-
%           ds2 = dataset('A0242', 50); %13-2-NRHO-A+-
%           EvalSCCXCC(ds1, [+1, -1], ds2, [+1, -1]);
% 
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 18-04-2005

%Attention! Caching system is not supported because the MEX implementation of
%SPTCORR makes the overhead of caching unrewarding ...

%-----------------------------------template---------------------------------
%Attention! The cochlear distance, which can be derived from the tuning frequency
%of a cell (either the characteristic frequency CF or the dominant frequency DF),
%is not included in the table. Using the function GREENWOOD.M, delivered with the
%SGSR distribution, this is easily calculated afterwards when using STRUCTTOOLS.
%For the same reason the difference in tuning frequency between the two crosscorrelated
%cells is not included ...
%... identification ...
Template.ds1p.filename       = '';        %Datafile name for datasets of first input
Template.ds1p.icell          = NaN;       %Cell number of first input
Template.ds1p.iseq           = NaN;       %Sequence number of first input's positive response 
Template.ds1p.seqid          = '';        %Identifier of first dataset
Template.ds1p.isubseq        = NaN;       %Subsequence number of spiketrain used for first dataset
Template.ds1n.iseq           = NaN;       %Sequence number of second dataset
Template.ds1n.seqid          = '';        %Identifier of second dataset
Template.ds1n.isubseq        = NaN;       %Subsequence number of spiketrain used for second dataset
Template.ds2p.filename       = '';        %Datafile name for second dataset
Template.ds2p.icell          = NaN;       %Cell number of second dataset
Template.ds2p.iseq           = NaN;       %Sequence number of second dataset
Template.ds2p.seqid          = '';        %Identifier of second dataset
Template.ds2p.isubseq        = NaN;       %Subsequence number of spiketrain used for second dataset
Template.ds2n.iseq           = NaN;       %Sequence number of second dataset
Template.ds2n.seqid          = '';        %Identifier of second dataset
Template.ds2n.isubseq        = NaN;       %Subsequence number of spiketrain used for second dataset
%... miscellaneous ...
Template.tag                 = 0;         %General purpose tag field
Template.createdby           = mfilename; %Name of MATLAB function that generated the data
%... stimulus parameters ...
%Stimulus parameters are saved as numerical matrices where different columns correspond to
%different datasets and different rows designate different channels ... 
Template.stim.burstdur       = repmat(NaN, 1, 4); %Stimulus duration in ms
Template.stim.repdur         = repmat(NaN, 1, 4); %Repetition duration in ms
Template.stim.nrep           = repmat(NaN, 1, 4); %Number of repetitions
Template.stim.spl            = repmat(NaN, 2, 4); %Sound pressure level in dB
Template.stim.avgspl1        = NaN;               %Averaging of SPL in the power spectrum for one
Template.stim.avgspl2        = NaN;               %input ...
Template.stim.avgspl         = NaN;               %Averaging of SPL in the power spectrum for both
                                                  %inputs ...
%... threshold curve ...
Template.thr1.cf             = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr1.sr             = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr1.thr            = NaN;       %Threshold at characteristic frequency
Template.thr1.q10            = NaN;       %Q10 retrieved from threshold curve
Template.thr1.bw             = NaN;       %Width 10dB above threshold (Hz)
Template.thr2.cf             = NaN;
Template.thr2.sr             = NaN;
Template.thr2.thr            = NaN;
Template.thr2.q10            = NaN;
Template.thr2.bw             = NaN;
%... rate curve ...
%Attention! Driven rate can be calculated afterwards by subtracting spontaneous rate derived
%from threshold curves from the mean rate ...
Template.rc1.mean            = NaN;
Template.rc2.mean            = NaN;
%... autocorrelogram ...
Template.sac1.max            = NaN;       %Maximum of shuffled autocorrelogram (DriesNorm)
Template.sac1.hhw            = NaN;       %Half height width on autocorrelogram (ms)
Template.sac1.fft.df         = NaN;       %Dominant frequency in autocorrelogram (Hz)
Template.sac1.fft.bw         = NaN;       %Bandwidth (Hz)
Template.dac1.max            = NaN;       %Maximum of diffautocorrelogram (DriesNorm)
Template.dac1.maxsecpks      = [NaN, NaN];%Height of secondary peaks (DriesNorm)
Template.dac1.lagsecpks      = [NaN, NaN];%Lag at secondary peaks (ms)
Template.dac1.fft.df         = NaN;       %Dominant frequency in diffcorrelogram (Hz)
Template.dac1.fft.bw         = NaN;       %Bandwidth (Hz)
Template.dac1.env.hhw        = NaN;       %Half height with on envelope of diffcorrelogram (ms)
Template.sac2.max            = NaN;       
Template.sac2.hhw            = NaN;       
Template.sac2.fft.df         = NaN;       
Template.sac2.fft.bw         = NaN;       
Template.dac2.max            = NaN;       
Template.dac2.maxsecpks      = [NaN, NaN];
Template.dac2.lagsecpks      = [NaN, NaN];
Template.dac2.fft.df         = NaN;       
Template.dac2.fft.bw         = NaN;       
Template.dac2.env.hhw        = NaN;       
%... crosscorrelogram ...
Template.scc.max             = NaN;       %Maximum of shuffled crosscorrelogram (DriesNorm)
Template.scc.rate            = NaN;       %Maximum of shuffled crosscorrelogram (Rate)
Template.scc.lagatmax        = NaN;       %Lag at maximum of SCC (ms)
Template.scc.maxsecpks       = [NaN, NaN];%Height of secondary peaks (DriesNorm)
Template.scc.lagsecpks       = [NaN, NaN];%Lag at secondary peaks (ms)
Template.scc.hhw             = NaN;       %Half height width on SCC (ms)
Template.scc.fft.df          = NaN;       %Dominant frequency in SCC (Hz)
Template.scc.fft.bw          = NaN;       %Bandwidth (Hz)
Template.dcc.max             = NaN;       %Maximum of diffcorrelogram (DriesNorm)
Template.dcc.rate            = NaN;       %Maximum of diffcorrelogram (Rate)
Template.dcc.lagatmax        = NaN;       %Lag at maximum (in ms)
Template.dcc.maxsecpks       = [NaN, NaN];%Height of secondary peaks (DriesNorm)
Template.dcc.lagsecpks       = [NaN, NaN];%Lag at secondary peaks (ms)
Template.dcc.fft.df          = NaN;       %Dominant frequecny in diffcorrelogram (Hz)
Template.dcc.fft.bw          = NaN;       %Bandwidth (Hz)
Template.dcc.env.max         = NaN;       %Maximum of enveloppe of diffcorrelogram (DriesNorm)
Template.dcc.env.lagatmax    = NaN;       %Lag at maximum of enveloppe (ms)
Template.dcc.env.hhw         = NaN;       %Half height with on envelope of diffcorrelogram (ms)

%-------------------------------default parameters---------------------------
%Syntax parameters ...
DefParam.subseqinput   = 'indepval'; %'indepval' or 'subseq' ...
%Calculation parameters ...
DefParam.anwin         = [0 +Inf];   %in ms (Infinite designates stimulus duration) ...
DefParam.corbinwidth   = 0.05;       %in ms ...
DefParam.cormaxlag     = 15;         %in ms ...   
DefParam.envrunavunit  = '#';        %'#' or 'ms' ...
DefParam.envrunav      = 1;          %in ms or number of periods ...
DefParam.corfftrunav   = 100;        %in Hz ...
DefParam.diffftrunav   = 100;        %in Hz ...
DefParam.calcdf        = NaN;        %in Hz, NaN (automatic), 'cf' or 'df' ...
%Calculation of average SACs is only useful when supplying the responses from the same
%fiber or cell to two different noise tokens (e.g. A+, A-, B+, B-). The average SAC and
%XAC is calculated, but the results are stored in the returned structure-array using
%the fieldnames appropriate for SCCs and XCCs analysis. The generated plot also has this
%naming abnormality ...
% E.g.:
%       ds = dataset('R99040', '6-2-ab');
%       EvalSCCXCC(ds, 1, ds, 3, ds, 2, ds, 4, 'calctype', 'avgsac');
DefParam.calctype      = 'scc';      %'scc' or 'avgsac' ...
%Plot parameters ...
DefParam.plot          = 'yes';      %'yes' or 'no' ...
DefParam.corxrange     = [-5 +5];    %in ms ...
DefParam.corxstep      = 1;          %in ms ...
DefParam.fftxrange     = [0 500];    %in Hz ...
DefParam.fftxstep      = 50;         %in Hz ...
DefParam.fftyunit      = 'dB';       %'dB' or 'P' ...
DefParam.fftyrange     = [-20 0]; 

%----------------------------------main program------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    if (nargout == 0), disp('Properties and their factory defaults:'); disp(DefParam);
    else, ArgOut = DefParam; end
    return;
elseif (nargin == 2) & ischar(varargin{1}) & strcmpi(varargin{1}, 'checkprops') & isstruct(varargin{2}),
    CheckParam(varargin{2}); return;
else, [Spt, Info, StimParam, Param] = ParseArgs(DefParam, varargin{:}); end

%Retrieve and calculate threshold curve information ...
Thr(1) = RetrieveThrInfo(Info.ds1p.filename, Info.ds1p.icell);
Thr(2) = RetrieveThrInfo(Info.ds2p.filename, Info.ds2p.icell);

%Extract rate curve information ...
RC(1) = CalcRC(Spt{1:2}, Param);
RC(2) = CalcRC(Spt{3:4}, Param);

%Calculate correlograms ...
[SXAC(1), DAC(1)] = CalcAC(Spt{1:2}, Thr(1), Param);
[SXAC(2), DAC(2)] = CalcAC(Spt{3:4}, Thr(2), Param);
if strncmpi(Param.calctype, 's', 1), [SXCC, DCC] = CalcCC(Spt{:}, Thr, Param);
else, [SXCC, DCC] = CalcAvgAC(Spt{:}, Thr, Param); end

%Display data ...
if strcmpi(Param.plot, 'yes'), PlotData(SXAC, DAC, SXCC, DCC, Thr, RC, Info, StimParam, Param); end

%Return output if requested ...
if (nargout > 0), 
    CalcData = Info; CalcData.stim = StimParam;
    [CalcData.rc1,  CalcData.rc2]  = deal(RC(1), RC(2));
    [CalcData.thr1, CalcData.thr2] = deal(Thr(1), Thr(2));
    [CalcData.sac1, CalcData.sac2] = deal(SXAC(1), SXAC(2));
    [CalcData.dac1, CalcData.dac2] = deal(DAC(1), DAC(2));
    [CalcData.scc,  CalcData.dcc]  = deal(SXCC, DCC);
    ArgOut = structtemplate(CalcData, Template); 
end

%----------------------------------------------------------------------------
function [Spt, Info, StimParam, Param] = ParseArgs(DefParam, varargin)

%Checking input arguments ...
Nds = length(find(cellfun('isclass', varargin, 'dataset') | cellfun('isclass', varargin, 'edfdataset')));
if (Nds == 2), %T = EVALSCCXCC(ds1, SubSeqs1, ds2, SubSeqs2)
    if (length(varargin) < 4), error('Wrong number of input arguments.'); end
    if ~all(cellfun('isclass', varargin([1, 3]), 'dataset') | cellfun('isclass', varargin([1, 3]), 'edfdataset')), 
        error('First and third argument should be datasets.'); 
    else, [ds1p, ds1n, ds2p, ds2n] = deal(varargin{[1, 1, 3, 3]}); end
    
    if ~isnumeric(varargin{2}) | ~any(length(varargin{2}) == [1, 2]) | ~isnumeric(varargin{4}) | ~any(length(varargin{4}) == [1, 2]), 
        error('Second and fourth argument should be scalars or two-element numeric vectors.')
    else,
        InputVec = cat(2, varargin{2}([1, end]), varargin{4}([1, end]));
        InputVec(find(cellfun('length', varargin([2, 4])) == 1)*2) = NaN;
    end
    
    if isnan(InputVec(2)), ds1n = dataset; end
    if isnan(InputVec(4)), ds2n = dataset; end
    
    ParamIdx = 5;
elseif (Nds == 4), %T = EVALSCCXCC(ds1P, SubSeq1P, ds1N, SubSeq1N, ds2P, SubSeq2P, ds2N, SubSeq2N)
    if (length(varargin) < 8), error('Wrong number of input arguments.'); end
    
    if ~all(cellfun('isclass', varargin(1:2:7), 'dataset') | cellfun('isclass', varargin(1:2:7), 'edfdataset')), 
        error('First, third, fifth and seventh argument should be datasets.');
    else, [ds1p, ds1n, ds2p, ds2n] = deal(varargin{1:2:7}); end

    if ~all(cellfun('isclass', varargin(2:2:8), 'double')) | ~all(cellfun('length', varargin(2:2:8)) == 1),
        error('Subsequences should be specified using a numerical scalar.');
    else, InputVec = cat(2, varargin{2:2:8}); end
    
    if isvoid(ds1n) & ~isnan(InputVec(2)), error('Associated subsequence of void dataset should be NaN.'); end
    if isvoid(ds2n) & ~isnan(InputVec(4)), error('Associated subsequence of void dataset should be NaN.'); end
    
    
    if (~isvoid(ds1n) & (~isequal(ds1p.filename, ds1n.filename) | ~isequal(ds1p.icell, ds1n.icell))) | ...
       (~isvoid(ds2n) & (~isequal(ds2p.filename, ds2n.filename) | ~isequal(ds2p.icell, ds2n.icell))), 
        error('Responses to different noise tokens from same cell should also be recorded from same cell.'); 
    end
    
    ParamIdx = 9;
else, error('Invalid input arguments.'); end

%Retrieving properties and checking their values ...
Param = CheckPropList(DefParam, varargin{ParamIdx:end});
CheckParam(Param);

%Checking subsequences numbers and values of independent variable ...
dsNames = {'ds1p', 'ds1n', 'ds2p', 'ds2n'}; Nds = 4;
if strcmpi(Param.subseqinput, 'subseq'), 
    iSubSeqs = InputVec; IndepVals = NaN*zeros(1, Nds);
    for n = find(~isnan(iSubSeqs)), 
       try, IndepVals(n) = eval(sprintf('%s.indepval(iSubSeqs(%d));', dsNames{n}, n)); 
       catch, error('One of the supplied subsequence numbers is invalid'); end
    end
else,
    IndepVals = InputVec; iSubSeqs = NaN*zeros(1, Nds);
    for n = find(~isnan(IndepVals)),
       idx = eval(sprintf('find(%s.indepval == IndepVals(%d));', dsNames{n}, n));
       if ~isempty(idx) & (length(idx) == 1), iSubSeqs(n) = idx;
       else, error('One of the supplied values of the independent variabale doesn''t exist.'); end
    end
end

%Assembling spiketrains ...
Spt = cell(Nds, 1);
for n = find(~isnan(iSubSeqs)), Spt{n} = eval(sprintf('%s.spt(iSubSeqs(%d), :);', dsNames{n}, n)); end

%Assembling dataset information ...
Info.ds1p.filename  = lower(ds1p.filename);
Info.ds1p.icell     = ds1p.icell;
Info.ds1p.iseq      = ds1p.iseq;
Info.ds1p.seqid     = lower(ds1p.seqid);
Info.ds1p.isubseq   = iSubSeqs(1);
Info.ds1p.indepval  = IndepVals(1);
Info.ds1p.indepunit = ds1p.indepunit;

if ~isvoid(ds1n), Info.ds1n.iseq = ds1n.iseq;
else, Info.ds1n.iseq = NaN; end    
Info.ds1n.seqid     = lower(ds1n.seqid);
Info.ds1n.isubseq   = iSubSeqs(2);
Info.ds1n.indepval  = IndepVals(2);
Info.ds1n.indepunit = ds1n.indepunit;

Info.ds2p.filename  = lower(ds2p.filename);
Info.ds2p.icell     = ds2p.icell;
Info.ds2p.iseq      = ds2p.iseq;
Info.ds2p.seqid     = lower(ds2p.seqid);
Info.ds2p.isubseq   = iSubSeqs(3);
Info.ds2p.indepval  = IndepVals(3);
Info.ds2p.indepunit = ds2p.indepunit;

if ~isvoid(ds2n), Info.ds2n.iseq = ds2n.iseq;
else, Info.ds2n.iseq = NaN; end
Info.ds2n.seqid     = lower(ds2n.seqid);
Info.ds2n.isubseq   = iSubSeqs(4);
Info.ds2n.indepval  = IndepVals(4);
Info.ds2n.indepunit = ds2n.indepunit;

if isnan(Info.ds1n.isubseq),
    Info.idstr1 = sprintf('%s #%d@%.0f%s', upper(Info.ds1p.filename), Info.ds1p.iseq, ...
        Info.ds1p.indepval, Info.ds1p.indepunit);
else,    
    Info.idstr1 = sprintf('%s #%d@%.0f%s & #%d@%.0f%s', upper(Info.ds1p.filename), Info.ds1p.iseq, ...
        Info.ds1p.indepval, Info.ds1p.indepunit, Info.ds1n.iseq, Info.ds1n.indepval, Info.ds1n.indepunit);
end    
if isnan(Info.ds2n.isubseq),
    Info.idstr2 = sprintf('%s #%d@%.0f%s', upper(Info.ds2p.filename), Info.ds2p.iseq, ...
        Info.ds2p.indepval, Info.ds2p.indepunit);
else,    
    Info.idstr2 = sprintf('%s #%d@%.0f%s & #%d@%.0f%s', upper(Info.ds2p.filename), Info.ds2p.iseq, ...
        Info.ds2p.indepval, Info.ds2p.indepunit, Info.ds2n.iseq, Info.ds2n.indepval, Info.ds2n.indepunit);
end
Info.capstr = sprintf('%s versus %s', Info.idstr1, Info.idstr2);
Info.hdrstr = sprintf('%s \\leftrightarrow %s', Info.idstr1, Info.idstr2);

%Collecting and reorganizing stimulus parameters ...
StimParam = GetStimParam(ds1p, ds1n, ds2p, ds2n, iSubSeqs);

%Substitution of shortcuts in properties ...
if isinf(Param.anwin(2)), Param.anwin(2) = min(StimParam.burstdur); end

%Format parameter information ...
if isnan(Param.calcdf), CalcDFStr = 'auto';
elseif ischar(Param.calcdf), CalcDFStr = lower(Param.calcdf);
else, CalcDFStr = Param2Str(Param.calcdf, 'Hz', 0); end
s = sprintf('AnWin = %s', Param2Str(Param.anwin, 'ms', 0));
s = strvcat(s, sprintf('BinWidth = %s', Param2Str(Param.corbinwidth, 'ms', 2)));
s = strvcat(s, sprintf('MaxLag = %s', Param2Str(Param.cormaxlag, 'ms', 0)));
s = strvcat(s, sprintf('Calc. DF = %s', CalcDFStr));
s = strvcat(s, sprintf('RunAv(Env) = %.2f(%s)', Param.envrunav, Param.envrunavunit));
s = strvcat(s, sprintf('RunAv(Dft on COR) = %s', Param2Str(Param.corfftrunav, 'Hz', 0)));
s = strvcat(s, sprintf('RunAv(Dft on DIF) = %s', Param2Str(Param.diffftrunav, 'Hz', 0)));
Param.str = s;

%----------------------------------------------------------------------------
function CheckParam(Param)

%Syntax parameters ...
if ~any(strcmpi(Param.subseqinput, {'indepval', 'subseq'})), error('Property subseqinput must be ''indepval'' or ''subseq''.'); end

%Calculation parameters ...
if ~isnumeric(Param.anwin) | (size(Param.anwin) ~= [1,2]) | ~isinrange(Param.anwin, [0, +Inf]), error('Invalid value for property anwin.'); end
if ~isnumeric(Param.corbinwidth) | (length(Param.corbinwidth) ~= 1) | (Param.corbinwidth <= 0), error('Invalid value for property corbinwidth.'); end
if ~isnumeric(Param.cormaxlag) | (length(Param.cormaxlag) ~= 1) | (Param.cormaxlag <= 0), error('Invalid value for property cormaxlag.'); end
if ~any(strcmpi(Param.envrunavunit, {'#', 'ms'})), error('Property envrunavunit must be ''#'' or ''ms''.'); end
if ~isnumeric(Param.envrunav) | (length(Param.envrunav) ~= 1) | (Param.envrunav < 0), error('Invalid value for property envrunav.'); end
if ~isnumeric(Param.corfftrunav) | (length(Param.corfftrunav) ~= 1) | (Param.corfftrunav < 0), error('Invalid value for property corfftrunav.'); end
if ~isnumeric(Param.diffftrunav) | (length(Param.diffftrunav) ~= 1) | (Param.diffftrunav < 0), error('Invalid value for property diffftrunav.'); end
if ~(isnumeric(Param.calcdf) & ((Param.calcdf > 0) | isnan(Param.calcdf))) & ...
        ~(ischar(Param.calcdf) & any(strcmpi(Param.calcdf, {'cf', 'df'}))), 
    error('Property calcdf must be positive integer, NaN, ''cf'' or ''df''.'); 
end
if ~any(strncmpi(Param.calctype, {'scc', 'avgsac'}, 1)), 
    error('Property calctype must be ''scc'' or ''avgsac''.'); 
end

%Plot parameters ...
if ~any(strcmpi(Param.plot, {'yes', 'no'})), error('Property plot must be ''yes'' or ''no''.'); end
if ~isinrange(Param.corxrange, [-Inf +Inf]), error('Invalid value for property corxrange.'); end
if ~isnumeric(Param.corxstep) | (length(Param.corxstep) ~= 1) | (Param.corxstep <= 0), error('Invalid value for property corxstep.'); end
if ~isinrange(Param.fftxrange, [0 +Inf]), error('Invalid value for property fftxrange.'); end
if ~isnumeric(Param.fftxstep) | (length(Param.fftxstep) ~= 1) | (Param.fftxstep <= 0), error('Invalid value for property fftxstep.'); end
if ~any(strcmpi(Param.fftyunit, {'dB', 'P'})), error('Property fftyunit must be ''dB'' or ''P''.'); end
if ~isinrange(Param.fftyrange, [-Inf +Inf]), error('Invalid value for property fftyrange.'); end

%----------------------------------------------------------------------------
function StimParam = GetStimParam(ds1p, ds1n, ds2p, ds2n, iSubSeqs)

dsNames = {'ds1p', 'ds1n', 'ds2p', 'ds2n'}; Nds = 4;

[StimParam.burstdur, StimParam.repdur, StimParam.nrep] = deal(repmat(NaN, 1, Nds));
StimParam.spl = repmat(NaN, 2, Nds);
for n = 1:Nds,
    ds = eval(dsNames{n});
    if ~isnan(iSubSeqs(n)) , 
        %If stimulus or repetition duration are not the same for different channels then
        %the minimum value is used ...
        StimParam.burstdur(n) = round(min(ds.burstdur));
        StimParam.repdur(n) = round(min(ds.repdur));
        StimParam.nrep(n) = round(min(ds.nrep));
        SPL = GetSPL(ds); StimParam.spl(:, n) = round(SPL(iSubSeqs(n), [1, end])');
    end
end
StimParam.avgspl1 = CombineSPLs(denan(StimParam.spl(:, [1 2]))');
StimParam.avgspl2 = CombineSPLs(denan(StimParam.spl(:, [3 4]))');
StimParam.avgspl  = CombineSPLs(denan(StimParam.spl(:))');

%Format stimulus parameters ...
s = sprintf('BurstDur = %s ms', mat2str(StimParam.burstdur));
s = strvcat(s, sprintf('IntDur = %s ms', mat2str(StimParam.repdur)));
s = strvcat(s, sprintf('#Reps = %s', mat2str(StimParam.nrep)));
s = strvcat(s, sprintf('SPL = %s dB', mat2str(CombineSPLs(StimParam.spl')')));
StimParam.str = s;

%----------------------------------------------------------------------------
function Str = Param2Str(V, Unit, Prec)

C = num2cell(V);
Sz = size(V);
N  = prod(Sz);

if (N == 1) | all(isequal(C{:})), Str = sprintf(['%.'  int2str(Prec) 'f%s'], V(1), Unit);
elseif (N == 2), Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], V(1), Unit, V(2), Unit);
elseif any(Sz == 1), 
    Str = sprintf(['%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s'], min(V(:)), Unit, max(V(:)), Unit); 
else, 
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], ...
        min(V(:, 1)), Unit, min(V(:, 2)), Unit, max(V(:, 1)), Unit, max(V(:, 2)), Unit); 
end

%----------------------------------------------------------------------------
function Thr = RetrieveThrInfo(FileName, iCell)

Thr = struct('cf', NaN, 'sr', NaN, 'thr', NaN, 'bw', NaN, 'q10', NaN, 'str', sprintf('No threshold\ninformation present.'));

try, %Retrieving data from SGSR server ...
    UD = getuserdata(FileName, iCell); if isempty(UD), error('To catch block ...'); end
    if ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(FileName, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        s = sprintf('%s <%s>', dsTHR.FileName, dsTHR.seqID);
        s = strvcat(s, sprintf('CF = %s @ %s', Param2Str(CF, 'Hz', 0), Param2Str(Thr, 'dB', 0)));
        s = strvcat(s, sprintf('SR = %s', Param2Str(SR, 'spk/sec', 1)));
        s = strvcat(s, sprintf('BW = %s', Param2Str(BW, 'Hz', 1)));
        s = strvcat(s, sprintf('Q10 = %s', Param2Str(Q10, '', 1)));
        Str = s;
        Thr = lowerfields(CollectInStruct(CF, SR, Thr, BW, Q10, Str));
    end
catch, warning(sprintf('%s\nAdditional information from SGSR server is not included.', lasterr)); end

%----------------------------------------------------------------------------
function RC = CalcRC(SptP, SptN, Param)

WinDur = abs(diff(Param.anwin));

Rp = 1e3*mean(cellfun('length', SptP))/WinDur;
if ~isempty(SptN), Rn = 1e3*mean(cellfun('length', SptN))/WinDur; else, Rn = []; end

RC.mean = mean([Rp, Rn]);
RC.str = sprintf('AvgR = %s', Param2Str(RC.mean, 'spk/sec', 0));

%----------------------------------------------------------------------------
function [SXAC, DAC] = CalcAC(SptP, SptN, Thr, Param)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
SptP = anwin(SptP, Param.anwin);
SptN = anwin(SptN, Param.anwin);

if ~isempty(SptN),
    %Correlation of noise token A+ responses of a cell with the responses of that same cell to that same noise
    %token. If spiketrains are derived from the same cell this is called a Shuffled Auto-
    %Correlogram (or SAC). 'Shuffled' because of the shuffling of repetitions in order to avoid to correlation
    %of a repetition with itself. The terminolgy AutoCorrelogram is only used when comparing spiketrains 
    %collected from the same cell.
    [Ypp, T, NC] = SPTCORR(SptP, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ypp = ApplyNorm(Ypp, NC);
    %Correlation of noise token A- responses of a cell with the responses of that same cell to that same noise
    %token.
    [Ynn, T, NC] = SPTCORR(SptN, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ynn = ApplyNorm(Ynn, NC);
    %Correlation of noise token A+ responses of a cell with the responses of that same cell to a different noise
    %token, in this case A-. Because of the fact that we correlate across stimuli this type of correlogram is 
    %designated XAC, when comparing responses from the same cell.
    [Ypn, T, NC] = SPTCORR(SptP, SptN, Param.cormaxlag, Param.corbinwidth, WinDur); %XAC ...
    Ypn = ApplyNorm(Ypn, NC);
    %Correlation of noise token A- responses of a cell with the responses of that same cell to a different noise
    %token, in this case A+.
    [Ynp, T, NC] = SPTCORR(SptN, SptP, Param.cormaxlag, Param.corbinwidth, WinDur); %XAC ...
    Ynp = ApplyNorm(Ynp, NC);
    
    %Calculation of the DIFCOR by taking the average of the two SACs and the two XACs and subtracting the second
    %from the first ...
    Ysac = mean([Ypp; Ynn]); 
    Yxac = mean([Ypn; Ynp]);
    Ydifcor = Ysac - Yxac;
    
    %Performing spectrum analysis on the DIFCOR. Because a difcor has no DC component in comparison with
    %other correlograms, this almost always results in a representative dominant frequency ...
    FFTdif = spectana(T, Ydifcor, 'RunAvUnit', 'Hz', 'RunAvRange', Param.diffftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum, therefore all
    %magnitude units need to be changed ...
    FFTdif.Magn.P  = FFTdif.Magn.A;
    FFTdif.Magn.A  = sqrt(FFTdif.Magn.A);
    FFTdif.Magn.dB = FFTdif.Magn.dB/2;
    
    %Performing spectrum analysis on the SAC. Because an autocorrelogram has a DC component this is
    %removed first ...
    FFTsac = spectana(T, detrend(Ysac, 'constant'), 'RunAvUnit', 'Hz', 'RunAvRange', Param.corfftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum, therefore all
    %magnitude units need to be changed ...
    FFTsac.Magn.P  = FFTsac.Magn.A;
    FFTsac.Magn.A  = sqrt(FFTsac.Magn.A);
    FFTsac.Magn.dB = FFTsac.Magn.dB/2;
    
    %Determine which dominant frequency to be used in the calculation ...
    DomFreq = DetermineCalcDF(Param.calcdf, Thr.cf, FFTdif.DF, FFTsac.DF);
    if (DomFreq ~= 0), DomPer = 1000/DomFreq; else, DomPer = NaN; end %Dominant period in ms ...
    
    %Calculating the half height width on the peak of the SAC (relative to asymptote one)...
    HalfMaxSac = ((max(Ysac)-1)/2)+1;
    SacHHWx = cintersect(T, Ysac, HalfMaxSac); SacHHW = abs(diff(SacHHWx));
    
    %Calculating envelope and Half Height Width of DIFCOR ...
    if strcmpi(Param.envrunavunit, 'ms'), EnvRunAvN = round(Param.envrunav/Param.corbinwidth);
    else, EnvRunAvN = round((Param.envrunav*DomPer)/Param.corbinwidth); end 
    Yenv = runav(abs(hilbert(Ydifcor)), EnvRunAvN); 
    HalfMaxEnv = max(Yenv)/2;
    DifHHWx = cintersect(T, Yenv, HalfMaxEnv); DifHHW = abs(diff(DifHHWx));
    
    %Extracting information on secundary peaks in the DIFCOR and its enveloppe ...
    [dummy, dummy, DifXsecPeaks, DifYsecPeaks] = GetPeaks(T, Ydifcor, 0, DomPer);
    
    %Reorganizing calculated data ...
    SXAC.lag      = T;
    SXAC.normco   = [Ysac; Yxac];
    SXAC.max      = max(Ysac);
    SXAC.hhw      = SacHHW;
    SXAC.hhwx     = SacHHWx;
    SXAC.halfmax  = HalfMaxSac;
    SXAC.fft.freq = FFTsac.Freq;
    SXAC.fft.p    = FFTsac.Magn.P;   
    SXAC.fft.db   = FFTsac.Magn.dB;
    SXAC.fft.df   = FFTsac.DF;
    SXAC.fft.bw   = FFTsac.BW;
    
    DAC.lag         = T;
    DAC.normco      = [Ydifcor; Yenv; -Yenv];
    DAC.max         = max(Ydifcor);
    DAC.maxsecpks   = DifYsecPeaks;
    DAC.lagsecpks   = DifXsecPeaks;
    DAC.fft.freq    = FFTdif.Freq;
    DAC.fft.p       = FFTdif.Magn.P;   
    DAC.fft.db      = FFTdif.Magn.dB;
    DAC.fft.df      = FFTdif.DF;
    DAC.fft.bw      = FFTdif.BW;
    DAC.env.hhw     = DifHHW;
    DAC.env.hhwx    = DifHHWx;
    DAC.env.halfmax = HalfMaxEnv;
else,
    %Correlation of noise token A+ responses of a cell with the responses of that same cell to that same noise
    %token ...
    [Ysac, T, NC] = SPTCORR(SptP, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ysac = ApplyNorm(Ysac, NC);
    
    %Performing spectrum analysis on the SAC. Because an autocorrelogram has a DC component this is
    %removed first ...
    FFTsac = spectana(T, detrend(Ysac, 'constant'), 'RunAvUnit', 'Hz', 'RunAvRange', Param.corfftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum, therefore all
    %magnitude units need to be changed ...
    FFTsac.Magn.P  = FFTsac.Magn.A;
    FFTsac.Magn.A  = sqrt(FFTsac.Magn.A);
    FFTsac.Magn.dB = FFTsac.Magn.dB/2;
    
    %Determine which dominant frequency to be used in the calculation ...
    DomFreq = DetermineCalcDF(Param.calcdf, Thr.cf, NaN, FFTsac.DF);
    if (DomFreq ~= 0), DomPer = 1000/DomFreq; else, DomPer = NaN; end %Dominant period in ms ...
    
    %Calculating the half height width on the peak of the SAC (relative to asymptote one)...
    HalfMaxSac = ((max(Ysac)-1)/2)+1;
    SacHHWx = cintersect(T, Ysac, HalfMaxSac); SacHHW = abs(diff(SacHHWx));
    
    %Reorganizing calculated data ...
    SXAC.lag      = T;
    SXAC.normco   = Ysac;
    SXAC.max      = max(Ysac);
    SXAC.hhw      = SacHHW;
    SXAC.hhwx     = SacHHWx;
    SXAC.halfmax  = HalfMaxSac;
    SXAC.fft.freq = FFTsac.Freq;
    SXAC.fft.p    = FFTsac.Magn.P;   
    SXAC.fft.db   = FFTsac.Magn.dB;
    SXAC.fft.df   = FFTsac.DF;
    SXAC.fft.bw   = FFTsac.BW;
    
    DAC.lag         = [];
    DAC.normco      = [];
    DAC.max         = NaN;
    DAC.maxsecpks   = [NaN, NaN];
    DAC.lagsecpks   = [NaN, NaN];
    DAC.fft.freq    = [];
    DAC.fft.p       = [];   
    DAC.fft.db      = [];
    DAC.fft.df      = NaN;
    DAC.fft.bw      = NaN;
    DAC.env.hhw     = NaN;
    DAC.env.hhwx    = [NaN, NaN];
    DAC.env.halfmax = NaN;
end

%----------------------------------------------------------------------------
function [SXCC, DCC] = CalcAvgAC(Spt1P, Spt1N, Spt2P, Spt2N, Thr, Param)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
Spt1P = anwin(Spt1P, Param.anwin);
Spt1N = anwin(Spt1N, Param.anwin);
Spt2P = anwin(Spt2P, Param.anwin);
Spt2N = anwin(Spt2N, Param.anwin);

if ~isempty(Spt1N) & ~isempty(Spt2N),
    [Ypp1NCo, T, NC] = SPTCORR(Spt1P, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ypp1 = ApplyNorm(Ypp1NCo, NC); Ypp1Rate = ApplyNorm(Ypp1NCo, NC, 'rate');

    [Ynn1NCo, T, NC] = SPTCORR(Spt1N, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ynn1 = ApplyNorm(Ynn1NCo, NC); Ynn1Rate = ApplyNorm(Ynn1NCo, NC, 'rate');
    
    [Ypp2NCo, T, NC] = SPTCORR(Spt2P, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ypp2 = ApplyNorm(Ypp2NCo, NC); Ypp2Rate = ApplyNorm(Ypp2NCo, NC, 'rate');

    [Ynn2NCo, T, NC] = SPTCORR(Spt2N, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ynn2 = ApplyNorm(Ynn2NCo, NC); Ynn2Rate = ApplyNorm(Ynn2NCo, NC, 'rate');
    
    [Ypn1NCo, T, NC] = SPTCORR(Spt1P, Spt1N, Param.cormaxlag, Param.corbinwidth, WinDur); %XAC ...
    Ypn1 = ApplyNorm(Ypn1NCo, NC); Ypn1Rate = ApplyNorm(Ypn1NCo, NC, 'rate');

    [Ynp1NCo, T, NC] = SPTCORR(Spt1N, Spt1P, Param.cormaxlag, Param.corbinwidth, WinDur); %XAC ...
    Ynp1 = ApplyNorm(Ynp1NCo, NC); Ynp1Rate = ApplyNorm(Ynp1NCo, NC, 'rate');

    [Ypn2NCo, T, NC] = SPTCORR(Spt2P, Spt2N, Param.cormaxlag, Param.corbinwidth, WinDur); %XAC ...
    Ypn2 = ApplyNorm(Ypn2NCo, NC); Ypn2Rate = ApplyNorm(Ypn2NCo, NC, 'rate');

    [Ynp2NCo, T, NC] = SPTCORR(Spt2N, Spt2P, Param.cormaxlag, Param.corbinwidth, WinDur); %XAC ...
    Ynp2 = ApplyNorm(Ynp2NCo, NC); Ynp2Rate = ApplyNorm(Ynp2NCo, NC, 'rate');

    Ysac = mean([Ypp1; Ynn1; Ypp2; Ynn2]); YsacRate = mean([Ypp1Rate; Ynn1Rate; Ypp2Rate; Ynn2Rate]);
    Yxac = mean([Ypn1; Ynp1; Ypn2; Ynp2]); YxacRate = mean([Ypn1Rate; Ynp1Rate; Ypn2Rate; Ynp2Rate]);
    Ydifcor = Ysac - Yxac; YdifcorRate = YsacRate - YxacRate;
    
    %Performing spectrum analysis on the DIFCOR. Because a difcor has no DC component in comparison with
    %other correlograms, this almost always results in a representative dominant frequency ...
    FFTdif = spectana(T, Ydifcor, 'RunAvUnit', 'Hz', 'RunAvRange', Param.diffftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum, therefore all
    %magnitude units need to be changed ...
    FFTdif.Magn.P  = FFTdif.Magn.A;
    FFTdif.Magn.A  = sqrt(FFTdif.Magn.A);
    FFTdif.Magn.dB = FFTdif.Magn.dB/2;
    
    %Performing spectrum analysis on the SAC. Because a crosscorrelogram has a DC component this is
    %removed first ...
    FFTsac = spectana(T, detrend(Ysac, 'constant'), 'RunAvUnit', 'Hz', 'RunAvRange', Param.corfftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum, therefore all
    %magnitude units need to be changed ...
    FFTsac.Magn.P  = FFTsac.Magn.A;
    FFTsac.Magn.A  = sqrt(FFTsac.Magn.A);
    FFTsac.Magn.dB = FFTsac.Magn.dB/2;
    
    %Determine which dominant frequency to be used in the calculation ...
    DomFreq = DetermineCalcDF(Param.calcdf, mean(denan(cat(2, Thr.cf))), FFTdif.DF, FFTsac.DF);
    if (DomFreq ~= 0), DomPer = 1000/DomFreq; else, DomPer = NaN; end %Dominant period in ms ...
    
    %Calculating the half height width on the peak of the SAC (relative to asymptote one)...
    HalfMaxSac = ((max(Ysac)-1)/2)+1;
    SacHHWx = cintersect(T, Ysac, HalfMaxSac); SacHHW = abs(diff(SacHHWx));
    
    %Extracting information on secundary peaks in the SCC ...
    [dummy, dummy, SacXsecPeaks, SacYsecPeaks] = GetPeaks(T, Ysac, 0, DomPer);
    
    %Calculating envelope and Half Height Width of DIFCOR ...
    if strcmpi(Param.envrunavunit, 'ms'), EnvRunAvN = round(Param.envrunav/Param.corbinwidth);
    else, EnvRunAvN = round((Param.envrunav*DomPer)/Param.corbinwidth); end 
    Yenv = runav(abs(hilbert(Ydifcor)), EnvRunAvN); 
    HalfMaxEnv = max(Yenv)/2;
    DifHHWx = cintersect(T, Yenv, HalfMaxEnv); DifHHW = abs(diff(DifHHWx));
    
    %Extracting information on secundary peaks in the DIFCOR ...
    [dummy, dummy, DifXsecPeaks, DifYsecPeaks] = GetPeaks(T, Ydifcor, 0, DomPer);
    
    %Reorganizing calculated data ...
    SXCC.lag        = T;
    SXCC.normco     = [Ysac; Yxac];
    [SXCC.max, idx] = max(Ysac);
    SXCC.rate       = max(YsacRate);
    SXCC.lagatmax   = T(idx);
    SXCC.maxsecpks  = SacYsecPeaks;
    SXCC.lagsecpks  = SacXsecPeaks;
    SXCC.hhw        = SacHHW;
    SXCC.hhwx       = SacHHWx;
    SXCC.halfmax    = HalfMaxSac;
    SXCC.fft.freq   = FFTsac.Freq;
    SXCC.fft.p      = FFTsac.Magn.P;   
    SXCC.fft.db     = FFTsac.Magn.dB;
    SXCC.fft.df     = FFTsac.DF;
    SXCC.fft.bw     = FFTsac.BW;
    
    DCC.lag          = T;
    DCC.normco       = [Ydifcor; Yenv; -Yenv];
    [DCC.max, idx]   = max(Ydifcor);
    DCC.rate         = max(YdifcorRate);
    DCC.lagatmax     = T(idx);
    DCC.maxsecpks    = DifYsecPeaks;
    DCC.lagsecpks    = DifXsecPeaks;
    DCC.fft.freq     = FFTdif.Freq;
    DCC.fft.p        = FFTdif.Magn.P;   
    DCC.fft.db       = FFTdif.Magn.dB;
    DCC.fft.df       = FFTdif.DF;
    DCC.fft.bw       = FFTdif.BW;
    [DCC.env.max, idx]= max(Yenv);
    DCC.env.lagatmax = T(idx);
    DCC.env.hhw      = DifHHW;
    DCC.env.hhwx     = DifHHWx;
    DCC.env.halfmax  = HalfMaxEnv;
else,
    warning(sprintf('Calculation of average SAC ony possible if responses of second fiber are supplied,\n or more appropriate for this analysis the response of the same fiber to different noise token.'));

    SXCC.lag        = [];
    SXCC.normco     = [];
    SXCC.max        = NaN
    SXCC.rate       = NaN;
    SXCC.lagatmax   = NaN;
    SXCC.maxsecpks  = [NaN, NaN];
    SXCC.lagsecpks  = [NaN, NaN];
    SXCC.hhw        = NaN;
    SXCC.hhwx       = [NaN, NaN];
    SXCC.halfmax    = NaN;
    SXCC.fft.freq   = NaN;
    SXCC.fft.p      = NaN;   
    SXCC.fft.db     = NaN;
    SXCC.fft.df     = NaN;
    SXCC.fft.bw     = NaN;
    
    DCC.lag          = [];
    DCC.normco       = [];
    DCC.max          = NaN;
    DCC.rate         = NaN;
    DCC.lagatmax     = NaN;
    DCC.maxsecpks    = [NaN, NaN];
    DCC.lagsecpks    = [NaN, NaN];
    DCC.fft.freq     = [];
    DCC.fft.p        = [];   
    DCC.fft.db       = [];
    DCC.fft.df       = NaN;
    DCC.fft.bw       = NaN;
    DCC.env.max      = NaN;
    DCC.env.lagatmax = NaN;
    DCC.env.hhw      = NaN;
    DCC.env.hhwx     = [NaN, NaN];
    DCC.env.halfmax  = NaN;
end

%----------------------------------------------------------------------------
function [SXCC, DCC] = CalcCC(Spt1P, Spt1N, Spt2P, Spt2N, Thr, Param)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
Spt1P = anwin(Spt1P, Param.anwin);
Spt1N = anwin(Spt1N, Param.anwin);
Spt2P = anwin(Spt2P, Param.anwin);
Spt2N = anwin(Spt2N, Param.anwin);

if ~isempty(Spt1N) & ~isempty(Spt2N),
    %Correlation of noise token A+ responses of a cell with the responses of another cell to that same noise
    %token. If spiketrains are derived from different cells this is called a Shuffled Cross-
    %Correlogram (or SCC). 'Shuffled' because of the shuffling of repetitions in order to avoid to correlation
    %of a repetition with itself. The terminolgy CrossCorrelogram is only used when comparing spiketrains 
    %collected from different cells.
    [YppNCo, T, NC] = SPTCORR(Spt1P, Spt2P, Param.cormaxlag, Param.corbinwidth, WinDur); %SCC ...
    Ypp = ApplyNorm(YppNCo, NC); YppRate = ApplyNorm(YppNCo, NC, 'rate');
    %Correlation of noise token A- responses of a cell with the responses of a different cell to that same noise
    %token.
    [YnnNCo, T, NC] = SPTCORR(Spt1N, Spt2N, Param.cormaxlag, Param.corbinwidth, WinDur); %SCC ...
    Ynn = ApplyNorm(YnnNCo, NC); YnnRate = ApplyNorm(YnnNCo, NC, 'rate');
    %Correlation of noise token A+ responses of a cell with the responses of a different cell to a different noise
    %token, in this case A-. Because of the fact that we correlate across stimuli this type of correlogram is 
    %designated XCC.
    [YpnNCo, T, NC] = SPTCORR(Spt1P, Spt2N, Param.cormaxlag, Param.corbinwidth, WinDur); %XCC ...
    Ypn = ApplyNorm(YpnNCo, NC); YpnRate = ApplyNorm(YpnNCo, NC, 'rate');
    %Correlation of noise token A- responses of a cell with the responses of a different cell to a different noise
    %token, in this case A+.
    [YnpNCo, T, NC] = SPTCORR(Spt1N, Spt2P, Param.cormaxlag, Param.corbinwidth, WinDur); %XCC ...
    Ynp = ApplyNorm(YnpNCo, NC); YnpRate = ApplyNorm(YnpNCo, NC, 'rate');
    
    %Calculation of the DIFCOR by taking the average of the two SCCs and the two XCCs and subtracting the second
    %from the first ...
    Yscc = mean([Ypp; Ynn]); YsccRate = mean([YppRate; YnnRate]);
    Yxcc = mean([Ypn; Ynp]); YxccRate = mean([YpnRate; YnpRate]);
    Ydifcor = Yscc - Yxcc; YdifcorRate = YsccRate - YxccRate;
    
    %Performing spectrum analysis on the DIFCOR. Because a difcor has no DC component in comparison with
    %other correlograms, this almost always results in a representative dominant frequency ...
    FFTdif = spectana(T, Ydifcor, 'RunAvUnit', 'Hz', 'RunAvRange', Param.diffftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum, therefore all
    %magnitude units need to be changed ...
    FFTdif.Magn.P  = FFTdif.Magn.A;
    FFTdif.Magn.A  = sqrt(FFTdif.Magn.A);
    FFTdif.Magn.dB = FFTdif.Magn.dB/2;
    
    %Performing spectrum analysis on the SCC. Because a crosscorrelogram has a DC component this is
    %removed first ...
    FFTscc = spectana(T, detrend(Yscc, 'constant'), 'RunAvUnit', 'Hz', 'RunAvRange', Param.corfftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum, therefore all
    %magnitude units need to be changed ...
    FFTscc.Magn.P  = FFTscc.Magn.A;
    FFTscc.Magn.A  = sqrt(FFTscc.Magn.A);
    FFTscc.Magn.dB = FFTscc.Magn.dB/2;
    
    %Determine which dominant frequency to be used in the calculation ...
    DomFreq = DetermineCalcDF(Param.calcdf, mean(denan(cat(2, Thr.cf))), FFTdif.DF, FFTscc.DF);
    if (DomFreq ~= 0), DomPer = 1000/DomFreq; else, DomPer = NaN; end %Dominant period in ms ...
    
    %Calculating the half height width on the peak of the SCC (relative to asymptote one)...
    HalfMaxScc = ((max(Yscc)-1)/2)+1;
    SccHHWx = cintersect(T, Yscc, HalfMaxScc); SccHHW = abs(diff(SccHHWx));
    
    %Extracting information on secundary peaks in the SCC ...
    [dummy, dummy, SccXsecPeaks, SccYsecPeaks] = GetPeaks(T, Yscc, 0, DomPer);
    
    %Calculating envelope and Half Height Width of DIFCOR ...
    if strcmpi(Param.envrunavunit, 'ms'), EnvRunAvN = round(Param.envrunav/Param.corbinwidth);
    else, EnvRunAvN = round((Param.envrunav*DomPer)/Param.corbinwidth); end 
    Yenv = runav(abs(hilbert(Ydifcor)), EnvRunAvN); 
    HalfMaxEnv = max(Yenv)/2;
    DifHHWx = cintersect(T, Yenv, HalfMaxEnv); DifHHW = abs(diff(DifHHWx));
    
    %Extracting information on secundary peaks in the DIFCOR ...
    [dummy, dummy, DifXsecPeaks, DifYsecPeaks] = GetPeaks(T, Ydifcor, 0, DomPer);
    
    %Reorganizing calculated data ...
    SXCC.lag        = T;
    SXCC.normco     = [Yscc; Yxcc];
    [SXCC.max, idx] = max(Yscc);
    SXCC.rate       = max(YsccRate);
    SXCC.lagatmax   = T(idx);
    SXCC.maxsecpks  = SccYsecPeaks;
    SXCC.lagsecpks  = SccXsecPeaks;
    SXCC.hhw        = SccHHW;
    SXCC.hhwx       = SccHHWx;
    SXCC.halfmax    = HalfMaxScc;
    SXCC.fft.freq   = FFTscc.Freq;
    SXCC.fft.p      = FFTscc.Magn.P;   
    SXCC.fft.db     = FFTscc.Magn.dB;
    SXCC.fft.df     = FFTscc.DF;
    SXCC.fft.bw     = FFTscc.BW;
    SXCC.corvec     = YsccRate;
    
    DCC.lag          = T;
    DCC.normco       = [Ydifcor; Yenv; -Yenv];
    [DCC.max, idx]   = max(Ydifcor);
    DCC.rate         = max(YdifcorRate);
    DCC.lagatmax     = T(idx);
    DCC.maxsecpks    = DifYsecPeaks;
    DCC.lagsecpks    = DifXsecPeaks;
    DCC.fft.freq     = FFTdif.Freq;
    DCC.fft.p        = FFTdif.Magn.P;   
    DCC.fft.db       = FFTdif.Magn.dB;
    DCC.fft.df       = FFTdif.DF;
    DCC.fft.bw       = FFTdif.BW;
    [DCC.env.max, idx]= max(Yenv);
    DCC.env.lagatmax = T(idx);
    DCC.env.hhw      = DifHHW;
    DCC.env.hhwx     = DifHHWx;
    DCC.env.halfmax  = HalfMaxEnv;
else,
    %Correlation of noise token A+ responses of a cell with the responses of another cell to that same noise
    %token.
    [YsccNCo, T, NC] = SPTCORR(Spt1P, Spt2P, Param.cormaxlag, Param.corbinwidth, WinDur); %SCC ...
    Yscc = ApplyNorm(YsccNCo, NC); YsccRate = ApplyNorm(YsccNCo, NC, 'Rate');

    %Performing spectrum analysis on the SCC. Because a crosscorrelogram has a DC component this is
    %removed first ...
    FFTscc = spectana(T, detrend(Yscc, 'constant'), 'RunAvUnit', 'Hz', 'RunAvRange', Param.corfftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum, therefore all
    %magnitude units need to be changed ...
    FFTscc.Magn.P  = FFTscc.Magn.A;
    FFTscc.Magn.A  = sqrt(FFTscc.Magn.A);
    FFTscc.Magn.dB = FFTscc.Magn.dB/2;
    
    %Determine which dominant frequency to be used in the calculation ...
    DomFreq = DetermineCalcDF(Param.calcdf, mean(denan(cat(2, Thr.cf))), NaN, FFTscc.DF);
    if (DomFreq ~= 0), DomPer = 1000/DomFreq; else, DomPer = NaN; end %Dominant period in ms ...
    
    %Calculating the half height width on the peak of the SCC (relative to asymptote one)...
    HalfMaxScc = ((max(Yscc)-1)/2)+1;
    SccHHWx = cintersect(T, Yscc, HalfMaxScc); SccHHW = abs(diff(SccHHWx));
    
    %Extracting information on secundary peaks in the SCC ...
    [dummy, dummy, SccXsecPeaks, SccYsecPeaks] = GetPeaks(T, Yscc, 0, DomPer);

    %Reorganizing calculated data ...
    SXCC.lag        = T;
    SXCC.normco     = Yscc;
    [SXCC.max, idx] = max(Yscc);
    SXCC.rate       = max(YsccRate);
    SXCC.lagatmax   = T(idx);
    SXCC.maxsecpks  = SccYsecPeaks;
    SXCC.lagsecpks  = SccXsecPeaks;
    SXCC.hhw        = SccHHW;
    SXCC.hhwx       = SccHHWx;
    SXCC.halfmax    = HalfMaxScc;
    SXCC.fft.freq   = FFTscc.Freq;
    SXCC.fft.p      = FFTscc.Magn.P;   
    SXCC.fft.db     = FFTscc.Magn.dB;
    SXCC.fft.df     = FFTscc.DF;
    SXCC.fft.bw     = FFTscc.BW;
    SXCC.corvec     = YsccRate; 
    
    DCC.lag          = [];
    DCC.normco       = [];
    DCC.max          = NaN;
    DCC.rate         = NaN;
    DCC.lagatmax     = NaN;
    DCC.maxsecpks    = [NaN, NaN];
    DCC.lagsecpks    = [NaN, NaN];
    DCC.fft.freq     = [];
    DCC.fft.p        = [];   
    DCC.fft.db       = [];
    DCC.fft.df       = NaN;
    DCC.fft.bw       = NaN;
    DCC.env.max      = NaN;
    DCC.env.lagatmax = NaN;
    DCC.env.hhw      = NaN;
    DCC.env.hhwx     = [NaN, NaN];
    DCC.env.halfmax  = NaN;
end

%----------------------------------------------------------------------------
function Y = ApplyNorm(Y, N, NormStr)

if (nargin == 2), NormStr = 'dries'; end

switch lower(NormStr),
case 'dries',
    if ~all(Y == 0), Y = Y/N.DriesNorm;
    else, Y = ones(size(Y)); end
case 'rate',
    Y = 1e3*Y/N.NF;
end

%----------------------------------------------------------------------------
function DF = DetermineCalcDF(ParamCalcDF, ThrCF, DifDF, SacDF)

if isnumeric(ParamCalcDF),
    if ~isnan(ParamCalcDF), DF = ParamCalcDF;
    elseif ~isnan(DifDF), DF = DifDF;
    elseif ~isnan(SacDF), DF = SacDF;
    else, DF = ThrCF; end
elseif strcmpi(ParamCalcDF, 'cf'), DF = ThrCF;
elseif strcmpi(ParamCalcDF, 'df'), 
    if ~isnan(DifDF), DF = DifDF;
    else, DF = SacDF; end    
else, DF = NaN; end                

%----------------------------------------------------------------------------
function PlotData(SXAC, DAC, SXCC, DCC, Thr, RC, Info, StimParam, Param)

%Creating figure ...
FigHdl = figure('Name', sprintf('%s: %s', upper(mfilename), Info.capstr), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'portrait');

%Plot header ...
Str = { Info.hdrstr, sprintf('\\rm\\fontsize{9}Created by %s @ %s', upper(mfilename), datestr(now))};
AxHDR = axes('Position', [0.05 0.90 0.90 0.10], 'Visible', 'off');
text(0.5, 0.5, Str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', 12);

%Plotting correlation functions ...
PlotAutoCorFnc([0.0, 0.50, 0.5, 0.45], SXAC(1), DAC(1), Param);
PlotAutoCorFnc([0.5, 0.50, 0.5, 0.45], SXAC(2), DAC(2), Param);
PlotCrossCorFnc([0.0, 0.0, 0.5, 0.45], SXCC, DCC, Param);

%Display general information ...
PlotGenInfo([0.5, 0.0, 0.5, 0.45], Info, Thr, RC, StimParam, Param);

%----------------------------------------------------------------------------
function PlotAutoCorFnc(ViewPort, SXAC, DAC, Param)

%General plot parameters ...
TitleFontSz  = 9;    %in points ...
LabelFontSz  = 7;    %in points ...
TckMrkFontSz = 7;    %in points ...
VerMargin    = 0.10; %in percent ...
HorMargin    = 0.15; %in percent ...
VerAxSpacing = 0.10; %in percent ...

Width     = ViewPort(3)*(1-2*HorMargin);
Height    = ViewPort(4)*(1-2*VerMargin-2*VerAxSpacing);
AxSpacing = ViewPort(4)*VerAxSpacing;
Origin    = ViewPort(1:2)+[Width*HorMargin, Height*VerMargin];

%Normalisation Coincidence count ...
NormStr = sprintf('Norm. Count\n(N_{rep}*(N_{rep}-1)*r^2*\\Delta\\tau*D)');

%Plotting SAC and if possible XAC ...
X = SXAC.lag; Y = SXAC.normco;
[MinX, MaxX, XTicks] = GetAxisLim('X', X, Param.corxrange, Param.corxstep);
Pos = [Origin(1), Origin(2)+2*AxSpacing+(0.25+0.375)*Height, Width, Height*0.375];
AxCOR = axes('Position', Pos, 'Box', 'off', 'TickDir', 'out', 'FontSize', TckMrkFontSz);
if (size(Y, 1) == 1),
    LnHdl = line(X, Y, 'LineStyle', '-', 'Marker', 'none', 'LineWidth', 2, 'Color', 'b');
    title('SAC', 'FontSize', TitleFontSz);
else,
    LnHdl = line(X, Y, 'LineStyle', '-', 'Marker', 'none'); 
    set(LnHdl(1), 'LineWidth', 2, 'Color', 'b'); set(LnHdl(2), 'LineWidth', 0.5, 'Color', 'g');
    title('SAC and XAC', 'FontSize', TitleFontSz);
    LgHdl = legend({'SAC', 'XAC'}, 1);
    set(findobj(LgHdl, 'type', 'text'), 'FontSize', LabelFontSz);
end
TxtStr =  {sprintf('Max(SAC): %.2f', SXAC.max), sprintf('HHW(SAC): %.2fms', SXAC.hhw)};
xlabel('Delay(ms)', 'FontSize', LabelFontSz); ylabel(NormStr, 'Units', 'normalized', 'Position', [-0.11, 0.5, 0], 'FontSize', LabelFontSz);
set(AxCOR, 'XLim', [MinX MaxX], 'XTick', XTicks); 
YRange = get(AxCOR, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
LnHdl = PlotCInterSect(SXAC.hhwx, SXAC.halfmax([1 1]), MinY);
set(LnHdl(1), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
PlotVerZero(MinY, MaxY);
text(MinX, MaxY, TxtStr, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', LabelFontSz);

%Plotting DIFCOR ...
Pos = [Origin(1), Origin(2)+AxSpacing+0.25*Height, Width, Height*0.375];
if isempty(DAC.lag), AxDIF = CreateEmptyAxis(Pos, LabelFontSz);
else,
    X = DAC.lag; Y = DAC.normco; 
    AxDIF = axes('Position', Pos, 'Box', 'off', 'TickDir', 'out', 'FontSize', TckMrkFontSz);
    LnHdl = line(X, Y); 
    set(LnHdl(1), 'LineStyle', '-', 'Color', [1 0 0], 'LineWidth', 2);
    set(LnHdl(2), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    set(LnHdl(3), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    title('DIFCOR', 'FontSize', TitleFontSz);
    xlabel('Delay(ms)', 'FontSize', LabelFontSz); ylabel(NormStr, 'Units', 'normalized', 'Position', [-0.11, 0.5, 0], 'FontSize', LabelFontSz);
    set(AxDIF, 'XLim', [MinX MaxX], 'XTick', XTicks);  
    YRange = get(AxDIF, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
    PlotVerZero(MinY, MaxY); PlotHorZero(MinX, MaxX);
    LnHdl = PlotCInterSect(DAC.env.hhwx, DAC.env.halfmax([1 1]), MinY);
    set(LnHdl(1), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    text(MinX, MaxY, {sprintf('Max(DIF): %.2f', DAC.max), sprintf('HHW(ENV): %.2fms', DAC.env.hhw)},'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', LabelFontSz);
end

%Plotting discrete fourier transform of DIFCOR or SAC...
Pos = [Origin(1), Origin(2), Width, 0.25*Height];
if isempty(DAC.lag), FFT = SXAC.fft; TitleStr = 'DFT on SAC';
else, FFT = DAC.fft; TitleStr = 'DFT on DIFCOR'; end
X = FFT.freq;
if strcmpi(Param.fftyunit, 'dB'), Y = FFT.db; YLblStr = 'Power (dB, 10 log)'; 
else, Y = FFT.p; YLblStr = 'Power'; end
if ~isnan(FFT.df),
    Ord = floor(log10(FFT.df*2))-1;
    MinX = 0; MaxX = round(FFT.df*2*10^-Ord)*10^Ord;
    XTicks = 'auto';
else, [MinX, MaxX, XTicks] = GetAxisLim('X', X, Param.fftxrange, Param.fftxstep); end    
[MinY, MaxY] = GetAxisLim('Y', Y, Param.fftyrange);
AxDFT = axes('Position', Pos, 'Box', 'off', 'TickDir', 'out', 'FontSize', TckMrkFontSz);
LnHdl = line(X, Y);
set(LnHdl(2), 'LineStyle', '-', 'Color', 'b', 'LineWidth', 0.5);
set(LnHdl(1), 'LineStyle', ':', 'Color', 'k', 'LineWidth', 0.5);
title(TitleStr, 'FontSize', TitleFontSz);
xlabel('Freq(Hz)', 'FontSize', LabelFontSz); ylabel(YLblStr, 'FontSize', LabelFontSz);
if ~ischar(XTicks), set(AxDFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY], 'XTick', XTicks); 
else, set(AxDFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY]); end    
YRange = get(AxDFT, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
line(FFT.df([1,1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %Vertical line at dominant frequency ...
text(MinX, MaxY, {sprintf('DomFreq: %.2fHz', FFT.df), sprintf('BandWidth: %.2fHz', FFT.bw)},'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', LabelFontSz);
legend({'Orig', 'RunAv'}, 1);

%----------------------------------------------------------------------------
function PlotCrossCorFnc(ViewPort, SXCC, DCC, Param)

%General plot parameters ...
TitleFontSz  = 9;    %in points ...
LabelFontSz  = 7;    %in points ...
TckMrkFontSz = 7;    %in points ...
VerMargin    = 0.10; %in percent ...
HorMargin    = 0.15; %in percent ...
VerAxSpacing = 0.10; %in percent ...

Width     = ViewPort(3)*(1-2*HorMargin);
Height    = ViewPort(4)*(1-2*VerMargin-2*VerAxSpacing);
AxSpacing = ViewPort(4)*VerAxSpacing;
Origin    = ViewPort(1:2)+[Width*HorMargin, Height*VerMargin];

%Normalisation Coincidence count ...
NormStr = sprintf('Norm. Count\n(N_{rep}*(N_{rep}-1)*r^2*\\Delta\\tau*D)');

%Plotting SCC and if possible XCC ...
X = SXCC.lag; Y = SXCC.normco;
[MinX, MaxX, XTicks] = GetAxisLim('X', X, Param.corxrange, Param.corxstep);
Pos = [Origin(1), Origin(2)+2*AxSpacing+(0.25+0.375)*Height, Width, Height*0.375];
AxCOR = axes('Position', Pos, 'Box', 'off', 'TickDir', 'out', 'FontSize', TckMrkFontSz);
if (size(Y, 1) == 1),
    LnHdl = line(X, Y, 'LineStyle', '-', 'Marker', 'none', 'LineWidth', 2, 'Color', 'b');
    title('SCC', 'FontSize', TitleFontSz);
else,
    LnHdl = line(X, Y, 'LineStyle', '-', 'Marker', 'none'); 
    set(LnHdl(1), 'LineWidth', 2, 'Color', 'b'); set(LnHdl(2), 'LineWidth', 0.5, 'Color', 'g');
    title('SCC and XCC', 'FontSize', TitleFontSz);
    LgHdl = legend({'SCC', 'XCC'}, 1);
    set(findobj(LgHdl, 'type', 'text'), 'FontSize', LabelFontSz);
end
TxtStr =  {sprintf('Max(SCC): %.2f @ %.2fms', SXCC.max, SXCC.lagatmax), sprintf('HHW(SCC): %.2fms', SXCC.hhw)};
xlabel('Delay(ms)', 'FontSize', LabelFontSz); ylabel(NormStr, 'Units', 'normalized', 'Position', [-0.11, 0.5, 0], 'FontSize', LabelFontSz);
set(AxCOR, 'XLim', [MinX MaxX], 'XTick', XTicks); 
YRange = get(AxCOR, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
LnHdl = PlotCInterSect(SXCC.hhwx, SXCC.halfmax([1 1]), MinY);
set(LnHdl(1), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
line(SXCC.lagatmax([1 1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');
line(SXCC.lagatmax, SXCC.max, 'Color', [0 0 0], 'LineStyle', 'none', 'marker', '.');
line(SXCC.lagsecpks([1 1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');
line(SXCC.lagsecpks([2 2]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');
line(SXCC.lagsecpks, SXCC.maxsecpks, 'Color', [0 0 0], 'LineStyle', 'none', 'marker', '.');
PlotVerZero(MinY, MaxY);
text(MinX, MaxY, TxtStr, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', LabelFontSz);

%Plotting DIFCOR ...
Pos = [Origin(1), Origin(2)+AxSpacing+0.25*Height, Width, Height*0.375];
if isempty(DCC.lag), AxDIF = CreateEmptyAxis(Pos, LabelFontSz);
else,
    X = DCC.lag; Y = DCC.normco; 
    AxDIF = axes('Position', Pos, 'Box', 'off', 'TickDir', 'out', 'FontSize', TckMrkFontSz);
    LnHdl = line(X, Y); 
    set(LnHdl(1), 'LineStyle', '-', 'Color', [1 0 0], 'LineWidth', 2);
    set(LnHdl(2), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    set(LnHdl(3), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    title('DIFCOR', 'FontSize', TitleFontSz);
    xlabel('Delay(ms)', 'FontSize', LabelFontSz); ylabel(NormStr, 'Units', 'normalized', 'Position', [-0.11, 0.5, 0], 'FontSize', LabelFontSz);
    set(AxDIF, 'XLim', [MinX MaxX], 'XTick', XTicks);  
    YRange = get(AxDIF, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
    PlotVerZero(MinY, MaxY); PlotHorZero(MinX, MaxX);
    LnHdl = PlotCInterSect(DCC.env.hhwx, DCC.env.halfmax([1 1]), MinY);
    set(LnHdl(1), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    line(DCC.lagatmax, DCC.max, 'Color', [0 0 0], 'LineStyle', 'none', 'marker', '.');
    line(DCC.lagatmax([1 1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');
    line(DCC.lagsecpks([1 1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');
    line(DCC.lagsecpks([2 2]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');
    line(DCC.lagsecpks, DCC.maxsecpks, 'Color', [0 0 0], 'LineStyle', 'none', 'marker', '.');
    text(MinX, MaxY, {sprintf('Max(DIF): %.2f @ %.2fms', DCC.max, DCC.lagatmax), ...
            sprintf('SecPks(DIF): @ %.2fms & %.2fms', DCC.lagsecpks), ...
            sprintf('Max(ENV):  %.2f @ %.2fms', DCC.env.max, DCC.env.lagatmax), ...
            sprintf('HHW(ENV): %.2fms', DCC.env.hhw)},'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', LabelFontSz);
end

%Plotting discrete fourier transform of DIFCOR or SAC...
Pos = [Origin(1), Origin(2), Width, 0.25*Height];
if isempty(DCC.lag), FFT = SXCC.fft; TitleStr = 'DFT on SCC';
else, FFT = DCC.fft; TitleStr = 'DFT on DIFCOR'; end
X = FFT.freq;
if strcmpi(Param.fftyunit, 'dB'), Y = FFT.db; YLblStr = 'Power (dB, 10 log)'; 
else, Y = FFT.p; YLblStr = 'Power'; end
if ~isnan(FFT.df),
    Ord = floor(log10(FFT.df*2))-1;
    MinX = 0; MaxX = round(FFT.df*2*10^-Ord)*10^Ord;
    XTicks = 'auto';
else, [MinX, MaxX, XTicks] = GetAxisLim('X', X, Param.fftxrange, Param.fftxstep); end    
[MinY, MaxY] = GetAxisLim('Y', Y, Param.fftyrange);
AxDFT = axes('Position', Pos, 'Box', 'off', 'TickDir', 'out', 'FontSize', TckMrkFontSz);
LnHdl = line(X, Y);
set(LnHdl(2), 'LineStyle', '-', 'Color', 'b', 'LineWidth', 0.5);
set(LnHdl(1), 'LineStyle', ':', 'Color', 'k', 'LineWidth', 0.5);
title(TitleStr, 'FontSize', TitleFontSz);
xlabel('Freq(Hz)', 'FontSize', LabelFontSz); ylabel(YLblStr, 'FontSize', LabelFontSz);
if ~ischar(XTicks), set(AxDFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY], 'XTick', XTicks); 
else, set(AxDFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY]); end    
YRange = get(AxDFT, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
line(FFT.df([1,1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %Vertical line at dominant frequency ...
text(MinX, MaxY, {sprintf('DomFreq: %.2fHz', FFT.df), sprintf('BandWidth: %.2fHz', FFT.bw)},'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', LabelFontSz);
legend({'Orig', 'RunAv'}, 1);

%----------------------------------------------------------------------------
function PlotGenInfo(ViewPort, Info, Thr, RC, StimParam, Param)

AxINF = axes('Position', ViewPort, 'Visible', 'off');
text(0.50, 0.95, Info.hdrstr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'demi', 'FontSize', 9);

text(0.05, 0.75, char(Thr(1).str, '', RC(1).str), 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);
text(0.55, 0.75, char(Thr(2).str, '', RC(2).str), 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);

text(0.00, 0.40, {'Stimulus parameters:', 'A^+_1, A^-_1, A^+_2, A^-_2'},'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'demi', 'FontSize', 9);
text(0.05, 0.25, StimParam.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);

text(0.50, 0.50, 'Calculation parameters:','Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'demi', 'FontSize', 9);
text(0.55, 0.30, Param.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);

%----------------------------------------------------------------------------
function [MinVal, MaxVal, Ticks] = GetAxisLim(AxisType, Values, Range, Step)

if strcmpi(AxisType, 'x'), %Abcissa ...
    Margin = 0.00;
    
    if isinf(Range(1)), MinVal = min(Values(:))*(1-Margin); else MinVal = Range(1); end
    if isinf(Range(2)), MaxVal = max(Values(:))*(1+Margin); else MaxVal = Range(2); end
    Ticks = MinVal:Step:MaxVal;
else, %Ordinate ...    
    Margin = 0.05;
    
    if isinf(Range(1)), MinVal = min([0; Values(:)])*(1-Margin); else MinVal = Range(1); end
    if isinf(Range(2)), MaxVal = max(Values(:))*(1+Margin); else MaxVal = Range(2); end
end

%----------------------------------------------------------------------------
function PlotVerZero(MinY, MaxY)

line([0, 0], [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');

%----------------------------------------------------------------------------
function PlotHorZero(MinX, MaxX)

line([MinX, MaxX], [0, 0], 'Color', [0 0 0], 'LineStyle', ':');

%----------------------------------------------------------------------------
function AxHdl = CreateEmptyAxis(Pos, FontSz)

%Create axis object ... 
AxHdl = axes('Position', Pos, 'Box', 'on', 'Color', [0.8 0.8 0.8], 'Units', 'normalized', ...
    'YTick', [], 'YTickLabel', [], 'XTick', [], 'XTickLabel', []);

%Create Text object ...
TxtHdl = text(0.5, 0.5, sprintf('No plot to be\ngenerated'));
set(TxtHdl, 'VerticalAlignment', 'middle', ...
             'HorizontalAlignment', 'center', ...
             'Color', 'k', ...
             'FontAngle', 'normal', ...
             'FontSize', FontSz, ...
             'FontWeight', 'normal');
         
%----------------------------------------------------------------------------        