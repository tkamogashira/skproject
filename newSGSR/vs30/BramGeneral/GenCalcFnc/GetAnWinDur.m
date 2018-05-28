function WinDur = GetAnWinDur(AnWin)
%GETANWINDUR    get total duration of analysis window
%   WinDur = GETANWINDUR(AnWin)

%B. Van de Sande 23-03-2004

Df = diff(AnWin);
WinDur = sum(Df(1:2:end));