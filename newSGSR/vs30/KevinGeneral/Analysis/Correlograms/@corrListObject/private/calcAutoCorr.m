function [CorrFnc, CorrType] = calcAutoCorr(CLO, row, varargin)
% CALCAUTOCORR Calculates auto correlations
%
% [CorrFnc, CorrType] = calcAutoCorr(CLO, rows)
% Calculates the auto correlations between two rows of the corrListObject.
% 
% Returns:
%     CorrFnc : results of the correlations
%   corrType : type of the correlation ('dif' or 'cor')

% Created by: Kevin Spiritus
% Last adjusted: 2007-02-12

defParams.corrType = 'dif';
params = processParams(varargin, defParams);

%CALCCORFNC(SptP, SptN, WinDur, Props)
SptP        = CLO.list(row).SptP;
SptN        = CLO.list(row).SptN;
WinDur      = CLO.list(row).WinDur; %#ok<NASGU> (used eval)
corrMaxLag   = CLO.props.corrMaxLag; %#ok<NASGU> (used eval)
corrBinWidth = CLO.props.corrBinWidth; %#ok<NASGU> (used eval)
norm        = CLO.props.norm;

if isempty(norm)
    sptCorrTail = 'corrMaxLag, corrBinWidth';
else
    sptCorrTail = 'corrMaxLag, corrBinWidth, corrWinDur, norm';
end

if ~isempty(SptP) & ~isempty(SptN), %#ok<AND2> (ML6 compatibility)
    corrWinDur = WinDur(1); %#ok<NASGU> (used eval)
    Ypp = eval(['SPTCORR(SptP, ''nodiag'', ' sptCorrTail ');']);  %SAC ...
    corrWinDur = WinDur(2); %#ok<NASGU> (used eval)
    Ynn = eval(['SPTCORR(SptN, ''nodiag'', ' sptCorrTail ');']);  %SAC ...
    corrWinDur = getWinDur(WinDur(1), WinDur(2)); %#ok<NASGU> (used eval)
    Ypn = eval(['SPTCORR(SptP, SptN, ' sptCorrTail ');']);  %XAC ...
    Ynp = Ypn;
    
    Ysac = mean([Ypp; Ynn]);
    Yxac = mean([Ypn; Ynp]);
    
    switch lower(params.corrType)
        case 'dif'
            CorrFnc = Ysac-Yxac;
            CorrType = 'dif';
        case 'sum'
            CorrFnc = mean([Ysac; Yxac]);
            CorrType = 'sum';
        case 'sac'
            warning('calculated sac instead of dif or sum corr');
            CorrFnc = Ysac;
            CorrType = 'sac';                    
        case 'xac'
            warning('calculated xac instead of dif or sum corr');
            CorrFnc = Yxac;
            CorrType = 'xac';
        otherwise
            error('Wrong corrType!!!');
    end
elseif ~isempty(SptP),
    corrWinDur = WinDur(1); %#ok<NASGU> (used eval)
    CorrFnc = eval(['SPTCORR(SptP, ''nodiag'', ' sptCorrTail ');']);   %SAC ...
    CorrType = 'cor';
elseif ~isempty(SptN),
    corrWinDur = WinDur(2); %#ok<NASGU> (used eval)
    CorrFnc = eval(['SPTCORR(SptN, ''nodiag'', ' sptCorrTail ');']);   %SAC ...
    CorrType = 'cor';
end