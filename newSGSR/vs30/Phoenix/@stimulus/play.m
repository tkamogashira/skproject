function Play(S, ishot);
% stimulus/play - play DAshot of stimulus object using TDT hardware
%   Play(ST, ishot) plays DAshot #ishot over the TDT system of
%   the current setup. If the chunks in which the samples are
%   stored have not been previously uploaded to RAM (see Ram2sam),
%   an error occurs.
%
%   See also stimulus/sam2ram

drawnow; % allow ineterrupts to come through

switch S.globalInfo.storage,
case 'sys2',
   localSys2(S, ishot);
case 'sys3',
   error NYI;
case 'none',
   error('Stimulus was not stored on RAM of D/A converter.');
otherwise,
   error(['Stimulus/play for storage = ''' S.globalInfo.storage ''' not implemented.']);
end


%=============================================
function localSys2(S, ishot);
% ----play over sys2 hardware----
% 1) bookkeeping preparations
Shot = S.DAshot(ishot);
HW = Shot.HardwareSettings;
% 2) prepare and upload seqlist and chanlist
DAhalt('clear'); % forget any previous interruption of D/A
if DAwait, return; end; % wait for any previous D/A, but immediately stop if DAhalt is called in the mean time
if isfield(S.globalInfo.storage, 'sys2DBNs'), deallot(S.storage.sys2DBNs); end % clear any previous seqplay-related DAMA buffers
seqDBN = []; % DBNs of seq lists
for ichan=allChanNums(HW.DAmode),
   iwav = Shot.waveform(ichan);
   wav = S.waveform(iwav);
   ichunk = wav.chunkList(:,1).'; % row vector containing subsequent chunk indices
   samDBN = [S.chunk(ichunk).address]; % idem DBNs in DAMA
   [samDBN iok] = denan(samDBN); % empty buffers have address==nan, exclude them from list.
   Nrep = wav.chunkList(iok,2).'; % row vector containing multiplicities of chunks
   iok = find(Nrep>0); % only include buffers with positive multiplicities
   seqList = [vectorzip(samDBN(iok), Nrep(iok)) 0]; % seq list in TDT seqplay format: dbn1 Nrep1 dbn2 ... 0
   seqDBN = [seqDBN ML2dama(seqList)]; % store seq list in DAMA
end
chanDBN = ML2dama([seqDBN 0]); % store seq list DBNs in chan DAMA buffer
s232('seqplay', chanDBN);
S.globalInfo.storage.sys2DBNs = [seqDBN chanDBN]; % channels to be deleted at next play time (see above)
% 3) hardware settings & go
% reset PD1, routing, fsam, nsam, etc; SS1 pre-synch switching
HWinstr = HardwareInstr4DA(HW.DAmode, HW.ifilt, HW.Nsam, 1e6/HW.Fsam);
PrepareHardware4DA(HWinstr);
drawnow; % allow interrupts to come through
s232('PD1arm',1);
% post-synch switching
for icomm=HWinstr.postGo.', % column-wise assignment (see help for)
   s232('SS1select', icomm(1), icomm(2), icomm(3));
end;
setpa4s(Shot.HardwareSettings.Atten);
% pause(0.1); % temporary hack to avoid clicks in absence of switch time
s232('PD1go',1);




