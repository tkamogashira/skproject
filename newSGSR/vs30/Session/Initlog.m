function InitLog(Nlog);

global LOG;
if nargin<1, Nlog = 1024; end;

LOG = [];
LOG.N = Nlog;
LOG.Contents = cell(1,Nlog);
LOG.First = 1;
LOG.Last = 0;
LOG.Full = 0;

% the following doesn't work!! results in N & Last being arrays!
% LOG = struct('N',Nlog, 'Contents',cell(1,Nlog), 'Last', 0);


