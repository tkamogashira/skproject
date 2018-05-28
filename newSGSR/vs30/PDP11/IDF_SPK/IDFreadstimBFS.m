function indiv = IDFreadstimBFS(fid)

% function indiv = IDFreadstimBFS(fid);

%>    RECORD {bfs}
%>      stimcmn:
%>        RECORD {stimcmn}
%>          lofreq, hifreq, deltafreq: real;
%>          beatfreq: real;
%>          duration: real;
%>        END; {stimcmn}

indiv.stimcmn.lofreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.hifreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.deltafreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.beatfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.duration = freadVAXD(fid, 1, 'single');

%>      stim: ARRAY [left..right] OF
%>          RECORD {bfsstim}
%>            spl: integer;
%>            rise, fall: real;
%>          END; {bfsstim}
%>    END; {bfs}
for k=1:2
   indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
   indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
