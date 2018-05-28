function N=DAchanNaming;
% DAchanNaming - naming conventions for D/A channels
%   DAchanNaming returns a struct whose fieldnames are the
%   valid methods for specifying DA channels.
%   Each field is a 1x3 char cell array that contains
%   the respective expressions for {'Left' 'Right' 'Both'}.
 
N.chanNum =  { 1       2      0     3};
N.LRB =      {'L'     'R'    'B'   'N'};
N.chanName = {'Left' 'Right' 'Both' 'None'};
% define left/right in terms of recording side.
try, IPS = ipsiside; catch IPS = nan; end
if isnan(IPS),
   N.recSide  = {'N/A' 'N/A' 'Both' 'None'};
elseif isequal('L', ipsiside),
   N.recSide  = {'Ipsi' 'Contra' 'Both' 'None'};
else,
   N.recSide  = {'Contra' 'Ipsi' 'Both' 'None'};
end
N.nan =      {nan     nan      nan  nan};
