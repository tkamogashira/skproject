function Display(PB)
%PROPERTYBAG/DISPLAY    display property bag.
%   DISPLAY(PB) displays information of the supplied property bag
%   on the command window.

%B. Van de Sande 06-05-2004

if strcmp(get(0, 'FormatSpacing'), 'compact')
   disp([inputname(1) ' =']);
   disp(PB);
else
   disp(' ');
   disp([inputname(1) ' =']);
   disp(' ');
   disp(PB);
end