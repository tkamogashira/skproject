function [preGo, postGo] = SS1switching(DAmode, fltIndex, Perform);

% SS1switching - prepares SS1 switching settings for PLAY/REC XXX
% returns SS1 switching instructions for both 
% initial settings ('preGo:' before DAgo) and settings
% active during play/record ('postGo:' after DAgo).
% Exact implementations depends on cabling, number of
% analog filters, available SS1s etc.
% XXX Full version should include two SS1s, one for sync pulses,
% one for anti-imaging filters.
% Present, preliminary, version does not work for right-channel
% only stimuli due to lack of switches.
% preGo and postGo are N-by-3 matrices, where each row represents
% a ss1select call (in order) and the 3 numbers in that row are the 
% three args to be passed to ss1select.
% SS1switching is called by playInstr, i.e., while preparing the
% Play/Rec action.
% If Perform (default is 0), then pre and post switching are
% actually executed in order. If Perform==-1, only PreGo is realized
% if DAmode equals 'N' then preGo instructs the SS1(s) to
% be completely disconnected; postGo is empty

if nargin<3, Perform=0; end;
DAmode = channelChar(DAmode);

% setup for two SS1s is in separate m file (find out using flag file)
if twoSS1s, 
   [preGo postGo] = DualSS1switching(DAmode, fltIndex);
else,
   SS1_1 = 1; % din of first SS1, i.e., the SS1 doing the sync switching
   % "OUTPUTS" of SS1_1 and SS_2 as addressed in ss1select calls
   A = 0; B = 1; C = 2; D = 3;
   % "INPUTS" of SS1_1 as addressed in ss1select calls (quad 2-1 mode)
   in1 = [1 2 1 2 1 2 1 2];
   % "INPUTS" of SS1_2 as addressed in ss1select calls (dual 4-1 mode)
   in2 = [1 2 3 4 1 2 3 4];
   global SGSR; % for filter calbling XXX
   
   % 'L' mode (left-channel only): ignore DAC1
   if DAmode=='L',
      preGo = [...
            SS1_1, A, in1(2); ... % DAC0 = A -> 2 = 3
            SS1_1, B, in1(3); ... % 2 = 3 -> B = ET1[IN-1]
            SS1_1, C, SGSR.SS1_1(fltIndex); ...%flt_outL = 5/6 -> C = PA4L-in
            SS1_1, D, 0]; % void -> D = PA4Rin
      postGo = [...
            SS1_1, A, in1(1); ... % DAC0 = A -> 1 = filters_inL
            SS1_1, B, in1(4)];    % spike_discr = 4 -> B = ET1[IN-1]
      % 'D' and 'B' modes (two active channels):
      %  post-reconnect DAC1, further same as 'L' mode
   elseif (DAmode=='D') | (DAmode=='B'), 
      preGo = [...
            SS1_1, A, in1(2); ... % DAC0 = A -> 2 = 3
            SS1_1, B, in1(3); ... % 2 = 3 -> B = ET1[IN-1]
            SS1_1, C, SGSR.SS1_1(fltIndex); ...%flt_outL = 5/6 -> C = PA4L-in
            SS1_1, D, 0]; % void -> D = PA4Rin
      postGo = [...
            SS1_1, A, in1(1); ... % DAC0 = A -> 1 = filters_inL
            SS1_1, B, in1(4);...  % spike_discr = 4 -> B = ET1[IN-1]
            SS1_1, D, SGSR.SS1_1(fltIndex)]; % ftl_out=7/8 -> D = PA4R-in
   elseif (DAmode=='R'), % XXX
      warning('cannot do switching for R DAmode yet - need second SS1');
      [preGo, postGo] = SS1switching('L', fltIndex, Perform);
   elseif (DAmode=='N'), % disconnect all outputs
      preGo = [SS1_1, A, 0; SS1_1, B, 0; SS1_1, C, 0; SS1_1, D, 0];
      postGo = [];
   else,
      error(['invalid DAmode ''''' DAmode '''''']);
   end % if DAmode
   
end % if twoSS1s

if Perform, % execute the switching commands
   if Perform==-1,
      ss1selection = preGo';
   else,
      ss1selection = [preGo; postGo]';
   end
   for sw = ss1selection,
      s232('SS1select', sw(1), sw(2), sw(3));
   end;
   % short delay for switching to come through
   global SGSR;
   SwitchDur = SGSR.switchDur; % in ms
   % round to next multiple of 10-ms and convert to s
   SwitchDur = ceil(SwitchDur/10)*1e-2;
   pause(SwitchDur);
end
