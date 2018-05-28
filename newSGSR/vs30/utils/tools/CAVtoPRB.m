% change new CAV fig into new PRB figure
oo newCav
fn = get(gcf, 'filename');
ii = findstr(fn, 'NewCAVmenu')-1;
fn(ii+(1:10)) = 'NewPRBmenu';
set(gcf, 'filename', fn)
set(gcf, 'name', 'PRB menu');
set(gcf, 'closereq', 'PRB close;')


h = findobj('tag', 'CavityCalibMenu');
set(h,'tag', 'ProbeCalibMenu')
h = findobj('tag', 'IDtext');
setstring(h,'PRB');
set(h,'foregroundcolor', [0 1 0]);
h = findobj('tag', 'MikeConnectPrompt');
setstring(h,'Connect probe microphone to microphone amplifier')
h = findobj('tag', 'MountPrompt');
setstring(h,'Mount acoustic coupler to test cavity and fit PROBE microphone');
% callbacks........
h = findobj('tag', 'CancelButton');
set(h,'callback', 'PRB')
h = findobj('tag', 'PlotButton');
set(h,'callback', 'PRB')
h = findobj('tag', 'AcceptButton');
set(h,'callback', 'PRB')
h = findobj('tag', 'StopButton');
set(h,'callback', 'PRB')
h = findobj('tag', 'StartButton');
set(h,'callback', 'PRB')


fid=fopen('cav.m');
while 1
   line = fgetl(fid);
   if ~isstr(line), break, end
   line = strSubst(line, 'CAV', 'PRB');
   line = strSubst(line, 'Cav', 'Prb');
   line = strSubst(line, 'cav', 'prb');
   disp(line)
end
fclose(fid);
