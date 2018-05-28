function idfSeq = BFScreateIDF(hifreq, lofreq, deltafreq, beatfreq, ...
   SPL, interval, duration, rise, fall, repcount, order,...
   activeChan, limitChan);


stimtype = 15; % BFS==FSBT stimtype index

% stimcntrl field
SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limitChan, SPLlim, ...
   interval, repcount);

% stimcmn field
idfSeq.indiv.stimcmn.lofreq = lofreq;
idfSeq.indiv.stimcmn.hifreq = hifreq;
idfSeq.indiv.stimcmn.deltafreq = deltafreq;
idfSeq.indiv.stimcmn.beatfreq = beatfreq;
idfSeq.indiv.stimcmn.duration = duration;


for k=1:2,
   idfSeq.indiv.stim{k}.spl = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.rise = DualValueOf(rise,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fall,k);
end;
idfSeq.order = order;

idfSeq = idffixorder(idfSeq,'lofreq','deltafreq','hifreq');

%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

% ---source:
%>I do find a BFS stim type (a.k.a. stimfsbt):
%> bfs_stimtype =
%>    RECORD {bfs}
%>      stimcmn:
%>        RECORD {stimcmn}
%>          lofreq, hifreq, deltafreq: real;
%>          beatfreq: real;
%>          duration: real;
%>        END; {stimcmn}
%>      stim: ARRAY [left..right] OF
%>          RECORD {bfsstim}
%>            spl: integer;
%>            rise, fall: real;
%>          END; {bfsstim}
%>    END; {bfs}
