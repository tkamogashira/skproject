function help_firtype(this)
%HELP_FIRTYPE   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

firtype_str = sprintf('%s\n%s\n%s\n%s', ...
    '    HD = DESIGN(..., ''FIRType'', ''4'') designs a type IV (odd order) filter . This is ',...
    '    the default. The magnitude of the filter is zero at DC.',...
    '    HD = DESIGN(..., ''FIRType'', ''3'') designs a type III (even order) filter.', ...
    '    The magnitude of the filter is zero at DC and at Fs/2 (pi).');

disp(firtype_str);
disp(' ');


% [EOF]
