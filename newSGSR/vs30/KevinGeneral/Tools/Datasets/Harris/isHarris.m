function result = isHarris(FN)

if ~isequal(1, nargin) | ~ischar(FN)
    error('One argument is expected: an experiment name.');
end

FullFileName = parseEDFFileName(FN);
if(exist(FullFileName, 'file'))
    [ner,ntype]=audfileformat(FullFileName);
    if isequal(ntype, 21)
        result = 1;
    else
        result = 0;
    end
else
    result = 0;
end