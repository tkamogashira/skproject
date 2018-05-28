function display(EDFds)
%EDFDATASET/DISPLAY DISPLAY-function for EDF dataset objects

%B. Van de Sande 07-08-2003

if strcmp(get(0, 'FormatSpacing'), 'compact')
   disp([inputname(1) ' =']);
   disp(EDFds)
else
   disp(' ');
   disp([inputname(1) ' =']);
   disp(' ');
   disp(EDFds)
end