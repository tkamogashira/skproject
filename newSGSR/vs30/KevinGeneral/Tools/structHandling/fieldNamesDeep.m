function fieldNamesOut = fieldNamesDeep(inStruct)

fieldNamesOut = {};

FN = fieldnames(inStruct);
for cFN = 1:length(FN)
    if isempty(inStruct)
        fieldContents = 'empty';
    else
        fieldContents = eval(['inStruct.' FN{cFN}]);
    end    
    if isstruct(fieldContents)
        FNSub = fieldNamesDeep(fieldContents);
        for cFNSub = 1:length(FNSub)
            FNSub{cFNSub} = [FN{cFN} '.' FNSub{cFNSub}];
        end               
        fieldNamesOut = [fieldNamesOut; FNSub];
    else
        fieldNamesOut = [fieldNamesOut; FN{cFN}];
    end
end