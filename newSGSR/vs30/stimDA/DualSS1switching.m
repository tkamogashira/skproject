function [preGo, postGo] = DualSS1switching(DAmode, fltIndex);

% SS1switching - prepares SS1 switching settings for PLAY/REC dual-SS1 version
% returns SS1 switching instructions for both 
% initial settings ('preGo:' before DAgo) and settings
% active during play/record ('postGo:' after DAgo).
% Exact implementations depends on cabling, number of
% analog filters, available SS1s etc.
% preGo and postGo are N-by-3 matrices, where each row represents
% a ss1select call (in order) and the 3 numbers in that row are the 
% three args to be passed to ss1select.
% SS1switching is called by playInstr, i.e., while preparing the
% Play/Rec action.

% setup for two SS1s is in separate m file (find out using flag file)
if ~twoSS1s, error('only a single SS1 present'); end

SS1sync = 2; % din of the SS1 doing the sync switching
SS1filt = 1; % din of the SS1 doing the filter switching
% "OUTPUTS" of SS1_1 and SS_2 as addressed in ss1select calls
A = 0; B = 1; C = 2; D = 3;
% "INPUTS" of SS1sync as addressed in ss1select calls (quad 2-1 mode)
inSync = [1 2 1 2 1 2 1 2];
% "INPUTS" of SS1_2 as addressed in ss1select calls (dual 4-1 mode)
inFilt = [1 2 3 4 1 2 3 4];
global SGSR; % for filter calbling XXX
disconnect = 0;

% 'L' mode (left-channel only): disconnect DAC1 and right PA4 input;
% preGo: lead DAC0 to ET1 for sync pulse
if DAmode=='L',
   preGo = [...
      SS1sync, A, inSync(2); ... % DAC0 = A -> 2 = 6
      SS1sync, B, disconnect; ... % DAC1 = B -> void
      SS1sync, C, inSync(6); ...% C = 7 <- 6 = 2
      SS1sync, D, inSync(7); ... % D = ET1in <- 7 = C
      SS1filt, A, fltIndex; ... % PA4inLeft = A <- index = flt(index)outLeft
      SS1filt, C, disconnect]; % PA4inRight = C <- void
	postGo = [...
      SS1sync, A, inSync(1); ... % DAC0 = A -> 1 = filtersInLeft
      SS1sync, D, inSync(8)];    % ET1in = D <- 8 = TTL spike output
% 'D' and 'B' modes (two active channels):
%  post-reconnect DAC1, further same as 'L' mode
elseif (DAmode=='D') | (DAmode=='B'), 
   preGo = [...
      SS1sync, A, inSync(2); ... % DAC0 = A -> 2 = 6
      SS1sync, B, disconnect; ... % DAC1 = B -> void
      SS1sync, C, inSync(6); ...% 7 = C<- 6 = 2
      SS1sync, D, inSync(7); ... % ET1in = D <- 7 = C
      SS1filt, A, fltIndex; ... % PA4inLeft = A <- index = flt(index)outLeft
      SS1filt, C, fltIndex]; %   PA4inRight = C <- index = flt(index)outRight
	postGo = [...
      SS1sync, A, inSync(1); ... % DAC0 = A -> 1 = filtersInLeft
      SS1sync, B, inSync(3); ... % DAC0 = A -> 3 = filtersInRight
      SS1sync, D, inSync(8)];    % ET1in = D <- 8 = TTL spike output
% 'R' mode (right-channel only): disconnect DAC0 and left PA4 input;
% preGo: lead DAC1 to ET1 for sync pulse
elseif (DAmode=='R'),
   preGo = [...
      SS1sync, A, disconnect; ... % DAC0 = A -> void
      SS1sync, B, inSync(4); ... % DAC1 = B -> 4 = 5
      SS1sync, C, inSync(5); ...% 7 = C <- 5 = 4
      SS1sync, D, inSync(7); ... % ET1in = D <- 7 = C
      SS1filt, A, disconnect; ... % PA4inLeft = A <- void
      SS1filt, C, fltIndex]; % PA4inRight = C <- index = flt(index)outRight
	postGo = [...
      SS1sync, B, inSync(3); ... % DAC1 = B -> 3 = filtersInRight
      SS1sync, D, inSync(8)];    % ET1in = D <- 8 = TTL spike output
elseif (DAmode=='N'), % disconnect all outputs of both SS1s
   preGo = [SS1sync, A, 0; SS1sync, B, 0; SS1sync, C, 0; SS1sync, D, 0;...
      SS1filt, A, 0; SS1filt, C, 0];
   postGo = [];
end



