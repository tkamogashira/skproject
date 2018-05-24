function   [outnum, outden] = iirftransf(orignum, origden, ftfnum, ftfden)
%IIRFTRANSF IIR frequency transformation of the digital filter.
%   [OutNum,OutDen] = IIRFTRANSF(OrigNum,OrigDen,FTFNum,FTFDen) returns
%   numerator and denominator vectors, OUTNUM and OUTDEN of the target filter,
%   which is the result of transforming the prototype filter specified by the
%   numerator, ORIGNUM, and denominator, ORIGDEN, with the mapping filter given
%   by the numberator, FTFNUM, and the denominator, FTFDEN.
%
%   Inputs:
%     OrigNum - Numerator of the prototype lowpass filter
%     OrigDen - Denominator of the prototype lowpass filter
%     FTFNum  - Numerator of the mapping filter
%     FTFDen  - Denominator of the mapping filter
%   Outputs:
%     OutNum  - Numerator of the target filter
%     OutDen  - Denominator of the target filter
%
%   Example:
%        [b, a]           = ellip(3, 0.1, 30, 0.409);      
%        [alpnum, alpden] = allpasslp2lp(0.5, 0.25);
%        [num, den]       = iirftransf(b, a, alpnum, alpden);
%        fvtool(b,a,num,den);
%
%   See also ZPKFTRANSF.

%   Author(s): Dr. Artur Krukowski, University of Westminster, London, UK.
%   Copyright 1999-2005 The MathWorks, Inc.

% --------------------------------------------------------------------
% Check the input arguments

error(nargchk(2, 4, nargin,'struct'));

ftransfargchk(orignum, 'Numerator of the original filter',     'vector');
ftransfargchk(origden, 'Denominator of the original filter',   'vector');

switch nargin,

   case 4,
      ftransfargchk(ftfnum,'Numerator of the mapping filter',  'vector');
      ftransfargchk(ftfden,'Denominator of the mapping filter','vector');

   % FIR case -> denominator defaults to unity
   case 3;
      ftfden = fliplr(conj(ftfnum));
      ftransfargchk(ftfnum,'Numerator of the mapping filter',  'vector');

   % Transformation filter defaults to constant equal one
   case 2,
      ftfnum = 1;
      ftfden = 1;

end;

if length(ftfnum) == 1 && length(ftfden) == 1 && ftfnum == 1 && ftfden == 1,
    [outnum,outden] = eqtflength(orignum,origden);
else
    [outnum, outden] = polyallpasssub(orignum, origden, ftfnum, ftfden);

    % Force stability
    s = signalpolyutils('isstable',outden);
    if s == 0,
        outden = polystab(outden);
    end
end