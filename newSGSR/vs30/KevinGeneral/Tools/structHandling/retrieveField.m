function outCol = retrieveField(S, fieldName, inputcell)
% RETRIEVEFIELD Retrieves a field from a structure or a structure array
%
% argOut = retrieveField(S, fieldName)
%  Retrieves the field fieldName from structure S. fieldName can contain a
%  '.' symbol, meaning the structure is branched.
%  In se, this function does the same as getfield, except for the branched
%  part.
%  For a structure array, a column is returned.
%  The boolean variable inputcell defines whether the output is a cell (default)
%  or a regular array.

% ---------------- CHANGELOG -----------------------
%  Mon Jan 31 2011  Abel   
%   added cell array support

[ x y ] = size(S);
if y > x
    S = S';
end

if nargin < 3
    inputcell = true;
end

%By Abel: support for cell arrays
if iscell(fieldName)
	for n = 1:length(fieldName)
		outCol{n} = retrieveField(S, fieldName{n}, inputcell);
	end
	return;
end


dotPos = [0 strfind(fieldName, '.')];
if inputcell
    if isequal(length(S), 1)
        outCol{1,1} = 0;
    else
        outCol = cell(length(S),1);
    end
else
    outCol = zeros(length(S),1);
end

if ~isequal(0, dotPos)
    for cRow = 1:length(S)
        childStruct = S(cRow);
        for cDot = 1:(length(dotPos)-1)
            childStruct = childStruct.(fieldName(( dotPos(cDot)+1 ):( dotPos(cDot+1)-1 )));
        end
        tempOutCol = childStruct.(fieldName(dotPos(end)+1:end));
        if inputcell
            outCol{cRow,1} = tempOutCol;
        else
            outCol(cRow,1) = tempOutCol;
        end
    end
else
    for cRow = 1:length(S)
        tempOutCol = getfield(S, {cRow,1}, fieldName);
        if inputcell
            outCol{cRow,1} = tempOutCol;
        else
            outCol(cRow,1) = tempOutCol;
        end
    end
end

%outCol = outCol';
