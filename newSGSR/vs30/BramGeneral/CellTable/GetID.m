function [ErrText, dsID] = GetID(DataFile, CellNr, StimType, DirInfo)
%GETID  gives dsID of Cell in DataFile for a specific stimulus type.
%   [ErrText, dsID] = GETID(DataFile, CellNr, StimType, DirInfo) 

ErrText = []; dsID = [];

SParam  = CollectInStruct(DataFile, CellNr);
TestNrs = FromCacheFile(DirInfo.IndexFile, SParam);
if isempty(TestNrs), ErrText = ['Cell Nr <' int2str(CellNr) '> doesn''t exist in ' DataFile '.']; return; end
TestNrs = GetTestNrs(DataFile, CellNr, StimType, DirInfo);
if isempty(TestNrs), ErrText = ['No ' StimType '-data present for ' DataFile ' <' int2str(CellNr) '>.']; return; end

if length(TestNrs) == 1
    dsID = [ int2str(CellNr) '-' int2str(TestNrs) ];
else
    ErrText = ['Multiple ' StimType '-entries present for ' DataFile ' <' int2str(CellNr) '>: ' int2str(TestNrs')];
end
