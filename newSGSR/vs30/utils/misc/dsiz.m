function dsiz(varargin);
% DSIZ - display size of variable
for ii=1:nargin,
   disp(['Size of ' inputname(ii) ': [' trimspace(num2str(size(varargin{ii}))) ']' ]);
end
