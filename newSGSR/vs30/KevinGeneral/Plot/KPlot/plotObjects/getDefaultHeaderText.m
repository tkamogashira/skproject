function headerStr = getDefaultHeaderText(ds)
% GETDEFAULTHEADERTEXT returns the default text for a HeaderObject

%% first column
filename = upper(ds.FileName);
fileformat = upper(ds.FileFormat);
seqid = sprintf('%s (%d)', ds.SeqID, ds.iSeq);
stimtype = upper(ds.StimType);
rectime = datestr(datenum(ds.Time(3), ds.Time(2), ds.Time(1)), 1);

firstCol = sprintf([' FileName \n FileFormat \n SeqID (iSeq) \n StimType ' ...
    '\n RecTime | %s \n %s \n %s \n %s \n %s '], ...
    filename, fileformat, seqid, stimtype, rectime);

%% second column
if strcmpi(ds.FileFormat, 'EDF') && (ds.indepnr == 2)
    labels = {' Channels \n', ' NSubSeqs/NReps \n', ' IndepVar \n', ...
        ' IndepRange | %s \n %s \n %s \n %s '};
    values = {Channel2Str(ds), sprintf('%d/%d x %d', ds.nrec, ds.nsub, ds.nrep), ...
        [ds.xname '/' ds.yname], indepVar2Str(ds.EDFIndepVar(1)), ...
        indepVar2Str(ds.EDFIndepVar(2))};
else
    labels = {' Channels \n', ' NSubSeqs/NReps \n', ' IndepVar \n', ...
        ' IndepRange \n', ' SPL | %s \n %s \n %s \n %s \n %s '};
    values = {Channel2Str(ds), sprintf('%d/%d x %d', ds.nrec, ds.nsub, ds.nrep), ...
        ds.indepname, indepVar2Str(ds.indepvar), spl2Str(ds)};
end

secondCol = sprintf([labels{:}], values{:});

%% third column
%To be sure frequency conventions are equal between EDF and
%SGSR/Pharmington datasets ...
S = GetFreq(ds);
%Displaying only the appropriate beat frequency ...
nrec = ds.nrec;
if all(isnan(S.BeatFreq(1:nrec))) && all(isnan(S.BeatModFreq(1:nrec)))
    BeatFreq = NaN;
elseif ~all(isnan(S.BeatModFreq(1:nrec)))
    %Beat on modulation frequency has priority over carrier frequency ...
    BeatFreq = S.BeatModFreq;
else
    BeatFreq = S.BeatFreq;
end
thirdCol = sprintf([' BurstDur \n RepDur \n CarFreq \n ModFreq \n BeatFreq |' ...
    ' %s \n %s \n %s \n %s \n %s '], ...
    timeVar2Str(ds.burstdur), timeVar2Str(ds.repdur), ...
    freqVar2Str(S.CarFreq(1:nrec, :)), freqVar2Str(S.ModFreq(1:nrec, :)), ...
    freqVar2Str(BeatFreq));

%% putting it all together
headerStr = [firstCol '|' secondCol '|' thirdCol];
