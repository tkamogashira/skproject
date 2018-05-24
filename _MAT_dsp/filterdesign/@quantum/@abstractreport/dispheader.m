function dispheader(this)
%DISPHEADER   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

fprintf('%s\n',' ')
fmt1 = '%16s%94s\n';
fmt2 = '%16s%16s%1s%16s%1s%33s%1s%25s\n';
if strcmpi(this.DataType, 'fixed'),
    fprintf(fmt1,'','Fixed-Point Report                                          ');
    fprintf(fmt1,'',...
        '---------------------------------------------------------------------------------------------');
    fprintf(fmt2,...
        '', 'Min       ', ' ','Max       ','|',' Range              ','|','Number of Overflows');
    fprintf(fmt1,'',...
        '---------------------------------------------------------------------------------------------');

elseif strcmpi(this.DataType, 'double'),
    fprintf(fmt1,'','Double-Precision Floating-Point Report                           ');
    fprintf(fmt1,'',...
        '---------------------------------------------------------------------------------------------');
    fprintf(fmt2,...
        '', 'Min       ', ' ','Max       ','|','Fixed-Point Range        ','|','Out of Range');
    fprintf(fmt1,'',...
        '---------------------------------------------------------------------------------------------');
end

%fprintf('%12s%s%s\n', 'Stimulus:', ' ', this.Stimulus);

% [EOF]
