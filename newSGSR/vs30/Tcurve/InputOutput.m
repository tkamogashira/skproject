function SpikeRate = InputOutput(SPL, varargin);
% InputOutput - simulated input-output function for auditory nerves
persistent RSPONT TRANS SLOPE THR MAXRATE
if isnan(SPL), % initialize
   RSPONT = varargin{1};
   SLOPE = varargin{2};
   TRANS = varargin{3};
   THR = varargin{4};
   MAXRATE = varargin{5};
   if nargin>6,
      spl = THR+ TRANS*linspace(-0.5,2);
      figure(varargin{5}); xplot(spl,inputoutput(spl), varargin{6});
   end
   return;
end
xn = (SPL-THR)/TRANS;
i1= 0+(xn>0)&(xn<1);
i2 = 0 + (xn>1);
y = (i1.*0.5.*xn.^2 + i2.*(xn-0.5));
SpikeRate = min(MAXRATE, RSPONT+ TRANS*SLOPE*y);
