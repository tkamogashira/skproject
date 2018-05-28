function ts = TwoSS1s

% returns boolean indicating if two SS1s are present

persistent TS % don't need to look for file each time

if isempty(TS),
   % a single SS1 is the exception 
   TS = ~exist('E:\backups\MLsig','dir') & ~isequal('OOR', CompuName);
end;

ts = TS;
