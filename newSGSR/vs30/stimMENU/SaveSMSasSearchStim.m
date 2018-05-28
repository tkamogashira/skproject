function SaveSMSasSearchStim;
% SaveSMSasSearchStim - save global var SMS as search stimulus
searchDir = [UIdefDir '\Search'];
if ~exist(searchDir,'dir'),
   mkdir(UIdefDir, 'Search');
end
[fn pn] = uiputfile([searchDir '\.sdef'], 'Select filename for search parameters');
if isequal(fn,0), return; end;
global SMS
[PP NN EE] = fileparts([pn fn]);
EE = '.sdef'; % force correct extension
save(fullfile(PP, [NN EE]),'SMS');
