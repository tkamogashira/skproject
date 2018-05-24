function args = constructargs(h)
 %CONSTRUCTARGS Arguments to be used for construction.
 %
 %   See also COPY, RESET.
 

 %   Author(s): V. Pellissier
 %   Copyright 1999-2012 The MathWorks, Inc.
 

 args= {'FilterLength','StepSize','Leakage', 'Power', 'AvgFactor',...
         'BlockLength', 'Offset', 'FFTCoefficients','FFTStates'};
 