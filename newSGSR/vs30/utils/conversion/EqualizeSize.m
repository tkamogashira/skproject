function varargout = EqualizeSize(varargin);

% EqualizeSize - make set of variables equal in size

if nargout~=nargin,
   error('# input args ~= # output args');
end

N = nargin;
sizes=zeros(N,2);
for iarg=1:N,
   sizes(iarg,:) = size(varargin{iarg});
end
% check sizes
rows = sizes(:,1);
columns = sizes(:,2);
Nrows = max(rows);
Ncolumns = max(columns);
if any((rows~=Nrows) & (rows~=1)),
   error('unequal row multiplicities');
end
if any((columns~=Ncolumns) & (columns~=1)),
   error('unequal column multiplicities');
end

% now fill the argouts
for iarg=1:N,
   for irow=1:Nrows,
      for icol=1:Ncolumns,
         varargout{iarg}(irow,icol) = ...
            varargin{iarg}(min(rows(iarg),irow), min(columns(iarg),icol));
      end
   end
end




