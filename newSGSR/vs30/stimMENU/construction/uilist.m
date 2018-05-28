function L=uilist(figh);

% lists subunits
if nargin<1, figh=gcf; end;

% get subunits
SU = uigetSU(figh);
% display them
LL = '';
LL = strvcat(LL, ['---' get(figh,'name') '----']);
N = length(SU);
for ii=1:N,
   if isfield(SU{ii},'filename'),
      li = [num2str(ii) ': ' RemoveFileExtension(SU{ii}.filename)];
      LL = strvcat(LL,li);
   end
end
if nargout<1,
   disp(LL);
else,
   L = LL;
end
