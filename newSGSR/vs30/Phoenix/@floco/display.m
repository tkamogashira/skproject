function disp(f);
% Floco/display - display for floco objects

if isequal(get(0,'FormatSpacing'),'compact')
   disp([inputname(1) ' =']);
   disp(f);
else
   disp(' ');
   disp([inputname(1) ' =']);
   disp(' ');
   disp(f);
end

