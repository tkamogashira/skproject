%merge file'tje om tabel te maken die leidt tot plot (tr met cte ref=70dB, tr met MBL=70 dB)
% momenteel enkel data van A0241 en A0242, en voor de MBL-slopes enkel responsen op 60,70,80 dB gebruikt (dus enkel MBL's van 70 dB)

echo off;

load pslatgen_all;
DLAT=structfilter(DLAT,'stringpresent(''A0241'',$ds1.filename$)|stringpresent(''A0242'',$ds1.filename$)');

load pstrifvMBL;
D=structfilter(D, 'MBL', 70);

DM=structmerge(DLAT, {'ds1.filename', 'fibernr'}, D, {'ds1.filename', 'fibernr'});

%the following is necessary because scatter seems not to work with branched structures
DM(1).trold=NaN;
DM(1).trnew=NaN;

for i=1:numel(DM)
    DM(i).trold=DM(i).DLAT.slope;
    DM(i).trnew=DM(i).D.slope;
end

scatter([DM.trold], [DM.trnew]);
hold on;
xlabel('Slope from cross-correlation with constant reference SPL 70 dB');
ylabel('Slope from cross-correlation with constant MBL of 70 dB');
title('Trading ratios from different origins for A0241');
hold off;