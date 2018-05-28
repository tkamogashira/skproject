function plot(X);
% Waveform/display - DISPLAY for waveform objects

if isequal(get(0,'FormatSpacing'),'compact')
    disp([inputname(1) ' =']);
    disp(X);
else
    disp(' ');
    disp([inputname(1) ' =']);
    disp(' ');
    disp(X);
end