function BinFreq = ExpandBinFreq(ArgIn, BinFreq, iSubSeqs)
%EXPANDBINFREQ  expand the binning frequency given for a dataset
%   BinFreq = EXPANDBINFREQ(ds) returns the default binning frequency for
%   all the recorded subsequences of dataset ds as a numerical vector.
%
%   BinFreq = EXPANDBINFREQ(ds, BinFreq) expands the requested binning
%   frequency given by BinFreq to a numerical vector with the same number
%   of elements as the number of recorded subsequences for the dataset ds.
%
%   BinFreq = EXPANDBINFREQ(ds, BinFreq, iSubSeqs) expands the requested
%   binning frequency given by BinFreq to a numerical vector with the same
%   number of elements as the number of requested subsequences for the 
%   dataset ds. iSubSeqs is a vector with the indices of the subsequences
%   to return the binning frequency for.
%
%   BinFreq = EXPANDBINFREQ(Spt, BinFreq, iSubSeqs) expands the requested
%   binning frequency given by BinFreq to a numerical vector with the same
%   number of elements as the number of requested subsequences of the cell-
%   array of spiketrains. iSubSeqs is a vector with the indices of the sub-
%   sequences to return the binning frequency for.
%
%   The binning frequency must be given in Hz and can be a constant or a
%   numerical vector with the same length as the number of recorded sub-
%   sequences or when a list of indices with requested subsequences is given
%   then the length of the numerical vector my also equal the number of
%   requested subsequences.
%   The following shortcuts are included: 'carrier' of 'fcar' (the frequency
%   of the carrier), 'modulation' of 'fmod' (the frequency of the modulation).
%   For binaural datasets an optional suffix can be given to select the
%   frequency of which channel: 'binbeat', 'left' or 'right'. It is also
%   possible to give an expression based on these shortcuts (suffixes are
%   not supported then), e.g. 'fmod + 10*fcar'.
%   By default the binning frequency depends on the type of dataset ('auto') 
%   and is chosen according to the following decreasing relative priorities:
%   
%   Monaural: in order of decreasing priority
%       1) modulation freq if varied
%       2) carrier freq if varied
%       3) modulation freq if not varied
%       4) carrier freq if not varied
%
%   Binaural: in order of decreasing priority
%       binbeat > left or right
%       modulation > carrier
%
%   The binning frequency can be negative.

%B. Van de Sande 26-03-2004
% RdN

% ---------------- CHANGELOG -----------------------
%  Mon Jan 24 2011  Abel   
%   return binfreq as row vector

if (nargin < 1)
    error('Wrong number of input arguments.');
end
if isa(ArgIn, 'dataset')
    NRec = ArgIn.nrec;
elseif iscell(ArgIn) && all(all(cellfun('isclass', ArgIn, 'double')))
    NRec = size(ArgIn, 1);
else
    error('First argument should be dataset or cell-array of spiketrains.');
end

if (nargin == 1)
    BinFreq  = 'auto';
    iSubSeqs = 1:NRec;
elseif (nargin == 2)
    iSubSeqs = 1:NRec;
end

if ~all(ismember(iSubSeqs, 1:NRec))
    error(['One of the requested subsequences doesn''t exist or ' ...
        ' wasn''t recorded.']);
end
NSubSeqs = length(iSubSeqs);

if isnumeric(BinFreq) %Numerical binning frequency supplied ...
    if (length(BinFreq) == 1)
        BinFreq = repmat(BinFreq, NSubSeqs, 1);
    elseif isequal(length(BinFreq), NRec)
        BinFreq = BinFreq(iSubSeqs);
    elseif ~isequal(length(BinFreq), NSubSeqs)
        BinFreq = [];
    end
else %Binning frequency supplied as character string ...
    ds = ArgIn;
    if ~isa(ds, 'dataset')
        BinFreq = [];
    elseif strcmpi(BinFreq, 'auto')
        S = GetFreq(ds);
        if (S.NChan == 2) %Binaural dataset ...
            if ~all(isnan(S.BeatModFreq(1:NRec)))
                BinFreq = S.BeatModFreq(iSubSeqs);
            elseif ~all(isnan(S.BeatFreq(1:NRec)))
                BinFreq = S.BeatFreq(iSubSeqs);
            else
                %If all else fails, try the find a column in ModFreq or CarFreq that
                %isn't all NaN ...
                ColIdx = find(all(~isnan(S.ModFreq(1:NRec, :)), 2));
                if ~isempty(ColIdx)
                    BinFreq = S.ModFreq(iSubSeqs, ColIdx);
                else
                    ColIdx = find(all(~isnan(S.BeatFreq(1:NRec, :)), 2));
                    if ~isempty(ColIdx)
                        BinFreq = S.BeatFreq(iSubSeqs, ColIdx); 
                    else
                        BinFreq = [];
                    end
                end    
            end
        else %Monaural dataset ...
            if ~all(denan(diff(S.ModFreq(1:NRec))) == 0)
                % ModFreq is varied
                BinFreq = S.ModFreq(iSubSeqs);
            elseif ~all(denan(diff(S.CarFreq(1:NRec))) == 0)
                % CarFreq is varied
                BinFreq = S.CarFreq(iSubSeqs);
            elseif ~all(isnan(S.ModFreq(1:NRec))) && ...
                    ~all(abs(denan(S.ModFreq(1:NRec))) < 1e-10)
                BinFreq = S.ModFreq(iSubSeqs);
            elseif ~all(isnan(S.CarFreq(1:NRec))) && ...
                    ~all(abs(denan(S.CarFreq(1:NRec))) < 1e-10)
                BinFreq = S.CarFreq(iSubSeqs);
            else
                BinFreq = [];
            end
        end    
    else
        try
            BinFreq = GetFreq(ds, BinFreq);
        catch
            BinFreq = [];
            return
        end
        if (size(BinFreq, 2) > 1)
            BinFreq = [];
        else
            BinFreq = BinFreq(iSubSeqs);
        end
    end
end
%By Abel: return as row vector
BinFreq = BinFreq(:).';
