function folder = uigetfolder_win32_compiler_test
% Test for uigetfolder_win32 with the MATLAB compiler (R12)

folder = uigetfolder_win32('Select folder', pwd);

disp(folder)
%-----------------------------------------------------


