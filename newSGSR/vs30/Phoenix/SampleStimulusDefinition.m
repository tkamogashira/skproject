    % sample stimulus definition 
% stimulus type: FS

FS = paramset('Stimulus', 'FS', 'Frequency sweep', 1, [430 40], mfilename);
% -------------------PARAMETER LIST-----------------
%          name       val   unit   datatype   maxsize
% ----------frequencies---------
FS = AddParam(FS,  'lowFreq', 300, 'Hz', 'ureal', 2);
FS = AddParam(FS,  'steptype',   'octave', '', 'char', inf);
FS = AddParam(FS,  'linStepFreq  50    Hz       real       2');
FS = AddParam(FS,  'logStepFreq 0.2    octave   real       2');
FS = AddParam(FS,  'hifreq     4500    Hz      ureal       2');
FS = AddParam(FS,  'modDepth     50     %      ureal       1');
FS = AddParam(FS,  'modFreq     120    Hz      ureal       1');
%  ----------durations------------
FS = AddParam(FS,  'interval    200    ms      ureal       1');
FS = AddParam(FS,  'burstDur    100    ms      ureal       2');
FS = AddParam(FS,  'rampDur       4    ms      ureal       2');
FS = AddParam(FS,  'ITD           0    ms       real       1');
%  ----------various------------
FS = AddParam(FS,  'SPL          85   dB_SPL    real       2');
FS = AddParam(FS,  'activeDA   Left  chanName DAchan        ');
FS = AddParam(FS,  'Nrep         10    _        uint       1');
FS = AddParam(FS,  'order    Random    _        char     inf');
%------------------OUI-----------------------------
TTpairs = ' Pairs of numbers mean [left right].';
TThit = 'Hit button to toggle between ';
TThit2 = 'Hit button to ';
ED = 'edit'; TG = 'toggle'; FR = 'frame';
%====================================================
FS = InitOUIgroup(FS, 'carrier', [10 10 140 70]); 
FS = DefineQuery(FS, 'lowfreq',     0, ED,   'start:',   '21000.5 21000.1', ['Frequency at start of sweep.' TTpairs] );
FS = DefineQuery(FS, 'linStepFreq', 20, ED,   'step:',    '1100 1101',       ['Size of linear frequency step.' TTpairs] );
FS = DefineQuery(FS, 'logStepFreq', 20, ED,   'step:',    '0.25 0.25',       ['Size of logaritmic frequency step.' TTpairs] );
FS = DefineQuery(FS, 'steptype', [80 20], TG,   '',       {'Hz','octave'},   [TThit 'linear and logaritmic frequency steps'] );
FS = DefineQuery(FS, 'hifreq',      40, ED,   'end:',     '21000.5 21000.1', ['Frequency at end of sweep.' TTpairs] );
FS = SeeSaw(FS, 'stepType', 'linStepFreq', 'logStepFreq'); % steptype toggle button also toggles xxxStepFreq edits
%====================================================
FS = InitOUIgroup(FS, 'modulation', [10 95 140 50]); 
FS = DefineQuery(FS, 'modDepth', 0,    ED,   'depth:',   '100 100',         ['Modulation depth. ' TTpairs] ) ;
FS = DefineQuery(FS, 'modFreq',  20,     ED,   'rate:',    '120.1 120.2',     ['Modulation frequency' TTpairs] );
%====================================================
FS = InitOUIgroup(FS, 'SPL', [170 10 220 55], 'SPLs & active DA channels');
FS = DefineQuery(FS, 'SPL', 0, ED, 'level(s):', '110.5 110.9', ['Carrier SPL.' TTpairs]);
FS = DefineQuery(FS, 'activeDA', [135 0], TG, 'Active:', {'Left', 'Right', 'Both'}, [TThit 'active DA channels = Left/Right?Both.' ]);
FS = defineReporter(FS, 'maxSPL', [10 28], {'[100 101 dB SPL]' '@ [34000 21000 kHz]'}, ...
   ['Maximum SPL that can be realized with current value of stimulus parameters.' TTpairs], 'foregroundcolor', [0.4 0 0]);
%====================================================
FS = InitOUIgroup(FS, 'durations', [170 75 120 70]);
FS = DefineQuery(FS, 'burstDur',  0, ED, 'burst:',    '1000 1000', ['Burst duration.' TTpairs]);
FS = DefineQuery(FS, 'rampDur',  20, ED, 'rise/fall:', '20.5 10.9', 'Durations of onset and offset ramps. Pairs of numbers mean [RISE FALL].');
FS = DefineQuery(FS, 'ITD',      40, ED, 'ITD',  '-0.060.3', 'Interaural time difference. POSITIVE values correspond to LEADING IPSILATERAL channel.');
%====================================================
FS = InitOUIgroup(FS, 'presentation', [300 75 120 70]);
FS = DefineQuery(FS, 'interval', 0, ED, 'interval:', '12000', 'Interval duration, i.e., duration between the offsets of subsequent repetitions.' );
FS = DefineQuery(FS, 'Nrep', 20, ED, 'reps:', '1234', 'Number of repetitions of each stimulus condition.');
FS = DefineQuery(FS, 'order', 40, TG, 'order:', {'Forward', 'Reverse', 'Random'}, [TThit 'Forward/Reverse/Random order of stimulus presentation.']);
%====================================================
PRP = StimulusDashboard('OUI', FS.OUI.minFigSize(2));
% message boxes etc




%     lofreq: 300
%       dfreq: 100
%      hifreq: 400
%    stepunit: 'lin'
%        reps: 10
%    interval: 200
%       order: 1
%    burstDur: 100
%     riseDur: 4
%     fallDur: 4
%       delay: [0 0]
%         SPL: [85 85]
%      active: 0
%    modDepth: 100
%     modFreq: 0