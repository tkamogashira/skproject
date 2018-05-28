function [OK, PRPinstruct, StimDef] = SMS2PRP(DoRecord, ToSLib);
% SMS2PRP - convert SMS to SD and PRPinstr;
% Creates from SMS stimulus specs (global SMS; see createSMSxxx)
% the two global variables:
%     SD: stimulus definition (see help stimdef)
%     PRPinstr: play/record/plot instructions (see PRPinstr2)
% syntax: [PRPinstruct, StimDef]=SMS2PRP(DoRecord);
% no action is taken if the a previous call to SMS2PRP
% was issued containing the same instructions (see SMSisUpdated). 
% To this end, a persistent (internal) variable prevSMS is created/updated
% after a call to SMS2PRP

global SMS SD PRPinstr StimMenuStatus
persistent prevSMS

if nargin<2, ToSLib=0; end

if nargin<1, DoRecord=0; end;

OK = 0;
% if nothing new is asked, SD and PRPinstr needn't be updated
if SMSisUpdated(SMS, prevSMS),
   if AP2present,
      % release allocated AP2 memory & generate generic buffers
      if ~cleanAP2(DoRecord), return; end; % argument determines whether ET1 is tested/calibrated
   end
   % release sampleLib memory
   EmptySampleLib; % this has the side effect of destroying special bufs if ~AP2present ...
   if ~AP2present, initspecialbufs; end; % ...so restore that
   % create stimulus definition from SMS params
   UIinfo('Evaluating stimuli...');
   SD= stimDEF(SMS);
   % generate waveforms and subseq info
   UIinfo('Generating stimuli...');
   if ToSLib, SD= stimGEN(SD,0,'MatLab');
   else, SD= stimGEN(SD);
   end
   
   % build D/A instructions
   UIinfo('Building D/A instructions...');
   instructor = PRPinstructor(SD);
   PRPinstr = feval(instructor, SD); % instructions for play/record/plot
   UIinfo('Ready...');
   
   % store the current SMS as prevSMS for comparison upon next call
   prevSMS = SMS;
end % if SMSisupdated

OK = 1;
% return output args if prompted for
if nargout>1,
   PRPinstruct = PRPinstr;
end
if nargout>2,
   StimDef = SD;
end


