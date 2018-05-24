function [allpassnum, allpassden] = allpassshiftc(wo, wt)
%ALLPASSSHIFTC Allpass for complex shift frequency transformation.
%   [AllpassNum,AllpassDen] = ALLPASSSHIFTC(Wo,Wt) returns numerator,
%   ALLPASSNUM, and denominator, ALLPASSDEN, vectors of the allpass mapping
%   filter.
%
%   Inputs:
%     Wo         - Frequency value to be transformed from the prototype filter.
%     Wt         - Desired frequency location in the transformed target filter.
%   Outputs:
%     AllpassNum - Numerator of the mapping filter
%     AllpassDen - Denominator of the mapping filter
%
%   [NUM,DEN] = ALLPASSSHIFTC(0,0.5) calculates the allpass filter for doing the
%   Hilbert transformation, e.i. a 90 degrees anticlockwise rotation of the
%   original filter in the frequency domain.
%
%   [NUM,DEN] = ALLPASSSHIFTC(0,-0.5) calculates the allpass filter for doing an
%   inverse Hilbert transformation, e.i. a 90 degrees anticlockwise rotation
%   of the original filter in the frequency domain.
%
%   Frequencies must be normalized to be between -1 and 1, with 1 corresponding
%   to half the sample rate.
%
%   Example:
%        % Allpass mapper shifting the old feature originally at 0.5 to 0.25
%        Wo = 0.5;
%        Wt = 0.25;
%        [AllpassNum, AllpassDen] = allpassshiftc(Wo, Wt);
%        % Calculate the spectrum of the allpass mapping filter
%        [h, f] = freqz(AllpassNum, AllpassDen, 'whole');
%        % Plot the phase response normalised to PI as a mapping function Wo(Wt)
%        plot(f/pi, angle(h)/pi, Wt, Wo, 'ro');
%        title('The mapping function Wo(Wt)');
%        xlabel('New frequency, Wt');
%        ylabel('Old frequency, Wo');
%
%   See also IIRSHIFTC and ZPKSHIFTC.

%   Author(s): Dr. Artur Krukowski, University of Westminster, London, UK.
%   Copyright 1999-2004 The MathWorks, Inc.

% --------------------------------------------------------------------
% Perform the parameter validity check

error(nargchk(2,2,nargin,'struct'));

ftransfargchk(wo, 'Frequency value from the prototype filter', ...
                        'real', 'scalar', 'full normalized + edge');
ftransfargchk(wt, 'Desired frequency location in the target filter', ...
                        'real', 'scalar', 'full normalized + edge');

% ---------------------------------------------------------------------
% Calculate the mapping filter

allpassnum = [0 1] * exp(pi*i*(wt-wo));
allpassden = [1 0];
