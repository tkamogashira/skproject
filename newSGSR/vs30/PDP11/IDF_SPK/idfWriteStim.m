function OK = idfWriteStim(fid, Seq)

OK = 1;
stype = idfstimName(Seq.stimcntrl.stimtype);
writeFun = ['idfWriteStim' stype];
if ~isequal(exist([writeFun '.m']), 2)
   warning(['don''t know how to write ''' stype ''' stimtype']);
end

oldPos = ftell(fid);
if isequal(oldPos,-1)
   warning(ferror(fid));
   OK = 0;
   return
end

eval(['newPos = ' writeFun '(fid, Seq);']);

if newPos<=oldPos
   warning(['something wrong while writing ''' stype ''' sequence']);
   OK = 0;
end

IDFfillToNextBlock(fid);
