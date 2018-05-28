function ss=SelectFromStruct(s,varargin);
% SelectFromStruct(S,FIELDNAME1,...)
fns = varargin;
for ii=1:length(fns),
   fn = fns{ii};
   eval(['ss.' fn '= s.' fn ';']);
end
if isempty(fns); ss = []; end;


