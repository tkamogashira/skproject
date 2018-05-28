function display(S)
% paramset/DISPLAY - DISPLAY for paramset objects
%   DISPLAY(S) displays the paramset object S.
%
%   See also Paramset/DISP and documentation on paramset objects.


disp([inputname(1) ' =']);
if ~isequal(get(0,'FormatSpacing'),'compact')
   disp(' ');
   disp([inputname(1) ' =']);
   disp(' ');
end
disp(S);
