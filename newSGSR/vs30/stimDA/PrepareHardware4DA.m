function PrepareHardware4DA(INSTR);
% prepareHardware4DA - prepare PD1 and SS1 for synched play
%   instr arg as created by HardwareInstr4DA
%  prepares PD1 & SS1 for synched play
%  INSTR arg must contain fields:
%    SamP, Nplay, nStreams, preGo, 
%    addSimp, specIB
%  specOB filed is optional
% See also HardwareInstr4DA

% wait until previous D/A has finished
while (s232('PD1status',1)~=0), end;
setPA4s(maxanalogAtten(1)); % softening the clix, I hope
s232('PD1clrIO',1); % set output Voltage to zero to avoid switch clicks
% -------CLICK DEBUG-------
% tic;
% while toc<1, end;
% disp('PRE SWITCHING')

% ------initial wiring for sync pulse trigger & analog filters;
% already figured out in function ss1switching called by playInstr.
for icomm=INSTR.preGo.', % column-wise assignment (see help for)
   s232('SS1select', icomm(1), icomm(2), icomm(3));
end;
%----- prepare PD1 for D/A
Nstr = INSTR.nStreams; if length(Nstr)==1, Nstr = [Nstr, 0]; end; % default: no OB
s232('PD1clear', 1);
s232('PD1speriod',1, INSTR.SamP);
s232('PD1npts', 1,  INSTR.Nplay);
s232('PD1nstrms',1, Nstr(1), Nstr(2)); % # inbound (AP2->PD1) streams
s232('PD1clrsched', 1); % clear routing schedule

% set up routing schedule according to instructions that are
% already figured out by function PD1routing called by playInstr.
if isfield(INSTR,'specOB'),
   for icomm=INSTR.specOB.', % column-wise assignment (see help for)
      s232('PD1specOB', icomm(1), icomm(2), icomm(3));
   end;
end
for icomm=INSTR.addSimp.', % column-wise assignment (see help for)
   s232('PD1addsimp', icomm(1), icomm(2), icomm(3));
end;
for icomm=INSTR.specIB.', % column-wise assignment (see help for)
   s232('PD1specIB', icomm(1), icomm(2), icomm(3));
end;

