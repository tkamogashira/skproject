function display(X)
% DATASET/DISPLAY - display for dataset objects

if isequal(get(0,'FormatSpacing'),'compact')
   disp([inputname(1) ' =']);
   disp(X)
else
   disp(' ')
   disp([inputname(1) ' =']);
   disp(' ');
   disp(X)
end
