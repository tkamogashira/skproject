function cs = ChanOfStruct(s,chan);
% ChanOfStruct - returns first or second row of fields of struct
% s in analogous structure.
% chan = 'L'|'R' ~ 1 | 2
% chan='B' returns s itself
% no recursion
Fns = fieldnames(s);
cs = [];
if isequal(chan,'L'), ichan=1;
elseif isequal(chan,'R'), ichan=2;
elseif isequal(chan,'B'), ichan=1:2;
else error(['invalid chan value ''' chan '']);
end
for ii=1:length(Fns),
   Fn = Fns{ii};
   Fv = getfield(s,Fn);
   if isequal(size(Fv,2),2),
      cs = setfield(cs, Fn, Fv(:,ichan));
   else,
      cs = setfield(cs, Fn, Fv);
   end
end