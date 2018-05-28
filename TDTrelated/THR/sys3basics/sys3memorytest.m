function okay = sys3memorytest(Tag, Dev);  
% sys3memorytest - memorytest for databuffers
%     sys3memorytest(Tag, Dev) fills the Tagged databuffer with random 
%     numbers, reads them back, and checks for consistency.
%  
%     See also sys3write, sys3read, sys3partag, sys3circuitinfo.  
  
if nargin<2, Dev = ''; end  
okay = 0; % pessimistic default

TagInfo = sys3partag(Dev, Tag);
N = TagInfo.TagSize;

X = double(single(rand(1,N)));
tic;
sys3write(X, Tag, Dev);
Tw = toc; 
tic;
Y = sys3read(Tag, N, Dev);
Tr = toc;
okay = isequal(X,Y);
if ~okay,
    plot(Y-X);
end

Speed_write = round(N/Tw)
Speed_read = round(N/Tr)

okay = okay && (Speed_write> 300e3) && (Speed_read> 1e6);

  
