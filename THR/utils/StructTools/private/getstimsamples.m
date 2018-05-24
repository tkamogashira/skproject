function [y, t] = GetStimSamples(varargin)
%GETSTIMSAMPLES get stimulus waveform of a dataset subsequence.
%   [y, t] = GETSTIMSAMPLES(ds, iSubSeq) returns the stimulus waveform where
%   t is a scalar containing the sample period in microseconds and y a matrix
%   with for each used and requested channel a columnvector containing the
%   amplitude.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view a list of all possible properties and their default values,
%   use 'factory' as only input argument.

%B. Van de Sande 14-07-2005

%-------------------------------default parameters---------------------------
DefParam.channel  = 0;  %'master', 'slave', 'left', 'right', 1 or 2. Also
                        %'both' or 0 are possible ...
                        
%----------------------------------main program------------------------------
%Checking input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:'); disp(DefParam);
    return;
else, [ds, iSubSeq, Param] = ParseArgs(DefParam, varargin{:}); end

%Get stimulus samples ...
if isa(ds, 'EDFdataset') 
    [y, t] = GetStimSamples4EDFds(ds, iSubSeq);
else
    %For EDF/SPK or SGSR-datasets the function STIMSAM.M is used ...
    [y, t] = StimSam(ds, iSubSeq); 
end

if ~strcmpi(Param.channelidx, ':') 
    y = y(:, Param.channelidx); 
end

%-------------------------------local functions------------------------------
function [ds, iSubSeq, Param] = ParseArgs(DefParam, varargin)

%Checking mandatory parameters ...
if (nargin < 2), error('Wrong number of input arguments.'); end
if ~any(strcmpi(class(varargin{1}), {'dataset', 'EDFdataset'})), error('First argument should be dataset.'); end
ds = varargin{1};
if ~isnumeric(varargin{2}) | (length(varargin{2}) ~= 1) | ~ismember(varargin{2}, 1:ds.nrec), 
    error('Second argument should be valid subsequence number for supplied dataset.'); 
end
iSubSeq = varargin{2};

%Checking properties and their values ...
Param = CheckPropList(DefParam, varargin{3:end});
Param = CheckParam(ds, Param);

%----------------------------------------------------------------------------
function Param = CheckParam(ds, Param)

%Checking syntax of channel property ...
if ischar(Param.channel) & any(strncmpi(Param.channel, {'m', 'l'}, 1)), Param.channel = 1;
elseif ischar(Param.channel) & any(strncmpi(Param.channel, {'s', 'r'}, 1)), Param.channel = 2;   
elseif ischar(Param.channel) & strncmpi(Param.channel, 'b', 1), Param.channel = 0;
elseif ~isnumeric(Param.channel) | ~any(Param.channel == [0, 1, 2]),
    error('Property channel must be ''master'', ''slave'', ''left'', ''right'', ''both'', 0, 1 or 2.'); 
end
%Checking if requested channel number is present for dataset ...
if ~isnan(ds.Special.ActiveChan), Nchan = 2 - sign(ds.Special.ActiveChan);
else, Nchan = 0; end
ChanNr = ds.Special.ActiveChan;
if (Nchan == 2) & (Param.channel == 0), Param.channelidx = ':';
elseif (Nchan == 2), Param.channelidx = Param.channel;    
elseif (Nchan == 1) & (Param.channel == ChanNr), Param.channelidx = 1;
else, error('Requested channel is not present for dataset.'); end
%Checking if for requested channel noise was administered ...
if isa(ds, 'EDFdataset'),
    if (Param.channel == 0) & ~all(ismember(lower(ds.DSS.Mode), {'gws', 'gwr', 'gam'})),
        error('For one of the requested channels no noise token was administered.');
    elseif ~any(strcmpi(ds.DSS(Param.channelidx).Mode, {'gws', 'gwr', 'gam'})),
        error('For the requested channel no noise token was administered.');
    end
end
        
%----------------------------------------------------------------------------
function [y, t] = GetStimSamples4EDFds(ds, iSubSeq)

%Collect stimulus information and samples for each channel ...
Nchan = ds.dssnr; Stim = struct('Npoints', {}, 'PbPer', {}, 'Time', {}, 'A', {});
for n = 1:Nchan
    %Finding the appropriate general waveform dataset ...
    if iscellstr(ds.GWParam.FileName)
        [dummy, dummy, GWFile] = unravelVMSPath(ds.GWParam.FileName{n});
    else
        [dummy, dummy, GWFile] = unravelVMSPath(ds.GWParam.FileName); 
    end
    %Loading the general waveform dataset ...
    if strcmpi(ds.indepshortname, 'dsnr') & strcmpi(GWID, 'none')
        GWiSubSeq = ds.GWParam.DSNr(iSubSeq, n);
        try
            GEWAVds = dataset(GWFile, GWiSubSeq);
        catch
            error(sprintf('The general waveform dataset #%d <%s> cannot be found.', GWFile, GWiSubSeq)); 
        end    
    else,
        if iscellstr(ds.GWParam.ID)
            GWID = ds.GWParam.ID{n}; 
        else
            GWID = ds.GWParam.ID; 
        end
        
        try
            GEWAVds = dataset(GWFile, GWID);
        catch
            error(sprintf('The general waveform dataset %s <%s> cannot be found.', GWFile, GWID)); 
        end    
    end
    Stim(n).Npoints = GEWAVds.stimparam.NPoints;
    Stim(n).PbPer   = GEWAVds.stimparam.PbPer;
    Stim(n).Time    = GEWAVds.data.OtherData.WaveForm.time(:);
    Stim(n).A       = GEWAVds.data.OtherData.WaveForm.amplitude(:);
end

%Try to combine information on both stimulus samples ...
if (length(unique(cat(1, Stim.Npoints))) == 1) & (length(unique(cat(1, Stim.PbPer))) == 1),
    [y, t]  = deal([Stim.A], Stim(1).PbPer);
else, error('Stimulus information on both channels cannot be combined. Use property ''channel''.'); end

%----------------------------------------------------------------------------