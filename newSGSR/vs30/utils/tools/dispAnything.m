function dispAnything(x, Name, nInd);

if nargin<2, 
   header = inputname(1); 
else,
   header = Name;
end
if ~isempty(header),
   header = [header ':'];
end;
if nargin<3, 
   nInd = 0;
   hblank = '';
   bblank = blanks(5);
else,
   hblank = blanks(nInd);
   bblank = blanks(5+nInd);
end
disp([hblank header]);

INDinc = 3;

if isnumeric(x),
   [Rx Cx] = size(x);
   if (Rx==1), disp([bblank '[' num2str(x) ']']);
   elseif (Cx==1), disp([bblank '[' num2str(x.') '].''']);
   else, disp([bblank num2str(Rx) 'x' num2str(Cx) ' double']);
   end
elseif isstr(x),
   [Rx Cx] = size(x);
   if (Rx==1), disp([bblank '''' num2str(x) '''']);
   elseif (Cx==1), disp([bblank '''' num2str(x.') '''.''']);
   else, disp([bblank num2str(Rx) 'x' num2str(Cx) ' char']);
   end
elseif isstruct(x),
   Fns = fieldnames(x);
   for ii=1:length(Fns),
      dispAnything(getfield(x,Fns{ii}),Fns{ii},nInd+INDinc);
   end
end









