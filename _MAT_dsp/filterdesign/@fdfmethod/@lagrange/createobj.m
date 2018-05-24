function Hd = createobj(this,coeffcell)
%CREATEOBJ   

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

struct = get(this, 'FilterStructure');
if strcmpi(struct,'fd'),
    % Ensure backwards compatibility with releases up to R2007a
    error(message('dsp:fdfmethod:lagrange:createobj:InvalidFilterStructure'));
end    
Hd = feval(['dfilt.' struct], coeffcell{1}, coeffcell{2});


% [EOF]
