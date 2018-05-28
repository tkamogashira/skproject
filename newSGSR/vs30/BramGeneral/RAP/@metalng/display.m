function display(ML)
%DISPLAY    display function for metalng object

%B. Van de Sande 09-10-2003

if strcmp(get(0, 'FormatSpacing'), 'compact')
   disp([inputname(1) ' =']);
   disp(ML);
else
   disp(' ');
   disp([inputname(1) ' =']);
   disp(' ');
   disp(ML);
end