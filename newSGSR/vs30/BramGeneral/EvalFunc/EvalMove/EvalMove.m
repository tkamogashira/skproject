function ArgOut = EvalMove(varargin)
%EVALMOVE   evaluate moving binaural noise (MOV) dataset.
%   EVALMOVE(ds) evaluates the moving binaural noise responses in dataset ds.
%   EVALMOVE(ds, iSubSeqs) evaluates the responses only for the specified
%   subsequences of the supplied dataset ds.
%   EVALMOVE('factory') prints factory defaults
%   D = EVALMOVE(ds) returns the results in structure D.
%   EVALMOVE(ds, ITDbgn, ITDrate, ITDend) for an SGSR dataset.
%
%   E.g.
%     Madison datasets:
%       ds = dataset('R00001', '41-12-MOV1');
%       dsntd = dataset('R00001', '41-6-NITD+');
%       EvalMOVE(ds, 'nitdds', dsntd);
%
%       ds = dataset('R98076', '30-11-MOV3');
%       dsntd = dataset('R98076', '30-7-NITD+');
%       EvalMOVE(ds, 'nitdds', dsntd);
%
%       ds = dataset('R00001', '19-19-MOV4');
%       EvalMOVE(ds);
%
%     SGSR dataset with ITDbegin 600, ITDrate
%       ds=dataset('MOVEtest','1-1-WAV-movLR');
%       EvalMOVE(ds, 600, 200, 6000);
% 
%   Examples of parameter dynanwin:
%     'dynanwin', 'stimdur' (default)
%     'dynanwin', [10, 70]
%     'dynanwin', [10, 70; 15, 75; 13, 65]
%     'dynanwin', {10, 'stimdur'}
%     'dynanwin', {10, '0.8*stimdur'}
%     'dynanwin', {10, 'stimdur'; 15, 'stimdur'; 13, 'stimdur'}
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value,
%   use 'factory' as only input argument.

% B. Van de Sande 14-08-2005
% Edited by Ramses de Norre

%% Template
Template = EvalMove_getTemplate;

%% default parameters
%... Syntax parameters ...
DefParam.subseqinput  = 'subseq';    %'subseq' or 'indepval' ...

%... Calculation parameters ...
DefParam.nitdds       = dataset;     %dataset with noise delay function ...
%The analyis window for the noise delay function must be given as a numerical
%vector with an even number of elements, each pair representing a time-interval
%to be included in the analysis. Some shortcuts for the analysis window are
%allowed. These are 'burstdur' and 'stimdur' for a window from zero to the
%stimulus duration and 'repdur' for a window from zero to the repetition
%duration ...
DefParam.ndfncanwin   = 'stimdur';
DefParam.pbratecor    = 'yes';       %'yes' or 'no' (playback rate correction)
DefParam.binmode      = 'itd';       %'itd' or 'stmdur' ...
DefParam.binwidth     = 50;          %in microsec or millisec ...
DefParam.nbin         = NaN;         %in # ...
DefParam.runav        = 0;
DefParam.runavunit    = '#';         %in '#' or 'mus'(miscroseconds) ...
%ITD range over which the general calculations are performed can be specified
%as a two element cell-array of strings containing expressions with the field-
%names 'minitd' and 'maxitd' or it can be a two-element numerical vector.
DefParam.calcitdrng   = {'round($minitd$+0.10*abs($maxitd$-$minitd$))', ...
    'round($maxitd$-0.10*abs($maxitd$-$minitd$))'};
DefParam.corrbinwidth = 10;          %in microsecs ...
DefParam.cmppstnbin   = 5;           %in # ...
DefParam.cmppstanwin  = {'0', 'round(min($stimdur$))'};
DefParam.effsplcf     = NaN;         %in Hz, NaN (automatic) 'cf' or 'df' ...
DefParam.effsplbw     = 1/3;         %in octaves ...

%... Plot parameters ...
DefParam.plot         = 'yes';       %'yes' or 'no' ...
DefParam.plottype     = 'color';     %'color' or 'b&w' ...
DefParam.dbg          = 'no';        %'yes' or 'no' ...
DefParam.xlim         = [-Inf +Inf]; %in microsec ...
DefParam.ylim         = [-Inf +Inf]; %in microsec ...
DefParam.corrnorm     = 'Coeff';     %as in xcorr.m: 'biased', 'unbiased',
                                       %'coeff' or 'none'
DefParam.corrrng      = [-500 +500];

DefParam.dynanwin     = 'stimdur';   % anwin for mov1

DefParam.mov3nbin     = NaN; % TODO, not yet implemented

DefParam.splitMultipleSubsets = false; % if true, put every subset in a seperate
                                % struct in the final struct array output, if
                                % false, the output is one struct with
                                % output

%% main program
%% Evaluate input arguments, giving 'factory' as only argument shows the
%  factory defaults
if (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'factory')
    disp('Properties and their factory defaults:');
    disp(DefParam);
    return
else
    [ds, iSubSeqs, Param, DSParam, StimParam] = ...
        EvalMove_parseArgs(DefParam, varargin{:});
end

