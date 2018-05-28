function uiview(varargin);
uipaste(1,varargin{:});
if nargin>0,
   if ischar(varargin{1}),
      global LastUIviewed
      LastUIviewed = varargin{1};
   end
end