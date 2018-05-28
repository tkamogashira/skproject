function s = paramString(X,unit, defaultStr);
% paramString - summarize parameter value(s) in char string
%   usage: paramString(X,unit, defaultStr);
%   X must be scalar, 1x2 vector (dual-channel param), 
%   column vector (varied param) or Nx2 matrix (dual channel varied param)

if nargin<2, unit = ''; end
if nargin<3, defaultStr = ''; end
if all(isnan(X(:))), 
   s = defaultStr;
   % add unit only when defaultstring is specified and unit is non-empty 
   if ~isempty(unit) & nargin>2, s = [s ' ' unit]; end
   return
end

Q = [1;i];
switch size(X)*Q, % hack to use switch 
case [1 1]*Q,
   s = [num2sstr(X)];
case [1 2]*Q,
   if X(1)==X(2), s = num2sstr(X(1));
   else, s = [num2sstr(X(1)) '|' num2sstr(X(2))];
   end
otherwise, % X was varied
   if size(X,2) == 1,
      X = sort(denan(X));
      s = num2sstr(X,1); % try smart display a la 10:5:25
      if isempty(findstr(s,':')), % smart stuff failed
         s = [num2sstr(X(1)) '::' num2sstr(X(end))];
      end
      % trivial case: all elements are equal
      if length(unique(X))==1, s = num2sstr(X(1)); end
   else, % Nx2 matrix
      if isequal(X(:,1), X(:,2)), % columns are equal, only display one
         Col = sort(denan(X(:,1))); % first column without NaNs
         s = num2sstr(Col,1); % try smart display a la 10:5:25
         if isempty(findstr(s,':')), % smart stuff failed
            s = [num2sstr(Col(1)) '::' num2sstr(Col(end))];
         end
         % trivial case: all elements are equal
         if length(unique(Col))==1, s = num2sstr(Col(1)); end
      else, % display most interesting column but warn that that is not all
         C{1} = sort(denan(X(:,1))); % first column without NaNs
         C{2} = sort(denan(X(:,2))); % 2nd column without NaNs
         [dum icol] = max([std(C{1}) std(C{2})]);
         Col = C{icol};
         s = num2sstr(Col,1); % try smart display a la 10:5:25
         s = strsubst(s,':', '*:'); % put asterisks to warn that info is incomplete
         if isempty(findstr(s,':')), % smart stuff failed
            s = [num2sstr(Col(1)) ':*:' num2sstr(Col(end))];
         end
         % trivial case: all elements are equal
         if length(unique(Col))==1, s = num2sstr(Col(1)); end
      end
   end
end % switch/case

% add unit only when requested
if ~isempty(unit), s = [s ' ' unit]; end

