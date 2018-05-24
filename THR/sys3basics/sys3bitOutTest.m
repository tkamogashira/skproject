function sys3bitOutTest(Dev, N, enab);  
% sys3bitOutTest - test bit out channels 
%   sys3bitOutTest('RX6', N, 1) switches bit N on.
%   sys3bitOutTest('RX6', N, 0) switches bit N off.
%
%   0<=N<=7. 
%   Arrays are also allowed, as in 
%      sys3bitOutTest('RX6', [2 5 6], [1 0 1])
%   Note: a dedicated test circuit is loaded to the TDT device.

if nargin<3, enab =1; end % default: switch on

if nargin<1, Dev=''; end  

if numel(N)>1,
    [N, enab] = sameSize(N, enab);
    for ii=1:numel(N),
        sys3bitOutTest(Dev, N(ii), enab(ii));
    end
    return;
end
% ======single N from here==============

if ~ismember(N,0:7),
    error('N must be 0,1,2,3,4,5,6, or 7.');
end

sys3loadCircuit('BitOutTest', Dev, 25, 1); % last arg: do recycle
sys3run(Dev);

btag = ['Bit' num2str(N)];
sys3setpar(enab, btag, Dev);








