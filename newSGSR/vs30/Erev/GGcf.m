function GGcf(icell, cf);
% GGcf - set CF of GG variable 
%  usage: GGcf(icell, CF);
%  CF either in Hz or kHz: numbers below 50 are
%  interpreted as kHz
%  CF is stored in kHz in GGxxx variable in caller space

disp('@@@@@@@@@@@@@@@@@@@@@@@@@@@'); pause(0.5); % improve interruptibility

if cf>50, cf = cf/1e3; end % Hz -> kHz

cs = num2str(icell);
if length(cs)<2, cs = ['0' cs]; end
vrn = ['''GG' cs '*'', ''LL' cs '*'', ''AA' cs '*''']; 

cmd = ['who(' vrn ');'];
qqcand = evalin('caller', cmd)';



% icell=11 may not effect GG113, etc
nn = 3+length(cs);
qq = {};
for ii=1:length(qqcand),
   cand = qqcand{ii};
   OK = 0;
   trail = 'x';
   if length(cand)>=nn, 
      trail = cand(nn);
   end
   if ~isdigit(trail),
      qq = {qq{:} cand}; 
   end
end

if isempty(qq), error(['No variables named ' vrn '*.']); end

cfstr = sprintf('%f', cf);
for ii=1:length(qq),
   vrn = qq{ii};
   evalin('caller', ['[' vrn '.CF] = deal(' cfstr ');'])
   evalin('caller', ['[' vrn '.iCell] = deal(' cs ');'])
   evalin('caller', ['[' vrn '.GGname] = deal(''GG' cs ''');'])
end










