D = struct([]);

% fields that need to be retrieved
XFieldName = 'ds2.discernvalue';
YFieldName = 'primpeak.delay';
ppnm = 'primpeak.normmagn';
spd = 'secpeaks.delay';
spnm = 'secpeaks.normmagn';
lagfn = 'lag';
normcofn = 'normco';

%smoothing and spline factor
smoothing = 3;
spline = 10;
List1 = GenWFList(D, 'A0306', [553;554;555], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
List2 = GenWFList(struct([]), 'A0306', [27;28], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
List3 = GenWFList(D, 'A0307', [75;76], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
List4 = GenWFList(struct([]), 'A0307', [530;531;532], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');         
List5 = GenWFList(struct([]), 'A0241', [41;42;43;44], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
List6 = GenWFList(struct([]), 'A0242', [23;24;25;27], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
List7 = GenWFList(struct([]), 'A0428', [79;90;91], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
List8 = GenWFList(struct([]), 'A0454', [47;48;49;50;51], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      

List = [List1;List2;List3;List4;List5;List6;List7;List8]

T = genwfplotTF(List, 15, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 553                       
