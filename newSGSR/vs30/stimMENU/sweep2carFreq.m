function carFreqs = sweep2carFreq(lofreq, dfreq, hifreq, logSteps, chan);

% returns carrier frequencies from freq-sweep params as Nx2 matrix
% (columns are channels)
% no size checking, etc (should be handled by frequencysweepcheck)


if nargin<4, logSteps=0; end;
if nargin<5, chan=0; end;

chan = channelNum(chan);

if size(lofreq,2)==1, % duplicate to get 2 identical channels
   lofreq = [1 1]*lofreq;
   dfreq = [1 1]*dfreq;
   hifreq = [1 1]*hifreq;
elseif chan~=0, % other way around: single active chan but double specs
   lofreq = [1 1]*lofreq(chan); % duplicate the active channel
   dfreq =  [1 1]*dfreq(chan);
   hifreq = [1 1]*hifreq(chan);
end
   
if logSteps, % convert to octaves re 1 Hz
   lofreq = log2(lofreq);
   hifreq = log2(hifreq);
end

dfreq = abs(dfreq).*sign(hifreq-lofreq); 
dfreq(find(dfreq==0)) = 1;
cfleft = lofreq(1):dfreq(1):hifreq(1);
cfrite = lofreq(2):dfreq(2):hifreq(2);
if logSteps, % convert back to Hz
   cfleft = pow2(cfleft);
   cfrite = pow2(cfrite);
end

% force sweeps of both channels to have equal # elements
cfleft = cfleft + 0*cfrite;
cfrite = 0*cfleft + cfrite;

% put in Nx2 matrix
carFreqs = [cfleft.' , cfrite.' ];



