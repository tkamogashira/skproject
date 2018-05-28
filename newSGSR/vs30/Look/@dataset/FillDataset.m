function ds = FillDataset(ds)
% FillDataset - retrieve data removed from dataset by EmptyDataset
%
% See also EmptyDataset

if ~ischar(ds.Data), return; end; % never emptied - no need to fill
FN = ds.ID.FileName;
FFN = [bdatadir '\' FN];
if isempty(dir([FFN '.*'])),
   try
      FFN = ds.ID.FullFileName;
   end
end;
ds = dataset(FFN, ds.ID.iSeq);
