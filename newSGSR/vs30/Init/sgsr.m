function SGSR(clearScreen);
% SGSR - open SGSR main dialog
%   SGSR closes all existing MatLab figures, opens SGSR 's main dialog 
%   and suspends control from the MatLab command prompt until the
%   main dialog is closed.
%
%   SGSR(1) also scrolls the MatLab command winow before opening the dialog.

if nargin<1, clearScreen=0; end

if clearScreen, 
   disp(blanks(50).'); % "clear screen" w/o losing the contents of the command window
   drawnow;
end
DeleteAllFigures;
InitSgsrMainMenu;
FallAsleep;