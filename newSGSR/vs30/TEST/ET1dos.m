function y=ET1dos;

% ET1DOS - tests ET1read32 under DOS

disp('connect TTL pulse generator to IN-1 input of ET1');
disp('(pulse rate ~ 1kHz) and hit <return>');
input('');
s232('ET1clear',1);
s232('ET1go',1);
pause(1);
s232('ET1stop',1);
et1report;

thisDir = cd;

Fbat = [thisDir '\ET1dos.bat'];
Ftxt = 'QT1times.txt';
Ferr = 'QT1error.txt';
if ~isequal(2,exist(Fbat)),
   error('cannot find ET1dos.exe in current dir');
end
if isequal(2,exist(Ftxt)), delete(Ftxt); end;
if isequal(2,exist(Ferr)), delete(Ferr); end;

[OK DosOut] = dos([Fbat ' ' thisDir] )

type(Ferr);
spktimes = load(Ftxt);
plot(spktimes*1e-6);
xlabel('Event count');
ylabel('Event time (s)');