
% psLATgen_A0454
% popscript to study effect of SPL on delay
% PXJ 8/2005
%
% this version of the script contains usable data from A0454
% TF 29/08/2005

echo on;

D = struct([]);

% fields that need to be retrieved
XFieldName = 'ds2.discernvalue';
YFieldName = 'primpeak.delay';

if 0
% NSPL dataset
% unit 81 - HIGH CF - difcor flat
List = GenWFList(struct([]), 'A0242', [-135, -136], (50:10:80)', ...
           'discernvalue', ['subsref(getfield(dataset($filename$, $iseqp$), ', ...
           '''indepval''), struct(''type'', ''()'', ''subs'', {{$isubseqp$}}))']);
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = 3rd row (70 dB)
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];
end

% A0454 ---------------------------------
% NRHO dataset

%% ref-nummer bepaald door rangnummer als spl-waarden van hoog naar laag schikken

% unit 5
List = GenWFList(struct([]), 'A0454', [13; 14], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 13
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 6
List = GenWFList(struct([]), 'A0454', [17; 18; 19; 21], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 17
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 13
List = GenWFList(struct([]), 'A0454', [47; 48; 49; 50; 51], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 47
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 34
List = GenWFList(struct([]), 'A0454', [104; 105; 106; 107], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 104
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 35
List = GenWFList(struct([]), 'A0454', [109; 111; 112; 113], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 109
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 36
List = GenWFList(struct([]), 'A0454', [116; 118; 119], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 116
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];



% unit 40
List = GenWFList(struct([]), 'A0454', [131; 132; 133; 134], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 131
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 41
List = GenWFList(struct([]), 'A0454', [139; 140; 141; 142; 143; 144], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 140
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];


% unit 44
List = GenWFList(struct([]), 'A0454', [150; 151; 152], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 150
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 45
List = GenWFList(struct([]), 'A0454', [155; 156], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 155
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];


% unit 47
List = GenWFList(struct([]), 'A0454', [163; 164; 165], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 163
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 48
List = GenWFList(struct([]), 'A0454', [173; 174; 175], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 173
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];



% unit 58
List = GenWFList(struct([]), 'A0454', [197; 198], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 198
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 59
List = GenWFList(struct([]), 'A0454', [203; 204], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 203
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 68
List = GenWFList(struct([]), 'A0454', [221; 222; 223; 224], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 221
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 71
List = GenWFList(struct([]), 'A0454', [231; 232], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 231
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 72
List = GenWFList(struct([]), 'A0454', [234; 235], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 234
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 74
List = GenWFList(struct([]), 'A0454', [241; 242; 243], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 241
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

% unit 75
List = GenWFList(struct([]), 'A0454', [249; 250; 248], [+1, -1], ... 
           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 248
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];

%-----------------------------------------------------------------
DLAT = D; clear('D');
save(mfilename, 'DLAT');
%-----------------------------------------------------------------


groupplot(DLAT, 'xval', 'yval');

echo off;