function d = HarrisDataset(FN, dsid)

if ~isHarris(FN)
    error('Not a Harris dataset')
end

file = parseEDFFileName(FN);
lookUpTable = log2lut(FN);

% if dsid is just a sequence number in a string, convert to a number
if ischar(dsid)
    [dsidNum, succesNum] = str2num(dsid);
    if succesNum & isequal(num2str(dsidNum), dsid)
        dsid = dsidNum;
    end
end

% if it is a sequence number, convert to a dataset id
if isnumeric(dsid)
    idx = find([lookUpTable.iSeq] == dsid);
    dsid = lookUpTable(idx).IDstr;
end

% does this index exist?
dsid = strtrim(dsid);
iSeq = find(strcmp(cellstr(char(lookUpTable.IDstr)), dsid));
if isempty(iSeq)
    error('Dataset with given ID does not exist.');
end

dsStruct = struct(dataset);

% fill the structure with data
[ner, numv, extyp, nameStr] = audvarnames(file, dsid);
if ner
    error(['An error occurred in AudMAT: error number ' num2str(ner)]);
end

[ner,nreps,numv,x,y,z]=audvarrange2(file,dsid);
if ner
    error(['An error occurred in AudMAT: error number ' num2str(ner)]);
end

if numv < 2 | numv > 3
    error('Can''t handle this dataset, it should have 2 or 3 paramters.');
end

for cName = 1:numv
    nameStr = strtrim(nameStr);
    spaces = findstr(nameStr, ' ');
    names{cName} = nameStr( 1:(spaces(1)-1) );
    nameStr = nameStr(spaces(1):end);
end

Xname = names{1};
Xrange = [x(1) x(2)];
Xstep = x(3);

Yname = names{2};
Yrange = [y(1) y(2)];
Ystep = y(3);

if isequal(3, numv)
    Zname = names{3};
    Zrange = [z(1) z(2)];
    Zstep = z(3);
end

for cXrange = Xrange(1):Xstep:Xrange(2)
    for cYrange = Yrange(1):Ystep:Yrange(2)
        if isequal(2, numv)
            Stim = [cXrange, cYrange];
            [ner,nreps,Nspk,Times]=audspktimes(file, dsid,Stim,numv,1)
        elseif isequal(3, numv)
            for cZrange = Zrange(1):Zstep:Zrange(2)
                Stim = [cXrange, cYrange, cZrange];
                [ner,nreps,Nspk,Times]=audspktimes(file, dsid,Stim,numv,1)
            end
        end
    end
end

% [ner,mstim,sstim,mgwid,sgwid]=audstimgw(file,dsid)



d = dataset(dsStruct, 'convert');

function errorHarris(ner)
if ner
    error(['There was an error reading the Harris dataset. Error number: ' num2str(ner)]);
end