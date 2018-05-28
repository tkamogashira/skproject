function RAPStat = SwapRAPDataSets(RAPStat)
%SwapRAPDataSets   Swaps foreground and background datasets and accompanying 
%                  calculation parameters
%   RAPStat = SwapRAPDataSets(RAPStat)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 25-03-2004

%Swapping actual datasets ...
GenParam = RAPStat.GenParam;
[GenParam.SeqNr, GenParam.SeqNr2] = Swap(GenParam.SeqNr, GenParam.SeqNr2);
[GenParam.DS, GenParam.DS2]       = Swap(GenParam.DS, GenParam.DS2);
RAPStat.GenParam = GenParam;

%Swapping accompanying calculation parameters ...
CalcParam = RAPStat.CalcParam; CalcParam2 = RAPStat.CalcParam2;
[CalcParam.SubSeqs, CalcParam2.SubSeqs]   = Swap(CalcParam.SubSeqs, CalcParam2.SubSeqs);
[CalcParam.Reps, CalcParam2.Reps]         = Swap(CalcParam.Reps, CalcParam2.Reps);
[CalcParam.AnWin, CalcParam2.AnWin]       = Swap(CalcParam.AnWin, CalcParam2.AnWin);
[CalcParam.ReWin, CalcParam2.ReWin]       = Swap(CalcParam.ReWin, CalcParam2.ReWin);
[CalcParam.ConSubTr, CalcParam2.ConSubTr] = Swap(CalcParam.ConSubTr, CalcParam2.ConSubTr);
[CalcParam.MinISI, CalcParam2.MinISI]     = Swap(CalcParam.MinISI, CalcParam2.MinISI);
RAPStat.CalcParam = CalcParam; RAPStat.CalcParam2 = CalcParam2;