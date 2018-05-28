function [X, varargout] = subsref(DS,S)
% DATASET/SUBSREF - subsref for DATASET objects

% length(DS)
% deal with vector-valued DS
if (length(DS)>1) && isequal('.', S.type),
   N = length(DS);
   X = subsref(DS(1),S);
   for ii=2:N,
      varargout{ii-1} = subsref(DS(ii), S);
   end
   % idiotic order reversal?!?
   [X, varargout{1:N-1}] = deal(varargout{N-1:-1:1},X);
   return;
end

% exception: user-defined call to function
if isequal('.', S(1).type) && isequal('call', lower(S(1).subs)),
   fnc = S(2).subs; % name of user-defined function
   X = eval([fnc '(DS, {S.subs} )']);
   return;
end;

if length(S)>1,
   if isequal('.', S(1).type) && isequal('spt',lower(S(1).subs)) ...
         && isequal('{}', S(2).type) ...
         && (isequal(':',S(2).subs{1}) || isequal(':',S(2).subs{end})),
      error('Invalid use of colon within virtual SPT field. Use auxilary variable as in: "S = DS.SPT;  ...S{:,2}..."');
   end
   X = subsref(subsref(DS, S(1)),S(2:end));
   return;
end

% single subscript from here
% NOTE: any change in this file necessitates a corresp change 
% in the help text in file subsrefhelp.fig

switch S.type,
case '()', 
   X = builtin('subsref', DS, S);
   return;
