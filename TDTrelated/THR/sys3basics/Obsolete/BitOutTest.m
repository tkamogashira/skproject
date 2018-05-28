function BitOutTest(N,T)
%  BitOutTest - test digital out of RX6
%     BitOutTest(N,T) makes bitout N blink with period T ms. 0<=N<=7.
%     Default N=4, T=500 ms.
if nargin<1, N=4; end
if nargin<2, T=500; end

if N<0 || N>7, error('N must be 0,1,2,3,4,5,6, or 7.'); end

sys3loadcircuit('BitOutTest', 'RX6', 50); 
Bstr = ['Bit' num2str(N)]; 
TLstr = ['T' num2str(N) 'L']; THstr = ['T' num2str(N) 'H']; 
sys3setpar(1,Bstr,'RX6');
sys3setpar(T,TLstr,'RX6'); sys3setpar(T,THstr,'RX6');
sys3run('RX6'); 





