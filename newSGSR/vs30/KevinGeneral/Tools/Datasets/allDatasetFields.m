function [outFields, ignoreFN] = allDatasetFields

datFiles = dir([datadir '\*.dat']);
[outFields, ignoreFN] = getDSFields(datFiles);

% outFields = {}; ignoreFN = {};

datFiles = dir([dataDir '\*.spk']);
[O, I] = getDSFields(datFiles);
outFields = [outFields; O];
ignoreFN = [ignoreFN; I];

outFields = unique(outFields);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outFields, ignoreFN] = getDSFields(datFiles)

outFields = {};
H = waitbar(0, 'Collecting fields: 0 %');

ignoreFN = {};
for cDat = 1:length(datFiles)
    FN = datFiles(cDat).name(1:end-4);

    P = cDat / length(datFiles);
    H = waitbar(P, H, ['Collecting fields: ' num2str(cDat) ' of ' num2str(length(datFiles)) ' (' num2str(P*100) ' %)' ]);
    disp(['Progress: ' num2str(cDat) ' of ' num2str(length(datFiles)) ' (' num2str(P*100) ' %)' ]);
       
    try
        LUT = log2lut(FN);
        iSeq = [LUT.iSeq]';
        for cSeq = 1:length(iSeq)
            try
                ds = dataset(FN, iSeq(cSeq));
                outFields = [outFields; fieldNamesDeep(ds)];
                disp(['Processed ' FN ' - ' num2str(iSeq(cSeq)) '...']);
            catch
                disp(['Ignoring ' FN ' - ' num2str(iSeq(cSeq)) '...']);
                disp(lasterr);
                ignoreFN = [ignoreFN; FN ' - ' num2str(iSeq(cSeq))];
            end            
        end
    catch
        disp(['Ignoring ' FN '...']);
        disp(lasterr);
        ignoreFN = [ignoreFN; FN];
    end
    fclose all;
end

delete(H);