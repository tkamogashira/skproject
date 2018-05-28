function IDV = CreateIndepVarStruct(Name, ShortName, Values, Unit, PlotScale);
% CreateIndepVarStruct - creates standard struct in which single independent var is described
%   SYNTAX:
%   IDV = CollectInStruct(Name, ShortName, Values, Unit, PlotScale);


if nargin<5, PlotScale='linear'; end;
if isempty(Unit), Unit = ''; end;
% trivial but needed as a bottleneck to standardize this info 
IDV = CollectInStruct(Name, ShortName, Values, Unit, PlotScale);
