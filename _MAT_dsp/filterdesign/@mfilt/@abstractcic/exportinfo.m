function s = exportinfo(~)
%EXPORTINFO Export information for the DFILT class.

%   This should be a private method.

%   Copyright 1988-2011 The MathWorks, Inc.

narginchk(1,1);

% DFILT object specific labels and names
s.variablelabel = {'Coefficients'};
s.variablename  = {'coeff'};

% DFILTs can be exported as both objects and arrays.
s.exportas.tags = {'Objects','System Objects'};

% DFILT object specific labels and names
s.exportas.objectvariablelabel = {'Discrete Filter'};
s.exportas.objectvariablename  = {'Hm'};

% Optional fields (destinations & constructors) if exporting to destinations other 
% than the 'Workspace','Text-file', or, 'MAT-file';
s.destinations  = {'Workspace','MAT-File'};
s.constructors  = {'',''};

% [EOF]
