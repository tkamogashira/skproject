function listEntry = loadDS(listEntry, AnWin)
% LOADSPKTR Loads the spiketrain from a given List entry
% - private function

listEntry.icell = 0;
if ~isnan(listEntry.iseqp) & ~isnan(listEntry.isubseqp) %#ok<AND2>
    dsP = dataset(listEntry.filename, listEntry.iseqp);
    AnWinP = ExpandAnWin(dsP, AnWin);
    listEntry.icell = dsP.icell;
    listEntry.SptP   = ANWIN(dsP.spt(listEntry.isubseqp, :), AnWinP);
    listEntry.seqIdP = dsP.SeqID;
    listEntry.indepValP = dsP.indepval(listEntry.isubseqp);
    listEntry.indepUnitP = dsP.indepunit;
    %Duration of analysis window in ms ...
    listEntry.WinDur(1) = GetAnWinDur(AnWinP);
else 
    listEntry.SptP = {};
    listEntry.seqIdP = '';
    listEntry.indepValP = [];
    listEntry.indepUnitP = '';
    listEntry.WinDur(1) = NaN;
end

if ~isnan(listEntry.iseqn) & ~isnan(listEntry.isubseqn) %#ok<AND2>
    dsN = dataset(listEntry.filename, listEntry.iseqn); 
    AnWinN = ExpandAnWin(dsN, AnWin);
    listEntry.icell = dsN.icell;
    listEntry.SptN   = ANWIN(dsN.spt(listEntry.isubseqn, :), AnWinN);
    listEntry.indepValN = dsN.indepval(listEntry.isubseqn);
    listEntry.indepUnitN = dsN.indepunit;
    listEntry.seqIdN = dsN.SeqID;
    %Duration of analysis window in ms ...
    listEntry.WinDur(2) = GetAnWinDur(AnWinN);
else
    listEntry.SptN = {};
    listEntry.seqIdN = '';
    listEntry.indepValN = [];
    listEntry.indepUnitN = '';
    listEntry.WinDur(2) = NaN; 
end