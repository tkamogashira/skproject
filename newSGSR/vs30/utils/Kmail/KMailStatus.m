function bStatus = KMailStatus()
% KMailStatus - network status of Kmail
%   status  = KMailStatus()
%     Get status of KMail status.
%     Returns a bool value
%
%   See also Kmail.

% The mailbox for this computer
thisMailbox = strrep(CompuName, '-', '_');

bStatus = sign(exist([KMailServer thisMailbox], 'dir'));