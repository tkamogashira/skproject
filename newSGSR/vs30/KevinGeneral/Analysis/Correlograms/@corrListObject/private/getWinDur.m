function result = getWinDur(winDur1, winDur2)
% WINDUR Decides what window duration to pass to SPTCORR
% - private function

if isequal(winDur1, winDur2)
    result = winDur1; %#ok<NASGU> (used eval)
else
    warning('Using average window duration in calculation of normalization coefficient.'); %#ok<WNTAG>
    result = mean([winDur1, winDur2]); %#ok<NASGU> (used eval)
end