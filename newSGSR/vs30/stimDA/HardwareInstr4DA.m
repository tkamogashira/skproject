function instr=HardwareInstr4DA(DAmode, filterIndex, Nplay, SamP);
% HardwareInstr4DA - ceates hardware instructions for synched play
%  Syntax: instr=HardwareInstr4DA(DAmode, filterIndex, Nplay, SamP)
%  SamP in us is optional (can be obtained from filter index)
%
%  See also PrepareHardware4DA.

if nargin<4, % compute from sample freq
   global SGSR
   SamP = 1e6/SGSR.samFreqs(filterIndex);
end
% SS1 switching instructions
[preGo postGo] = ss1switching(DAmode, filterIndex);
% PD1 routing instructions
[nStreams addSimp specIB] = PD1routing(DAmode);
% combine left and right list to single 2xN matrix

instr = CollectInStruct(Nplay, SamP, ...
   nStreams, addSimp, specIB, preGo, postGo);
