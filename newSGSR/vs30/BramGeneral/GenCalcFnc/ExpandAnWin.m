function AnWin = ExpandAnWin(ArgIn, AnWin)
%EXPANDANWIN expand analysis window property
%   AnWin = EXPANDANWIN(ds, AnWin) expands the property for the analyis
%   window given by the variable AnWin when a dataset is given as input
%   to the function. 
%
%   AnWin = EXPANDANWIN(Spt, AnWin) expands the property for the analyis
%   window given by the variable AnWin when a cell-array of spiketrains
%   is given as input to the function. 
%
%   The analyis window must be given as a numerical vector with an even
%   number of elements, each pair representing a time-interval to be 
%   included in the analysis. Some shortcuts for the analysis window are
%   allowed. These are 'burstdur' and 'stimdur' for a window from zero to
%   the stimulus duration and 'repdur' for a window from zero to the repetition
%   duration. 'nostim' designates the window from stimulus duration to 
%   repetition duration.
%   If the analysis window is invalid then the empty matrix is returned.

%B. Van de Sande 24-06-2004

if isa(ArgIn, 'dataset') && ischar(AnWin) && any(strcmpi(AnWin, {'burstdur', 'stimdur'}))
    AnWin = [0 max(ArgIn.burstdur)];
elseif isa(ArgIn, 'dataset') && ischar(AnWin) && strcmpi(AnWin, 'nostim')
    AnWin = [max(ArgIn.burstdur), max(ArgIn.repdur)];
elseif isa(ArgIn, 'dataset') && ischar(AnWin) && strcmpi(AnWin, 'repdur')
    AnWin = [0, max(ArgIn.repdur)];
elseif ~isnumeric(AnWin) || ~any(size(AnWin) == 1) || mod(length(AnWin), 2) || ...
        any(AnWin < 0) || ~isequal(AnWin, unique(AnWin))
    AnWin = [];
else
    AnWin = AnWin(:)';
end

