function iu=atSkio;
% atSikio - returns true if computer is Sikio

% use of Compuname does not work before proper path setting, so ..
% .. it cannot be used to set the path  (typical bootstrap problem ;)
% So a little quasi-hidden text file is used to uniquely identify the computer.
iu = isequal(2, exist('c:\program files\DoNotRemove-Sikio.txt'));



