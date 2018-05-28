function v=isvoid(ds);
% ISVOID - true if dataset is void.
v = isempty(ds.ID);
if ~v,
   try,
      v = isempty(ds.ID.StimType);
   end
end

