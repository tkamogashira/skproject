function Str = DealStructCommandStr(s);

% puts parameters in structure
% with fieldnames equal to the names of the passed variables

nn = inputname(1);
if isempty(nn),
   error('struct has no name');
end
NN = [ ' = ' nn '.'];
Str = '';
FNS = fieldnames(s);
for ii=1:length(FNS),
   Str = [Str FNS{ii} NN FNS{ii} '; '];
end


