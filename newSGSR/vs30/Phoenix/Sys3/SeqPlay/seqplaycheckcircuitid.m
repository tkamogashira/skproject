function mess = SeqplayCheckCircuitID;
% RX6SeqplayCheckCircuitID - check if the running RPvdS circuit matches Seqplay circuit
%    mess = SeqplayCheckCircuitID returns empty if the circuit started by
%    SeqplayInit is running, an appropriate error message otherwise.

mess = ''; % optimistic default

SPinfo = SeqplayInit('status');

try, CircuitID = sys3getpar('CircuitIDOut', SPinfo.Dev);
catch
   mess = 'Seqplay circuit not running - cannot retrieve CircuitIDOut tag value.';
   [Active, Iwav, Irep] = deal(0);
   return;
end

% Check CircuitID
if SPinfo.CircuitID ~= CircuitID
   mess = 'Seqplay CircuitID does not match the one set by SeqplayInit.';
   return;
end



