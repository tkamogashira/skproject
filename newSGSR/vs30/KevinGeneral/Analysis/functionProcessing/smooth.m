function O = smooth(XIn, YIn, N)
% SMOOTH Returns a smooth version of the given function.
%
% For more information about function processing, type:
% 'help functionProcessing'.
%
% O = smooth(XIn, YIn, N)
% Returns a smooth version of the given function, using runav.
% N indicates how many surrounding points should be taken in account in the
% averaging process.

%% check params
%XIn, YIn should be numeric equally sized row vectors; N should be numeric scalar
if ~checkXYVectors(XIn, YIn) | ~isscalar(N) %#ok<OR2>
    error('Wrong format of arguments.');
end

%Recursion if multiple rows
SX = size(XIn, 1);
if SX > 1
    for i = 1:SX
        if ~iscell(XIn)
            ORow = smooth( XIn(i,:), YIn(i,:), N );
            O.XOut(i, :) = ORow.XOut;
            O.YOut(i, :) = ORow.YOut;
        else
            ORow = smooth( XIn{i}, YIn{i}, N );
            O.XOut{i} = ORow.XOut;
            O.YOut{i} = ORow.YOut;
        end
    end
    if iscell(XIn)
        O.Xout = O.XOut';
        O.Yout = O.YOut';
    end
    return;
end

%% Let's calculate!
O.XOut = XIn;
O.YOut = runav(YIn, N, 0);