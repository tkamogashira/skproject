function fC = psychometric(x, varargin);
% PSYCHOMETRIC - psychometric test function based on atan
persistent XHALF SLOPE
if isnan(x), % initialize
   XHALF = varargin{1};
   SLOPE = varargin{2};
end
fC = 0.5+(atan((x-XHALF)*SLOPE)/pi);
