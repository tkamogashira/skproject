function dbn = DAMAsubBuffer(ParentDBN, offset, Len);

% DAMAsubBuffer - returns dbn pointing to a subset of the samples stored in ParentDBN; no net memory allocated
% severe hack!

% allocate buffer to get correct # samples
dbn = ml2dama(zeros(1,Len));
% immediately deallot (the trick is: the # samples associated with dbn will survive)
s232('deallot',dbn);
% now set the address to the start of ParentDBN + 2*offset (factor 2: 16 bit word = 2  bytes)
Paddress = s232('getaddr',ParentDBN);
s232('setaddr', dbn, Paddress+2*offset);


