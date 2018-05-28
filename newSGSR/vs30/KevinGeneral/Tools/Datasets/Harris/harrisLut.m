function lut = harrisLut(FN)

if ~isHarris(FN)
    error('Not a Harris data file.');
end

file = parseEDFFileName(FN);

lut = struct('iSeq', {}, 'iSeqStr', {}, 'IDstr', {});

IDstr = ' ';
ner = 0;
iSeq = 0;
disp('Scanning harris dataset...');
while ~ner
    iSeq = iSeq + 1;
    iSeqStr = num2str(iSeq);
    [ner, newIDstr] = audnextdsid(file, IDstr);
    if isequal(newIDstr, IDstr)
        ner = 1;
    else
        IDstr = newIDstr;
    end

    if ~ner
        lut(iSeq).iSeq      = iSeq;
        lut(iSeq).iSeqStr   = iSeqStr;
        lut(iSeq).IDstr     = IDstr;
    end
end
disp(sprintf('\nDone scanning harris dataset.'));