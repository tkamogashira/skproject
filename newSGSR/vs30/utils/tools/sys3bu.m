function sys3BU(Ndays);
% SYS3BU - backup of Sys3 RPvdS circuits
%   SYS3BU copies all .rpx and .cpo files to bigscreen

if ~atSikio,
   error('Sys3bu only works from SIKIO.');
end

more off;
SrcDir = 'C:\SGSR\vs25\phoenix\stimPrepare\sys3\RPvds';
DstDir = 'B:\SGSRdevelop\SGSR\vs25\phoenix\stimPrepare\sys3\RPvds';

EXT = {'rco'  'rpx'};
for iex = 1:length(EXT),
   qq = dir([SrcDir '\*.'  EXT{iex}]);
   for ii=1:length(qq),
      nam = qq(ii).name
      copyfile([SrcDir '\' nam], DstDir);
   end
end





