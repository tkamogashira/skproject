function dstr = SGSRdisp(ds);
% displays stimulus params of single SGSR-style data set

if ~isequal('SGSR',ds.fileformat),
   error('Non-SGSR file format');
end

STR = '';
pp = ds.stimparam;
if isfield(pp,'dummy'),
   pp = rmfield(pp,'dummy');
end
fns = fieldnames(pp);
maxWidth = 0;
for ii=1:length(fns),
   fn = fns{ii};
   maxWidth = max(maxWidth, length(fn));
   fv = getfield(pp, fn);
   fvs = '??';
   try,
      if isempty(fv), fvs = [];
      elseif isnumeric(fv)&(length(fv)>1), fvs = ['[' num2sstr(fv) ']'];
      elseif isnumeric(fv), fvs = num2sstr(fv);
      elseif ischar(fv), fvs = ['''' fv ''''];
      else, fvs = char(fv);
      end
   end
   if length(fvs)>40, fvs = [fvs(1:35) ' .. ' fvs(end)]; end
   FSV{ii,1} = [': ' fvs];
end
for ii=1:length(fns),
   fn = fns{ii};
   FN{ii,1} = fixlenstr(fn, maxWidth+3,1);
end
STR = [char(FN) char(FSV)];
if nargout>0, dstr=STR;
else disp(STR);
end
