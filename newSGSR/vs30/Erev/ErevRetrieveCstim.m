function Cstim = ErevRetrieveCstim(DataFile,iseq, StoreDir);
% ErevRetrieveCstim - retrieve complex erev stimuli stored by ErevStoreCstim
if nargin<3, StoreDir = ErevCstimDir; end;

storemap = [StoreDir '\' DataFile];
if ~exist(storemap,'dir'), mkdir(StoreDir,DataFile); end

FN = [storemap '\Seq' num2str(iseq) '.cstim'];

if ~exist(FN), % try to generate the file
   [SP, isErev] = ErevStoreCstim(DataFile,iseq, StoreDir);
   if ~isErev, error('not an erev sequence'); end
end

qq = load(FN,'-mat'); % this loads variable Cstim
if ischar(qq.Cstim), % reference to other sequence; read that one
   qq = load(qq.Cstim, '-mat');
end
Cstim = qq.Cstim;


