function display(P)
% query/DISPLAY - DISPLAY for query objects
%   DISPLAY(Q) displays the query object Q.
%
%   See also Query/DISP and documentation on query objects.


disp([inputname(1) ' =']);
if ~isequal(get(0,'FormatSpacing'),'compact')
   disp(' ');
   disp([inputname(1) ' =']);
   disp(' ');
end
disp(P);

