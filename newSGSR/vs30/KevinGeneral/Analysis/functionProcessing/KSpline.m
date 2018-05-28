function O = KSpline(XIn, YIn, rFactor)
% KSPLINE Returns a splined version of the given function
%
%  O = KSpline(XIn, YIn, rFactor)
% 
% Arguments:
%  XIn, YIn: The function we want to spline. The values in XIn should be 
%            equally spaced. 
%   rFactor: indicates how many divisions will be made in the X-values.
% 
% Example: 
%   If
%     XIn = [0 5 10];
%     rFactor = 5;
%   then:
%     O.XOut = [0 1 2 3 4 5 6 7 8 9 10].
%
% For more information about function processing, type:
% 'help functionProcessing'.
%
% For more information about splining, type:
% 'doc spline' in Matlab.

%% Check args
%XIn, YIn should be numeric equally sized row vectors; rFactor should be numeric scalar
if ~checkXYVectors(XIn, YIn) | ~isscalar(rFactor) %#ok<OR2>
    error('Wrong format of arguments.');
end

if isequal(0, rFactor)
    O.XOut = XIn;
    O.YOut = YIn;
    return;
end

%% Check if values in XIn are equally spaced, and calculate new values
for row = 1:size(XIn, 1)
    % Check old X-values
    if ~isEquallySpaced( XIn(row, :), 12 )
        error('Wrong format of arguments.');
    end

    %compute the new X-values
    O.XOut(row, :) = deal(zeros( 1, rFactor*numel(XIn(row, :)) - (rFactor-1) ));
    O.XOut(row, :) = linspace( XIn(row, 1), XIn(row, end), rFactor*numel(XIn(row, :)) - (rFactor-1) );
    
    %compute splined Y-values
    O.YOut(row, :) = deal(spline(XIn(row, :), YIn(row, :), O.XOut(row, :)));
end