case '{}', error('Invalid use of ''{}'' for dataset objects');
case '.',
   switch lower(S.subs),
      %---ID and subfields-------
   case 'help',
       X = ' ';
       try
           type subsrefhelp.fig;
       end
       return;
   case 'id', X = DS.ID;
   case 'filename', X = DS.ID.FileName;
   case 'fullfile', X = DS.ID.FullFileName;
   case 'fileformat', X = DS.ID.FileFormat;
   case {'seqid' 'condid'}, X = DS.ID.SeqID;
   case 'iseq', X = DS.ID.iSeq; 
   case 'stimtype', X = DS.ID.StimType;
   case 'icell', X = DS.ID.iCell;
   case 'time', X = DS.ID.Time;
   case 'place', X = DS.ID.Place;
   case 'title', 
      xx = DS.ID;
      if isempty(find(xx.SeqID=='-',1)),
         X = [xx.FileName '  Seq ' num2str(xx.iSeq) ': ' xx.StimType];
      else
         X = [xx.FileName '  <' xx.SeqID '>'];
      end
      %---SIZES and subfields-------
   case 'sizes', X = DS.Sizes;
   case {'nsub' 'ncond'}, X = DS.Sizes.Nsub;
   case {'nsubrecorded', 'nrec'}, X = DS.Sizes.NsubRecorded;
   case {'nrep' 'nrun'}, X = DS.Sizes.Nrep;
   case 'pres', X = [num2str(DS.Sizes.NsubRecorded) '/' ...
            num2str(DS.Sizes.Nsub) ' x '  ...
            num2str(DS.Sizes.Nrep) ' x ' ...
            num2str(round(DS.Stimulus.Special.RepDur(1))) ' ms'];
      %---DATA and subfields-------
   case 'data', X = DS.Data; if ischar(X), error(X); end
   case {'spiketimes' 'spt'}, X = DS.Data.SpikeTimes;
   case {'spikecount' 'nspt'}, 
      X = CellNumel(DS.Data.SpikeTimes);
   case 'otherdata', X = DS.Data.OtherData;
      %---SETTINGS and subfields-------
   case 'settings', X = DS.Settings;
   case {'sessioninfo' 'session'}, X = DS.Settings.SessionInfo;
   case {'recordparams' 'recparam'}, X = DS.Settings.RecordParams;
      %---STIMULUS, subfields and subsubfields-------
   case {'stimulus', 'stim'}, X = DS.Stimulus;
   case {'indep', 'indepvar' 'x'}, X = DS.Stimulus.IndepVar;
   case {'indepval', 'xval'}, X = DS.Stimulus.IndepVar.Values;
   case {'indepunit', 'xunit'}, X = DS.Stimulus.IndepVar.Unit;
   case {'indepname', 'xname'}, X = DS.Stimulus.IndepVar.Name;
   case {'indeplabel', 'xlabel'}, 
      xx = DS.Stimulus.IndepVar;
      X = [xx.Name ' (' xx.Unit ')'];
   case {'indepshortname', 'xshortname'}, X = DS.Stimulus.IndepVar.ShortName;
   case {'indepscale', 'xplotscale' 'xscale'}, X = DS.Stimulus.IndepVar.PlotScale;
   case 'special', X = DS.Stimulus.Special;
   case 'repdur', X = mean(DS.Stimulus.Special.RepDur); % avoid multiple values
   case 'repdurs', X = DS.Stimulus.Special.RepDur.*ones(DS.Sizes.Nsub,1);
   case 'burstdur', X = DS.Stimulus.Special.BurstDur;
   case {'carfreq' 'fcar'}, X = DS.Stimulus.Special.CarFreq;
   case {'modfreq' 'fmod'}, X = DS.Stimulus.Special.ModFreq;
   case {'beatfreq' 'fbeat'}, X = DS.Stimulus.Special.BeatFreq;
   case {'beatmodfreq' 'fbeatmod'}, X = DS.Stimulus.Special.BeatModFreq;
   case {'dachan' 'chan' 'activechan'}, X = DS.Stimulus.Special.ActiveChan;
   case 'specialparams', X = DS.Stimulus.Special.paramSet;
   case {'stimparam' 'param' 'spar'}, X = DS.Stimulus.StimParam;
   case {'info'}; X = DSinfoString(DS); X = [X{:}];
   otherwise, 
      [X, OK] = localNewSpecial(DS, S);
      if ~OK, % last shot .. look if field lives somewhere inside stimulus parameters
         [X, OK] = localOtherWise(DS, S);
         if ~OK, error(['Invalid property ''' S.subs ''' of dataset object.']); end
      end;
   end % switch lower(S.subs)
end % switch S.type


%=====================locals=============================
function [X, OK] = localNewSpecial(DS, S)
% new special parameters are only defined for most recent datasets
OK = 1; % optimistic default
try
   switch lower(S.subs),
   case 'spl', X = DS.Stimulus.Special.SPL;
   case 'moddepth', X = DS.Stimulus.Special.ModDepth;
   case 'itd', X = DS.Stimulus.Special.ITD;
   case 'delay', X = DS.Stimulus.Special.Delay;
   case 'risedur', X = DS.Stimulus.Special.riseDur;
   case 'falldur', X = DS.Stimulus.Special.fallDur;
   otherwise, error('not a new special - see you @ catch');
   end % switch/case
catch
    OK = 0;
    X = NaN;
end
   
function [X, OK] = localOtherWise(DS, S)
OK = 1; % optimistic default
try % if the desired field is a stimparam field
   repelsteeltje = rand;
   X = getfieldCI(DS.Stimulus.StimParam, S.subs, repelsteeltje);
   if isequal(X, repelsteeltje), % in case of farmington data, look into subfields of stimpar
      try
         X = getfieldCI(DS.Stimulus.StimParam.stimcntrl, S.subs, repelsteeltje);
         if isequal(X, repelsteeltje),
            X1 = getfieldCI(DS.Stimulus.StimParam.indiv.stim{1}, S.subs, repelsteeltje);
            X2 = getfieldCI(DS.Stimulus.StimParam.indiv.stim{2}, S.subs, repelsteeltje);
            X = [X1 X2];
            if isequal(X1, repelsteeltje), % finally, try stimcmn field of idfseq
               X = getfieldCI(DS.Stimulus.StimParam.indiv.stimcmn, S.subs, repelsteeltje);
            end
         end
      end % try
   end
   if isequal(X(1), repelsteeltje),
      error(['Invalid property ''' S.subs ''' of dataset object.']);
   end
catch
    OK = 0;
    X = nan;
end
