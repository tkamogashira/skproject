function ArgOut = ExtractFreqParam(ds, FreqType)
%EXTRACTFREQPARAM    get frequency parameters for dataset.
%   Dur = EXTRACTFREQPARAM(ds, FreqType) returns the frequency of dataset
%   ds given by FreqType. FreqType must be a character string with the
%   following syntax: the requested frequency, thus 'carrier'(abbreviated
%   as 'fcar') or 'modulation'(or 'fmod'), optionally followed by 
%   'binbeat'(or 'beat'). The requested frequency is always returned
%   as a matrix with the most economical size. If the frequency varies
%   with subsequence number, the frequency will be returned as a matrix
%   for which different rows correspond to different subsequences. If
%   the frequency is different for both playback channels, the duration
%   will be a matrix where the different columns correspond with the
%   different playback channels.  If requested frequency is not applicable
%   for a dataset, then NaN is returned.
%   
%   S = EXTRACTFREQPARAM(ds) returns a structure S with all the frequency
%   parameters for the given dataset. Each field of this structure is a
%   numerical matrix with the most economical size.
%
%   Attention! All frequencies are returned in Hertz.

%B. Van de Sande 01-08-2005

%This routine extracts frequency parameters using specific fields in the
%Special structure. These fields must be implemented for a datasets in 
%order for this routine to be able to extract frequency parameters.

%Checking input arguments ...
if ~any(nargin == [1, 2]), error('Wrong number of input arguments.'); end
if ~isa(ds, 'dataset'), error('First argument should be dataset.'); end
if (nargin == 2), FName = ParseFreqType(FreqType); else FName = ''; end

%For SGSR-datasets: the CarFreq and ModFreq fields in the Special-structure of a 
%dataset always have the same number of columns as the number of active channels
%used, except if there is no difference between both channels for a frequency.
%If one of the frequency parameters isn't varied then this parameters has
%only one row, otherwise the parameters has the same number of rows as there are
%subsequences in the dataset. If CarFreq or ModFreq isn't used then that parameter
%is set to 0 or [0 0] (depending on the number of active channels). For
%subsequences that weren't recorded the frequency values aren't set to NaN.
%The BeatFreq and BeatModFreq are calculated as the difference of the last column
%minus the first column. For monaural datasets the beatfrequencies are all zero.

%For EDF-datasets: the CarFreq and ModFreq fields in the Special-structure of a 
%dataset always have the same number of columns as the number of active channels
%used. If one of the frequency parameters isn't varied the this parameters has
%only one row, otherwise the parameters has the same number of rows as there are
%subsequences in the dataset. If CarFreq or ModFreq isn't used then that parameter
%is set to NaN or [NaN, NaN] (depending on the number of active channels). For
%subsequences that weren't recorded the frequency values aren't set to NaN.
%The BeatFreq and BeatModFreq are calculated as the difference of the last column
%minus the first column. If the orginal frequency is NaN then the beatfrequency is
%also NaN. For monaural datasets the beatfrequencies are all zero or NaN.

if strcmpi(ds.FileFormat, 'SGSR') & strcmpi(ds.StimType, 'THR'), [Nsub, Nrec] = deal(ds.nsub - 1);
else, Nsub = ds.nsub; Nrec = ds.nrec; end 

%Create structure with all common frequency related stimulus parameters ...
S = getfields(ds.Special, {'CarFreq', 'ModFreq', 'BeatFreq', 'BeatModFreq'});
S.CarFreq     = TailorFreq(S.CarFreq, Nsub, Nrec);
S.ModFreq     = TailorFreq(S.ModFreq, Nsub, Nrec);
S.BeatFreq    = TailorFreq(S.BeatFreq, Nsub, Nrec);
S.BeatModFreq = TailorFreq(S.BeatModFreq, Nsub, Nrec);

if isempty(FName), ArgOut = S; 
else, ArgOut = getfield(S, FName); end

%---------------------local functions----------------------
function FieldName = ParseFreqType(Str)

Tokens = Words2Cell(Str); NTokens = length(Tokens);
if ~any(NTokens == [1, 2]), return; end
if ~any(strcmpi(Tokens{1}, {'carrier', 'fcar', 'modulation', 'fmod'})), 
    error('Invalid syntax in frequency expression.');
end
if (NTokens == 2) & ~any(strcmpi(Tokens{2}, {'binbeat', 'beat'})), 
    error('Invalid syntax in frequency expression.');
end

if any(strcmpi(Tokens{1}, {'carrier', 'fcar'})), %Carrier frequency ...
    if (NTokens == 1) | ~any(strcmpi(Tokens{2}, {'binbeat', 'beat'})), FieldName = 'CarFreq';
    else, FieldName = 'BeatFreq'; end    
else, %Modulation frequency ...
    if (NTokens == 1) | ~any(strcmpi(Tokens{2}, {'binbeat', 'beat'})), FieldName = 'ModFreq';
    else, FieldName = 'BeatModFreq'; end    
end

%----------------------------------------------------------
function TFreq = TailorFreq(Freq, Nsub, Nrec)

if all(Freq(:) == 0) | all(isnan(Freq(:))), TFreq = NaN;
else, TFreq = SqueezeParam(AdjustParam(Freq, Nsub, Nrec)); end

%----------------------------------------------------------