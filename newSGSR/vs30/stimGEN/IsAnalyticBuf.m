function ia = IsAnalyticBuf(NoiseBuf);
% IsAnalyticBuf - true for analyical RnoiseBuffer 
if nargin<1,
   global RnoiseBuffer  
   BT = RnoiseBuffer.BufType;
else,
   BT = NoiseBuf.BufType;
end

ia = isequal(BT,'anaSpec');