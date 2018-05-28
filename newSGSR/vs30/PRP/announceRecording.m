function announceRecording;
% announceRecording - announce recording of a sequence by writing info to a small mat file
%    announceRecording is used for debugging purposes only.

if (~inLeuven) & (~inUtrecht), return; end

global SMS SESSION

try
   [stimType, stimName] = stimTypeOf(SMS);
   [IDstr, oldIDstr] = IDrequest('current');
   localTime = datestr(now);
   % find out if PDP11 format is used and determine iseq as will be save in datafile
   if isPDP11compatible(SMS),
      iseqRecording = -abs(SESSION.iSeq);
   else,  
      iseqRecording =  abs(SESSION.SGSRSeqIndex);
   end
   iseqRecording;
   
   SGSRSnapShot = collectInStruct(stimType, stimName, IDstr, oldIDstr, iseqRecording, localTime);
   SESSION;
   
   FN = [exportdir '\NowRecording.mat'];
   save(FN, 'SGSRSnapShot', 'SESSION');
catch,
   warning('Error during announceRecording');
   disp(lasterr);
end