%% Retrieving data from SGSR server ...
try
    UD = getuserdata(ds.filename, ds.icell);
    if isempty(UD)
        error('To catch block ...');
    end
    if ~isempty(UD.CellInfo) && ~isnan(UD.CellInfo.THRSeq)
        dsTHR = dataset(ds.filename, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        Str = {sprintf('\\bfThreshold curve:\\rm \\it%s <%s>\\rm', dsTHR.FileName, dsTHR.seqID); ...
            sprintf('\\itCF:\\rm %s @ %s', EvalMove_param2Str(CF, 'Hz', 0), EvalMove_param2Str(Thr, 'dB', 0)); ...
            sprintf('\\itSR:\\rm %s', EvalMove_param2Str(SR, 'spk/sec', 1)); ...
            sprintf('\\itBW:\\rm %s', EvalMove_param2Str(BW, 'Hz', 1)); ...
            sprintf('\\itQ10:\\rm %s', EvalMove_param2Str(Q10, '', 1))};
        Thr = lowerfields(CollectInStruct(CF, SR, Thr, BW, Q10, Str));
    else
        Thr = struct([]);
    end

    %Rate curve information ...
    if isfield(UD.CellInfo, 'RCNTHR')
        RCN.Thr = UD.CellInfo.RCNTHR;
    else
        RCN = struct([]);
    end
catch
    warning('%s\nAdditional information from SGSR server is not included.',...
        lasterr);
    Thr = struct([]);
    RCN = struct([]);
end

%% Perform actual calculation ...
CalcData = EvalMove_calcCurve(ds, iSubSeqs, StimParam, Param);

%Calculating effective SPL ...
FilterBW = Param.effsplbw;
if ~isempty(Thr)
    FilterCF = EvalMove_determineCF(Param.effsplcf, Thr.cf, NaN, NaN);
else
    FilterCF = EvalMove_determineCF(Param.effsplcf, NaN, NaN, NaN);
end

if isnan(FilterCF)
    warning('Calculating overall effective SPL, because center frequency for filter cannot be extracted.');
    [FilterCF, FilterBW] = deal([]);
end

try
    StimParam.effspl = CalcEffSPL(ds, 'filtercf', FilterCF, 'filterbw', FilterBW, 'channel', 'avg');
    StimParam.effspl = StimParam.effspl(iSubSeqs);
    if (length(unique(StimParam.effspl)) == 1)
        StimParam.effspl = StimParam.effspl(1);
    end
catch
    warning(lasterr);
    StimParam.effspl = NaN;
end

StimParam.str = [StimParam.str; ...
    {sprintf('\\itEffSPL:\\rm %s', EvalMove_param2Str(unique(StimParam.effspl), 'dB', 0))}];

%% Display data ...
if strcmpi(Param.plot, 'yes')
    EvalMove_PlotCurve(CalcData, DSParam, StimParam, Param, Thr);
end

R = CalcRATE(ds);
CalcData.spkrate = R.curve.rate';

%% Return output if requested ...
if (nargout >= 1)
    [CalcData.ds1, CalcData.param, CalcData.stim, CalcData.thr, CalcData.RCN] = ...
        deal(ds, Param, StimParam, Thr, RCN);
    if ~isvoid(Param.nitdds)
        CalcData.dsntd = Param.nitdds;
    end

    if ~isempty(CalcData.ndfnc)
        CalcData.ntd.maxrate          = CalcData.ndfnc.maxrate;
        CalcData.ntd.itdatmax         = CalcData.ndfnc.itdatmax;
    else
        CalcData.ntd.maxrate          = NaN;
        CalcData.ntd.itdatmax         = NaN;
    end

    histAggregateStruct = structaggregate(CalcData.hist, {'cat(1, $maxn$)', ...
        'cat(1, $maxrate$)', 'cat(1, $bcatmax$)', 'cat(1, $minn$)', ...
        'cat(1, $minrate$)', 'cat(1, $bcatmin$)', 'cat(1, $moddepth$)'}, ...
        'aggrfnames', {'maxn', 'maxrate', 'bcatmax', 'minn', 'minrate', ...
        'bcatmin', 'moddepth'});
    histAggregateStruct.bc = {CalcData.hist(:).bc};
    histAggregateStruct.rate = {CalcData.hist(:).rate};
    CalcData.hist = histAggregateStruct;
    ArgOut = structtemplate(CalcData, Template, 'reduction', 'off');
    
    if Param.splitmultiplesubsets
        [flatOut, outNames] = destruct(ArgOut);
        vectorIdx = [10,22:39];
        
        outputData = cell(length(iSubSeqs), length(flatOut));
        ArgOutArray = cell(1,length(iSubSeqs));
        for n = 1:length(iSubSeqs)
            for nn = 1:length(flatOut)
                if ~isempty(find(vectorIdx==nn, 1))
                    if isa(flatOut{nn}, 'cell')
                        outputData{n,nn} = flatOut{nn}{n};
                    else
                        outputData{n,nn} = flatOut{nn}(n);
                    end
                else
                    outputData{n,nn} = flatOut{nn};
                end
            end
            ArgOutArray{n} = construct(outputData(n,:), outNames);
            ArgOut = [ArgOutArray{:}]; % convert to struct array
        end
    end
end

%--------------------------------------------------------------------------------