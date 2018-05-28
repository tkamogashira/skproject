function varS = packSCHFields

varC = evalin('caller', 'who;');
idx = find(strcmp(varC, upper(varC)));
varS = evalin('caller', sprintf('CollectInStruct(%s);', formatcell(varC(idx), {'', ''}, ',')));