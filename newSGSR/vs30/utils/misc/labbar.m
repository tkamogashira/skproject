function labbar(x,y,varargin);
% LABBAR - bar plot with arbitrarily spaced x-values or string-valued x-labels
%   Nan for individual x values suppresses the label

N = length(x);
if ~isequal(N,length(y)),
   error('x and y must have same length');
end

if iscell(x),
   Xlabels = x;
else,
   for ii=1:length(x),
      if ~isnan(x(ii)),
         Xlabels{ii} = freqString(x(ii));
      else,
         Xlabels{ii} = '';
      end
   end
end

bar(1:N,y,1,varargin{:});
set(gca, 'xtick', 1:N);
set(gca, 'xticklabel', Xlabels);


