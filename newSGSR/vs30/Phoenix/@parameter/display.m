function display(P)
% parameter/DISPLAY - DISPLAY for parameter objects
%   DISPLAY(S) displays the parameter object S.
%
%   See also Parameter/DISP and documentation on parameter objects.


disp([inputname(1) ' =']);
if ~isequal(get(0,'FormatSpacing'),'compact')
   disp(' ');
   disp([inputname(1) ' =']);
   disp(' ');
end
disp(P);

