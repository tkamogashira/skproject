function y = CompleteStop;

% CompleteStop - disconnect all devices and stop D/A XXX
% Used for playRec interruption
% XXX second SS1

SS1_1 = 1; % din of first SS1, i.e., the SS1 doing the sync switching
SS1_2 = 0; % not yet present XXX

% "OUTPUTS" of SS1_1 and SS_2 as addressed in ss1select calls
A = 0; B = 1; C = 2; D = 3;
% "INPUTS" of SS1_1 as addressed in ss1select calls (quad 2-1 mode)
in1 = [1 2 1 2 1 2 1 2];
% "INPUTS" of SS1_2 as addressed in ss1select calls (dual 4-1 mode)
in2 = [1 2 3 4 1 2 3 4];
global SGSR; % for filter calbling XXX

% disconnect SS1_1
s232('SS1select', SS1_1, A, 0);
s232('SS1select', SS1_1, B, 0);
s232('SS1select', SS1_1, C, 0);
s232('SS1select', SS1_1, D, 0);
% disconnect SS1_2 XXX
% s232('SS1select', SS1_1, A, 0);
% s232('SS1select', SS1_1, C, 0);

% stop D/A and clear I/O
s232('PD1stop', 1);
s232('PD1clrIO', 1);