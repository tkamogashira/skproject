echo on;

%Loading structure-arrays ...
load popscriptBB;
load popscriptNTD;

%Usage of structfilter ...
DBB1 = structfilter(DBB, '$thr.cf$ < 500');
DBB2 = structfilter(DBB, '$thr.cf$ > 500 & $thr.cf$ < 1000');
DBB3 = structfilter(DBB, '$thr.cf$ > 1000 & $thr.cf$ < 1500');
DBB4 = structfilter(DBB, '$thr.cf$ > 1500');
structplot(DBB1, 'fft.bw', 'diff.hhw', DBB2, 'fft.bw', 'diff.hhw', DBB3, 'fft.bw', 'diff.hhw', ...
    DBB4, 'fft.bw', 'diff.hhw', 'info', 'n', 'markers', {'^f', 'of', '^', '+u'});

DBBf = structfilter(DBB, 'iselem(0, $tag$)');
structplot(DBBf, 'vs.cpmod', 'itd.ratio');

%Usage of structmerge ...
DM = structmerge(DBB, {'ds1.filename', 'ds1.icell'}, DNTD, {'ds1.filename', 'ds1.icell'});
structplot(DM, 'DBB.diff.hhw', 'DNTD.diff.hhw', 'totalidfields', {'ds1.filename', 'DBB.ds1.seqid', 'DNTD.ds1.seqid'});

%Usage of structplot ...
structplot(DBB, 'greenwood($fft.df$)', 'diff.hhw', DNTD, 'greenwood($diff.fft.df$)', 'diff.hhw');
structplot(DBB, 'fft.df', '1000./$diff.hhw$', 'fit', 'linear');

echo off