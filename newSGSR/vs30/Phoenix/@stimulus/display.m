function display(P)
% Stimulus/DISPLAY - DISPLAY for Stimulus objects
%   DISPLAY(ST) displays the Stimulus object ST.
%
%   See also Stimulus/DISP and documentation on Stimulus objects.


disp([inputname(1) ' =']);
if ~isequal(get(0,'FormatSpacing'),'compact')
   disp(' ');
   disp([inputname(1) ' =']);
   disp(' ');
end
disp(P);
