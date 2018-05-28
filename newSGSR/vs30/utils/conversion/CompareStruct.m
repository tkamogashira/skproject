function sc = CompareStruct(s1,s2);

fns = fieldnames(s1);
N = length(fns);
rfn = ['X' num2str(round(1023*sum(clock.^1.28)))];
sc = struct(rfn,'dummy');
for ii=1:N,
   fn = fns{ii};
   if isfield(s2,fn),
      IE = isequal(getfield(s1,fn),getfield(s2,fn));
   else,
      IE = ['absent in ' inputname(s2)];
   end
   sc = setfield(sc,fn,IE);
end
sc = rmfield(sc,rfn);
