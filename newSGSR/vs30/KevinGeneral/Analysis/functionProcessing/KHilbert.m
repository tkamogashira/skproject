function O = KHilbert(XIn, YIn, smoothFactor)
% KHILBERT Returns the Hilbert transform of the given function.
%
% For more information about function processing, type:
% 'help functionProcessing'.
% For more information about Hilbert, type:
% 'doc hilbert'.
%
% O = KHilbert(XIn, YIn, smoothFactor)
% The values in XIn should be equally spaced. The parameter smoothFactor 
% adds a runav smoothing to the result.

% Created by: Kevin Spiritus
% Last adjusted: 2007/02/21

%% Check args
%XIn, YIn should be numeric equally sized row vectors
if ~checkXYVectors(XIn, YIn)
    error('Wrong format of arguments.');
end

if nargin < 3
    smoothFactor = 0;
end

%Recursion if multiple rows
SX = size(XIn, 1);
if SX > 1
    for i = 1:SX
        ORow = KHilbert( XIn(i,:), YIn(i,:), smoothFactor );
        O.XOut(i, :) = ORow.XOut;
        O.YOut(i, :) = ORow.YOut;
    end
    return;
end
disp('smoothFactor');
disp(smoothFactor);
%% Let's calculate!
%compute the new X-values
O.XOut = XIn;
%compute Hilbert
O.YOut = runav(abs(hilbert(YIn)),smoothFactor); % see 'doc hilbert'
