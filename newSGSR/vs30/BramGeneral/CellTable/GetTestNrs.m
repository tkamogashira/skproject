function TestNrs = GetTestNrs(DataFile, CellNr, StimType, DirInfo);
%GETTESTNRS gives Test Numbers of Cell in DataFile for a specific Stimulus Type.
%   TestNrs = GETTESTNRS(DataFile, CellNr, StimType, DirInfo)

SParam  = CollectInStruct(DataFile, CellNr);
TestNrs = FromCacheFile(DirInfo.IndexFile, SParam);

for TestNr = TestNrs'
    SParam = CollectInStruct(DataFile, CellNr, TestNr);
    Data   = FromCacheFile(DirInfo.TableFile, SParam);
    if ~strcmp(upper(Data.StimType), upper(StimType))
        TestNrs(find(TestNrs == TestNr)) = []; 
    end    
end   


