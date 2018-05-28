function [CorrFnc, CorrType] = calcCrossCorr(CLO, rows, varargin)
% CALCCROSSCORR Calculates cross correlations
%
% [CorrFnc, CorrType] = calcCrossCorr(CLO, rows)
% Calculates the cross correlations between two rows of the corrListObject.

% Returns:
%     CorrFnc : results of the correlations
%   corrType : type of the correlation ('dif' or 'cor')

% Created by: Kevin Spiritus
% Last adjusted: 2007-02-12

defParams.corrType = 'dif';
params = processParams(varargin, defParams);

if ~isequal( [1 2], size(rows) ) | ~isequal( [0 0], mod(rows, 1) ) %#ok<OR2> (ML6 compatibility)
    error('Arguments were given in the wrong format.');
end

Spt1p       = CLO.list(rows(1)).SptP;
Spt1n       = CLO.list(rows(1)).SptN;
WinDur1     = CLO.list(rows(1)).WinDur;
Spt2p       = CLO.list(rows(2)).SptP;
Spt2n       = CLO.list(rows(2)).SptN;
WinDur2     = CLO.list(rows(2)).WinDur;
corrMaxLag   = CLO.props.corrMaxLag; %#ok<NASGU> (used eval)
corrBinWidth = CLO.props.corrBinWidth; %#ok<NASGU> (used eval)
norm        = CLO.props.norm;

if isequal('', norm)
    sptCorrTail = 'corrMaxLag, corrBinWidth'; % this string will be given to SPTCORR
else
    sptCorrTail = 'corrMaxLag, corrBinWidth, winDur, norm';
end

if ~isempty(Spt1p) & ~isempty(Spt2p), %#ok<AND2> (ML6 compat)
    winDur = getWinDur(WinDur1(1), WinDur2(1)); %#ok<NASGU> (used eval)
    Ypp = eval(['SPTCORR(Spt1p, Spt2p, ' sptCorrTail ');']); %SCC
end

if ~isempty(Spt1n) & ~isempty(Spt2n), %#ok<AND2>
    winDur = getWinDur(WinDur1(2), WinDur2(2)); %#ok<NASGU>  (used eval)
    Ynn = eval(['SPTCORR(Spt1n, Spt2n, ' sptCorrTail ');']); %SCC
end

if ~isempty(Spt1p) & ~isempty(Spt2n), %#ok<AND2>
    winDur = getWinDur(WinDur1(1), WinDur2(2)); %#ok<NASGU>  (used eval)
    Ypn = eval(['SPTCORR(Spt1p, Spt2n, ' sptCorrTail ');']); %XCC
end

if ~isempty(Spt1n) & ~isempty(Spt2p), %#ok<AND2>
    winDur = getWinDur(WinDur1(2), WinDur2(1)); %#ok<NASGU>  (used eval)
    Ynp = eval(['SPTCORR(Spt1n, Spt2p, ' sptCorrTail ');']); %XCC
end

if exist('Ypp', 'var') & exist('Ynn', 'var') %#ok<AND2>
    Yscc = mean([Ypp; Ynn]);
elseif exist('Ypp', 'var')
    Yscc = Ypp;
elseif exist('Ynn', 'var')
    Yscc = Ynn;
end

if exist('Ypn', 'var') & exist('Ynp', 'var') %#ok<AND2>
    Yxcc = mean([Ypn; Ynp]);
elseif exist('Ypn', 'var')
    Yxcc = Ypn;
elseif exist('Ynp', 'var')
    Yxcc = Ynp;
end

if exist('Yscc', 'var') & exist('Yxcc', 'var'), %#ok<AND2>
    switch lower(params.corrType)
        case 'dif'
            CorrFnc = Yscc-Yxcc;
            CorrType = 'dif';
        case 'sum'
            CorrFnc = mean([Yscc; Yxcc]);
            CorrType = 'sum';
        case 'sac'
            warning('calculated sac instead of dif or sum corr');
            CorrFnc = Yscc;
            CorrType = 'scc';                    
        case 'xac'
            warning('calculated xac instead of dif or sum corr');
            CorrFnc = Yxcc;
            CorrType = 'xcc';
        otherwise
            error('Wrong corrType!');
    end
elseif exist('Yscc', 'var'),
    CorrFnc = Yscc;
    CorrType = 'SCC';
else
    CorrFnc = Yxcc;
    CorrType = 'XCC';
end