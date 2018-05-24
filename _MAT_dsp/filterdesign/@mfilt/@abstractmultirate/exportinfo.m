function s = exportinfo(Hd)
%EXPORTINFO Export information for the DFILT class.

%   This should be a private method.

%   Copyright 1988-2012 The MathWorks, Inc.

narginchk(1,1);

% Both coefficientnames & coefficientvariables return cell arrays.
s.variablelabel = coefficientnames(Hd); 
s.variablename  = coefficientvariables(Hd);

% MFILTs can be exported as both objects and arrays.
s.exportas.tags = {'Coefficients','Objects','System Objects'};

% MFILT object specific labels and names
s.exportas.objectvariablelabel = {'Multirate Filter'};
s.exportas.objectvariablename  = {'Hm'};

% Optional fields (destinations & constructors) if exporting to destinations other 
% than the 'Workspace','Text-file', or, 'MAT-file';
s.destinations  = {'Workspace','Coefficient File (ASCII)','MAT-File'};
s.constructors  = {'','sigio.xp2coeffile',''};

