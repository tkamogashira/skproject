function checkStructIn(List) %#ok<INUSL>
% CHECKSTRUCTIN Check if the given struct is in the right format
% (private function)

%Decompose structure-array ...
try
    [Data, FNames] = destruct(List);
catch
    error('Supplied structure-array is invalid.'); 
end

%Check decomposed structure-array ...
if ~all(ismember({'filename', 'iseqp', 'isubseqp', 'iseqn', 'isubseqn'}, ...
        FNames)), 
    error(['Given structure-array must have fieldnames ''filename'', ''iseqp'', ', ...
            '''isubseqp'', ''iseqn'' and ''isubseqn''.']);
end

FileNames = Data(:, find(ismember(FNames, 'filename'))); %#ok<FNDSB>
if ~all(cellfun('isclass', FileNames, 'char'))
    error(['The field with name ''filename'' in the supplied structure-array must ', ...
            'contain entries of class character string.']);
end    
if any(cellfun('isempty', FileNames))
    error(['The field with name ''filename'' in the supplied structure-array cannot ', ...
            'contain empty entries.']);
end

iSeqP = Data(:, find(ismember(FNames, 'iseqp'))); %#ok<FNDSB>
if ~all(cellfun('isclass', iSeqP, 'double')) | ~all(cellfun('prodofsize', iSeqP) == 1) %#ok<OR2>
    error(['The field with name ''iseqp'' in the supplied structure-array can only ', ...
            'contain scalar doubles.']);
else
    iSeqP = cat(1, iSeqP{:}); 
end

iSubSeqP = Data(:, find(ismember(FNames, 'isubseqp'))); %#ok<FNDSB>
if ~all(cellfun('isclass', iSubSeqP, 'double')) | ~all(cellfun('prodofsize', iSubSeqP) == 1) %#ok<OR2>
    error(['The field with name ''isubseqp'' in the supplied structure-array can only ', ...
            'contain scalar doubles.']);
else
    iSubSeqP = cat(1, iSubSeqP{:}); 
end

iSeqN = Data(:, find(ismember(FNames, 'iseqn'))); %#ok<FNDSB>
if ~all(cellfun('isclass', iSeqN, 'double')) | ~all(cellfun('prodofsize', iSeqN) == 1) %#ok<OR2>
    error(['The field with name ''iseqn'' in the supplied structure-array can only ', ...
            'contain scalar doubles.']);
else
    iSeqN = cat(1, iSeqN{:}); 
end

iSubSeqN = Data(:, find(ismember(FNames, 'isubseqn'))); %#ok<FNDSB>
if ~all(cellfun('isclass', iSubSeqN, 'double')) | ~all(cellfun('prodofsize', iSubSeqN) == 1) %#ok<OR2>
    error(['The field with name ''isubseqn'' in the supplied structure-array can only ', ...
            'contain scalar doubles.']);
else
    iSubSeqN = cat(1, iSubSeqN{:}); 
end

%If a row has a NaN for the field 'iseqp' then the field 'isubseqp' is also
%set to NaN and vice versa. This is also applicable to the fields 'iseqn' and
%'isubseqn' ...
idxNaN = find(isnan(iSeqP) | isnan(iSubSeqP));
iSeqP(idxNaN) = deal(NaN); %#ok<FNDSB>
idxNaN = find(isnan(iSeqN) | isnan(iSubSeqN));
iSeqN(idxNaN) = deal(NaN); %#ok<FNDSB>

%A row in the list must specify information on responses to a positive noise
%token, a negative noise token or both. If a row specifies no information at
%all the supplied structure-array is invalid ...
if any(isnan(iSeqP) & isnan(iSeqN))
    error(['The supplied structure-array contains an entry that neither specifies ',...
            'responses to A+, nor to A-.']);
end