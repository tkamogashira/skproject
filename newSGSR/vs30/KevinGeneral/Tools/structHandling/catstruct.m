function outStruct = catstruct(inStruct, inTable)
% CATSTRUCT - Concatenate rows from a structure array according to a table
%
%   outStruct = catstruct(inStruct, inTable)
%     inStruct:  a structure array, containing fields "filename" and
%                "seqid"
%      inTable:  a cell array containing pairs of filename and sequence id.
%                e.g.: inTable = 
%                       'R99009'    '25-10-MOV1'    'R99009'    '25-11-MOV-1'
%                       'R99039'    '12-5-MOV1'     'R99039'	'12-6-MOV-1' 
%                       ...
%    outStruct:  a structure array containing all the row pairs indicated
%                in inTable. The structure contains a structure 'A',
%                indicated by the first two columns of inTable, and a
%                structure 'B' indicated by the last two columns.

outStruct = struct([]);
for cRow = 1:size(inTable, 1)
    structRow = 'error';
    for cStruct = 1:size(inStruct, 1)
        if ~isequal(inStruct(cStruct).ds1.filename, inTable{cRow, 1})
            continue
        end
        if ~isequal(inStruct(cStruct).ds1.seqid, inTable{cRow, 2})
            continue
        end
        
        structRow = cStruct;
        break;
    end    
    if isequal('error', structRow)
        error(['There was an error in the table at row number ' num2str(cRow) ' DS: ' inTable{cRow, 1} ' DF: ' inTable{cRow, 2} ]);
    else
        tempStruct1 = inStruct(structRow);
    end
    
    structRow = 'error';
    for cStruct = 1:size(inStruct, 1)
        if ~isequal(inStruct(cStruct).ds1.filename, inTable{cRow, 3})
            continue
        end
        if ~isequal(inStruct(cStruct).ds1.seqid, inTable{cRow, 4})
            continue
        end
        
        structRow = cStruct;
        break;
    end    
    if isequal('error', structRow)
        error(['There was an error in the table at row number ' num2str(cRow) ' DS: ' inTable{cRow, 3} ' DF: ' inTable{cRow, 4} ]);
    else
        tempStruct2 = inStruct(structRow);
    end
    
    newStruct.A = tempStruct1;
    newStruct.B = tempStruct2;
    
    outStruct = [outStruct; newStruct];
end