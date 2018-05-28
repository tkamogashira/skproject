function [Nstr, addSimp, specIB] = PD1routing(DAmode);
% [Nstr, addSimp, specIB] = PD1routing(DAmode);
% PD1routing - prepares PD1 routing settings for PLAY/REC XXX
% returns PD1 switching instructions for D/A corresponding
% to DAmode.
% Four DAmodes are possible:
%  DAmode     meaning            PD1 routing
% 'L':     left channel only     IB[0] -> DAC[0]
% 'R':     right channel only    IB[0] -> DAC[1]
% 'D':     diotic (2-chan mono)  IB[0] -> DAC[0] & DAC[1]
% 'B':     binaural              IB[1,2] -> DAC[1,2] resp.
% Nstr is numebr of inbound streams (AP2 -> PD1).
% addSimp and specIB are N-by-3 matrices, where each row represents
% a PD1addsimp or PD1spec call (in order) and the 3 numbers in that 
% row are the three args to be passed to those functions.
% PD1routing is called by playInstr, i.e., while preparing the
% Play/Rec action.
% The addSimp and  specIB info is applied in Playit.

[Nstr, addSimp, specIB] = deal([]);
if ~AP2present, return; end;
DAmode = channelChar(DAmode);
global PD1;
addSimp = []; % default: IB and DAC can be directly coupled
% Note: indexing of MatLab variables starts at 1 while 
% DAC IB and IREG arrays start at 0. This accounts for
% the "indexing offset" between source code and comments below.
if DAmode=='L', 
   Nstr = 1;
   specIB = [1  PD1.IB(1) PD1.DAC(1)]; % IB[0] -> DAC[0]
elseif (DAmode=='R'), 
   Nstr = 1;
   specIB = [1  PD1.IB(1) PD1.DAC(2)]; % IB[0] -> DAC[1]
elseif (DAmode=='B'), 
   Nstr = 2;
   specIB = [ ...
         1  PD1.IB(1) PD1.DAC(1); ... % IB[0] -> DAC[0]
         1  PD1.IB(2) PD1.DAC(2)];    % IB[1] -> DAC[1]
elseif (DAmode=='D'),
   Nstr = 1;
   addSimp = [...
         1 PD1.ireg(1) PD1.DAC(1); ...; % ireg[0] -> DAC[0]
			1 PD1.ireg(1) PD1.DAC(2)];     % ireg[0] -> DAC[1]
   specIB = [1, PD1.IB(1), PD1.ireg(1)];% IB[0] -> ireg[0]
end % endif DAmode
