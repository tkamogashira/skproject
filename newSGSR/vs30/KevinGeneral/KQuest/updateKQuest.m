D{1} = dir([datadir '\*.dat']);
D{2} = dir([datadir '\*.spk']);

faultyOnes = {};
for cDir = 1:2
    for cDF = 1:length(D{cDir})
        FN = D{cDir}(cDF).name(1:end-4);
        disp(['Adding file: ' FN '(' num2str(cDF) '/' num2str(length(D{cDir})) ')']);
        if ~isHarris(FN)
            faultyOnes = [faultyOnes; addToKQuest(FN)];
        end
    end
end