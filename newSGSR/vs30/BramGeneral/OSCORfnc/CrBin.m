function dsCorr = CrBin(varargin)
%CRBIN   create binaural dataset.
%   ds = CRBIN(ds) creates binaural dataset object from a dataset containing
%   auditory nerve (AN) responses to oscillating correlation (OSCOR) noise at
%   different modulation frequency via a coincidence model for the IC.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   All calculations are cached. To clear the current cache use 'clrcache' 
%   as only input argument.
%
%   See also TIMEWARP

%B. Van de Sande 04-04-2005

%---------------------------------parameters----------------------------------
DefParam.cache      = 'yes'; %'yes' or 'no' ...
DefParam.cowindow   = 0.050; %Coincidence-window in microseconds ...
DefParam.refnoise   = 'all'; %Reference noise token. 'all' designates using all
                             %available reference noise tokens ...
DefParam.timewarp   = 'yes'; %'yes' or 'no' ...

%--------------------------------main program---------------------------------
%Evaluate input arguments ...
if (nargin < 1), error('Wrong number of input arguments');
elseif (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
elseif (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'clrcache'),
    emptycachefile(mfilename);
    return;
else, ds = varargin{1}; end
%Check supplied dataset ...
if ~strcmp(ds.FileFormat, 'MADDATA'), error('Dataset doesn''t contain Madison-data.'); end
if ~any(strcmp(ds.StimType, {'OSCR', 'OSCRCTL', 'NSPL', 'OSCRTD', 'BB'})), error('Dataset doesn''t contain OSCOR-related data.'); end
if ~strcmp(ds.StimParam.MasterDSS.GWID, '+A,+B,-A,-B,AB1,AB2,AB5,AB10,AB20,AB50,AB75,AB100,AB150,AB200,AB300,AB400,AB500,AB750,AB1000'), error('Dataset doesn''t contain AN-data.'); end
if (ds.nsubrecorded < 5), error('No data enough data collected for correlation.'); end
%Check properties and their values ...
Param = checkproplist(DefParam, varargin{2:end});
Param = CheckParam(Param);

if strncmpi(Param.cache, 'y', 1), %Caching system ...
    SearchParam = structcat(struct('filename', ds.FileName, 'seqid', ds.SeqID), ...
        getfields(Param, {'cowindow', 'timewarp', 'refnoise'}));
    dsCorr = FromCacheFile(mfilename, SearchParam); %Retrieve data from cache ...
    if ~isempty(dsCorr), fprintf('Data retrieved from cache ...\n');
    else, %Perform actual calculation ...
        dsCorr = CreateModelds(ds, Param);
        %Saving calulated data in cache ...
        ToCacheFile(mfilename, +1000, SearchParam, dsCorr);
        fprintf('Data written to cache ...\n');
    end
else, dsCorr = CreateModelds(ds, Param); end %Perform actual calculation ...

%--------------------------------local functions------------------------------
function Param = CheckParam(Param)

if ~isnumeric(Param.cowindow) | (length(Param.cowindow) ~= 1) | (Param.cowindow <= 0), 
    error('Property ''cowindow'' can only have a positive integer as value.'); 
end
if ~ischar(Param.cache) | ~any(strncmpi(Param.cache, {'y', 'n'}, 1)), 
    error('Property ''cache'' must be ''yes'' or ''no''.'); 
end
if ~ischar(Param.timewarp) | ~any(strncmpi(Param.timewarp, {'y', 'n'}, 1)), 
    error('Property ''timewarp'' must be ''yes'' or ''no''.'); 
end
if ~ischar(Param.refnoise) | ~any(strcmpi(Param.refnoise, {'+a', '-a', '+b', '-b', 'ab1', 'all'})), 
    error('Property ''refnoise'' must be ''+a'', ''-a'', ''+b'', ''-b'' or ''all''.'); 
end

%-----------------------------------------------------------------------------
function dsOut = CreateModelds(dsIn, Param)

OscorGWID = {'AB1';'AB2';'AB5';'AB10';'AB20';'AB50';'AB75';'AB100';'AB150';'AB200';'AB300';'AB400';'AB500';'AB750';'AB1000'};

if strcmpi(Param.refnoise, 'all'),
    %Extract relevant information from dataset ...
    Nrec = dsIn.nrec;
    SptAp = dsIn.spt(find(strcmpi({'+a', '+b', '-a', '-b'}, '+a')), :);
    SptAn = dsIn.spt(find(strcmpi({'+a', '+b', '-a', '-b'}, '-a')), :);
    SptBp = dsIn.spt(find(strcmpi({'+a', '+b', '-a', '-b'}, '+b')), :);
    SptBn = dsIn.spt(find(strcmpi({'+a', '+b', '-a', '-b'}, '-b')), :);
    SptAB = dsIn.spt(5:Nrec, :);
    
    %Correlation ...
    SptApAB = Correlate(SptAp, SptAB, Param.cowindow);
    SptAnAB = Correlate(SptAn, SptAB, Param.cowindow);
    SptBpAB = Correlate(SptBp, SptAB, Param.cowindow);
    SptBnAB = Correlate(SptBn, SptAB, Param.cowindow);
    
    %Assembling spiketimes ...
    SptCorr = [SptApAB; SptAnAB; SptBpAB; SptBnAB];
    Nsub = 4*(Nrec - 4); Nrep = dsIn.Sizes.Nrep^2;
    IndepVal = repmat(reshape(dsIn.Stimulus.IndepVar.Values(5:Nrec), Nrec-4, 1), 4, 1);
    MasterGWID = [repmat({'+A'}, Nrec-4, 1); repmat({'-A'}, Nrec-4, 1); repmat({'+B'}, Nrec-4, 1); repmat({'-B'}, Nrec-4, 1)];
    SlaveGWID  = repmat(OscorGWID(1:(Nrec-4)), 4, 1);
else,    
    %Extract relevant information from dataset ...    
    Nrec = dsIn.nrec;
    SptRef   = dsIn.spt(find(strcmpi({'+a', '+b', '-a', '-b', 'ab1'}, Param.refnoise)), :);
    SptOscor = dsIn.spt(5:Nrec, :);
    
    %Perform actual correlation ...
    if strcmpi(Param.refnoise, 'ab1'),
        SptCorr(1, :) = CorrelateNoDiag(SptRef, SptOscor(1, :), Param.cowindow);
        SptCorr(2:(Nrec-4), :) = Correlate(SptRef, SptOscor(2:(Nrec-4), :), Param.cowindow);
    else, SptCorr = Correlate(SptRef, SptOscor, Param.cowindow); end
    
    %Assembling information ...
    Nsub = Nrec - 4; Nrep = dsIn.Sizes.Nrep^2;
    IndepVal = dsIn.Stimulus.IndepVar.Values(5:Nrec);
    MasterGWID = repmat({upper(Param.refnoise)}, Nsub, 1);
    SlaveGWID  = OscorGWID(1:Nsub);
end

%Create dataset ...
S = struct(dsIn);

S.Sizes.Nsub                        = Nsub;
S.Sizes.NsubRecorded                = Nsub; %CAVE ...
S.Sizes.Nrep                        = Nrep;
S.Data.SpikeTimes                   = SptCorr;
S.Stimulus.IndepVar.Values          = IndepVal;
S.Stimulus.StimParam.MasterDSS.GWID = MasterGWID;
S.Stimulus.StimParam.SlaveDSS.DSSNr = 2;
S.Stimulus.StimParam.SlaveDSS.GWID  = SlaveGWID;

dsOut = dataset(S, 'convert');

%Timewarp the resulting dataset if requested ...
if strncmpi(Param.timewarp, 'y', 1),
    warning(sprintf('%s is being timewarped. This may take a while.', dsOut.title));
    dsOut = timewarp(dsOut);
end

%-----------------------------------------------------------------------------
function Spt = Correlate(SptA, SptAB, CoWindow)

[N, NRep] = size(SptAB); Spt = cell(N, NRep^2);
for SubSeqNr = 1:N;
    for i = 1:NRep, for j = 1:NRep
            SpkTr = sort([ SptA{i}, SptAB{SubSeqNr, j}]);
            Int   = diff(SpkTr);
            SpkTr = SpkTr(find(Int <= CoWindow)+1);
            Spt{SubSeqNr, i+((j-1)*NRep)} = SpkTr;
    end, end
end

%-----------------------------------------------------------------------------
function Spt = CorrelateNoDiag(SptA, SptAB, CoWindow)

[N, NRep] = size(SptAB); Spt = cell(N, NRep^2);
for SubSeqNr = 1:N;
    for i = 1:NRep, for j = setdiff(1:NRep, i),
            SpkTr = sort([ SptA{i}, SptAB{SubSeqNr, j}]);
            Int   = diff(SpkTr);
            SpkTr = SpkTr(find(Int <= CoWindow)+1);
            Spt{SubSeqNr, i+((j-1)*NRep)} = SpkTr;
    end, end
end

%-----------------------------------------------------------------------------