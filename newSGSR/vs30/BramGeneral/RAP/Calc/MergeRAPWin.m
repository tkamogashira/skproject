function Win = MergeRAPWin(AnWin, ReWin)
%MergeRAPWin    returns the analysis window merged with the reject window
%   Win = MergeRAPWin(AnWin, ReWin)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 30-10-2003


N = length(ReWin); Win = AnWin;
for n = 1:2:N,
    WinElem = ReWin([n, n+1]);
    Bgn = max(find(Win < WinElem(1))); if isempty(Bgn), Bgn = 0; end
    End = min(find(Win > WinElem(2))); if isempty(End), End = length(Win)+1; end
    
    if mod(Bgn, 2) & ~mod(End, 2), 
        %Reject window within analysis window ...
        Win(Bgn+1:End-1) = [];
        Win = [Win, WinElem];
    elseif ~mod(Bgn, 2) & mod(End, 2), 
        %Reject window encloses analysis windows ...
        Win(Bgn+1:End-1) = [];
        Win = [Win, WinElem];
    elseif mod(Bgn, 2) & mod(End, 2),
        %Reject window enclosed an ending of an analysis window ...
        Win(Bgn+1:End-1) = [];
        Win = [Win, WinElem(1)];
    elseif ~mod(Bgn, 2) & ~mod(End, 2),
        %Reject window enclosed a beginning of an analysis window ...
        Win(Bgn+1:End-1) = [];
        Win = [Win, WinElem(2)];
    end
    Win = sort(Win);    
end
