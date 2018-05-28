function ggset(n,prop,value);

global GG
RR = [];
for nn=n,
   try
      set(GG(nn), prop, value);
   catch
      RR = [RR nn];
   end
end
if ~isempty(RR),
   disp('ERROR when setting:');
   disp(RR);
end
