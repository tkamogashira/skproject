function dispStruct(s, nIndent);

% dispStruct - display fields of struct with specified indentation
if nargin<1, error('not enough input args'); end;
if nargin<2, nIndent = 0; end;
if ~isstruct(s), error('non-struct arg'); end;

fln = fieldnames(s);
Nf = length(fln);
ln = 10; % assumed max length of fieldnames
for ifl = 1:Nf,
   ln = max(ln, length(fln{ifl}));
end
nin = blanks(nIndent);
for ifl = 1:Nf,
   header = [nin rightfill(fln{ifl}, ln) ': '];
   tailer = [nin rightfill(mstr('-',length(fln{ifl})), ln) '- '];
   vv = getfield(s, fln{ifl});
   [s1 s2] = size(vv);
   if s1~=1,
      if s2==1, disp([header '[' num2str(vv') ']''']);
      else, disp([header num2str(s1) '-by-' num2str(s2) ' thing']);
      end
   elseif isstruct(vv),
      disp(header);
      dispStruct(vv, nIndent+5);
      disp(tailer); 
   elseif iscell(vv),
      Nvv = length(vv);
      for ivv=1:Nvv,
      	disp([header '{' num2str(ivv) '}']);
   	   dispStruct(vv{ivv}, nIndent+5);
	      disp(tailer); 
      end
   else
      disp([header num2str(vv)]);
   end
end





%-----
function r=rightfill(s,n);
r = [blanks(n-length(s)) s];
function ms=mstr(c,m);
ms=blanks(m);
ms(:)=c;

