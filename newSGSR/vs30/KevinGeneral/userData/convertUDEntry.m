function convertUDEntry(fileName)

UD = getuserdata_old(fileName);

if mym(10, 'status')
    mym(10, 'open', 'lan-srv-01.med.kuleuven.be', 'audneuro', '1monkey');
    mym(10, 'use ExpData');
end

%% SQL transactions
mym(10,'START TRANSACTION;');

try
    fileName = lower(fileName);

    mym(10,['DELETE FROM UserData_BadSubSeq WHERE FileName = "' fileName '";']);
    mym(10,['DELETE FROM UserData_Cell WHERE FileName = "' fileName '";']);
    mym(10,['DELETE FROM UserData_CellCF WHERE FileName = "' fileName '";']);
    mym(10,['DELETE FROM UserData_DS WHERE FileName = "' fileName '";']);
    mym(10,['DELETE FROM UserData_Exp WHERE FileName = "' fileName '";']);


    [fieldString, valueString] = queryStrings(UD.Experiment, fileName);
    if ~isempty(fieldString)
        mym(10,['INSERT INTO UserData_Exp (' fieldString ') VALUES (' valueString ');']);
    end

    for cDS = 1:length(UD.DSInfo)
        [fieldString, valueString] = queryStrings(UD.DSInfo(cDS), fileName);
        fieldString = strrep(fieldString, 'Ignore', 'Ignore_DS');
        if ~isempty(fieldString)
            mym(10,['INSERT INTO UserData_DS (' fieldString ') VALUES (' valueString ');']);
        end

        BadSubSeqs = UD.DSInfo(cDS).BadSubSeq;
        for cBad = 1:length(BadSubSeqs)
            try
                mym(10,['INSERT INTO UserData_BadSubSeq VALUES ("' fileName '",' num2str(UD.DSInfo(cDS).SeqNr) ',' num2str(BadSubSeqs(cBad)) ', 1);'])
            catch
                if ~strfind(lasterr, 'foreign') % ignore foreign keys
                    error(lasterr);
                end
            end
        end
    end

    for cCell = 1:length(UD.CellInfo)
        [fieldString, valueString] = queryStrings(UD.CellInfo(cCell), fileName);
        fieldString = strrep(fieldString, 'Ignore', 'Ignore_Cell');
        if ~isempty(fieldString)
            mym(10,['INSERT INTO UserData_Cell (' fieldString ') VALUES (' valueString ');']);
        end
        
        if ~isempty(UD.CellInfo(cCell).THRSeq) & ~isnan(UD.CellInfo(cCell).THRSeq)
            setTHRSeq(fileName, UD.CellInfo(cCell).Nr, UD.CellInfo(cCell).THRSeq);
        end
    end
    
    mym(10,'COMMIT;');
catch
    mym(10,'ROLLBACK;');
    error(lasterr);
end




function [fieldString, valueString]  = queryStrings(inStruct, fileName)

inStruct.Name = fileName;
fields = fieldnames(inStruct);
fieldString = '';
valueString = '';
for cField = 1:length(fields)
    if isempty(strfind('badsubseq', lower(fields{cField}))) & ...
            ~isequal('dsid', lower(fields{cField})) & ...
            ~isequal('thrseq', lower(fields{cField})) & ...
            ~isequal('badsubsubseq1', lower(fields{cField})) & ...
            ~isequal('badsubsubseq2', lower(fields{cField}))
        fieldString = [fieldString ',' fields{cField}];

        thisValue = getfield(inStruct, fields{cField});
        if isnumeric(thisValue)
            thisValue = num2str(thisValue);
            thisValue = lower(thisValue);
            thisValue = strrep(thisValue, 'nan', 'null');        
        else
            thisValue = ['"' thisValue '"'];
        end
        thisValue = strrep(thisValue, '\', '\\');

        valueString = [valueString ',' thisValue];
    end
end
fieldString = fieldString(2:end);
fieldString = strrep(fieldString, 'Name', 'FileName');
fieldString = strrep(fieldString, 'SeqNr', 'iSeq');
valueString = valueString(2:end);