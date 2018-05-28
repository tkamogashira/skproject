function dstr = IDFdisp(ds);
% displays IDF params of single data set

% based on older IDFdisp

if ~isequal('IDF/SPK',ds.fileformat),
   error('Non-IDF/SPK file format');
end

% special non-numerical types
ch = {' both' ' left' 'right' };
noyes={'no' 'yes'};
ncn = {'frozen' 'drift' 'unfrozen'};
pn = {'negative' 'positive' 'biphase-' 'biphase+' 'none'};

idf = ds.stimparam;
STR = '';
% --------STIMCNTRL field--------------
sc = idf.stimcntrl;
line1 = ['  ' ds.filename ',  seq # ' num2str(sc.seqnum) ' (' ...
      upper(IDFstimName(sc.stimtype)) ') ' idfDate(sc.today)];

cc = 'incomplete: ';
if sc.complete, cc='complete: '; end;
line2 = [ cc num2str(sc.max_subseq) ' subseqs; '...
      num2str(sc.repcount) ' reps/subseq; ' ...
      num2str(sc.interval) '-ms intervals'];
contra = sc.contrachan+1;
active = sc.activechan+1;
limit = sc.limitchan+1;
spllimit = sc.spllimitchan+1;
line3 = ['channels:   contra  /    active    / limit   / spllimit '];
line4 = [blanks(12) ch{contra} blanks(7) ch{active} blanks(7) ...
      ch{limit} blanks(7) ch{spllimit}];
if any(sc.DUR2delay), 
   line5 = ['  DUR2delay: ' num2str(sc.DUR2delay) ' ms'];
else, line5 = '';
end
line6 = '        * * * * * * * * * * * * * * * * * *';
STR = strvcat(line1,line2,line3,line4,line5, line6);

% --------STIMCMN field-------------------
if isfield(idf.indiv, 'stimcmn'),
   seq = idf;
   fn = fieldnames(seq.indiv.stimcmn);
   for kk=1:length(fn),
      ll = getfield(seq.indiv.stimcmn, fn{kk});
      if strcmp(fn{kk}, 'polarity'),
         ll = pn{ll+1};
      elseif strcmp(fn{kk}, 'leadchan'),
         ll = ch{ll+1};
      elseif strcmp(fn{kk}, 'var_chan'),
         ll = ch{ll+1};
      elseif strcmp(fn{kk}, 'delayonmod'),
         ll = noyes{ll+1};
      elseif strcmp(fn{kk}, 'phasecomp'),
         ll = noyes{ll+1};
      elseif strcmp(fn{kk}, 'beatonmod'),
         ll = noyes{ll+1};
      end
      ll = num2str(ll);
      dd=sprintf('%16s: %15s', fn{kk}, ll);
      STR = strvcat(STR,dd);
   end
end

% --------STIM field-------------------
if isfield(idf.indiv, 'stim'),
   seq = idf;
   fn = fieldnames(seq.indiv.stim{1});
   for kk=1:length(fn),
      ll = getfield(seq.indiv.stim{1}, fn{kk});
      rr = getfield(seq.indiv.stim{2}, fn{kk});
      ll = num2str(ll); rr = num2str(rr);
      dd=sprintf('%16s: %10s  %10s', fn{kk}, ll, rr);
      STR = strvcat(STR, dd);
   end
end

% --------NOISE_CHARACTER field (nspl only)-------------------
if isfield(idf.indiv, 'noise_character'),
   nc = seq.indiv.noise_character;
   ll = ncn{1+nc(1)}; rr = ncn{1+nc(2)};
   dd=sprintf('%16s: %10s  %10s', 'noise_character', ll, rr);
   STR = strvcat(STR, dd);
end

% new-style noise params
[dum, stimType] = stimTypeof(idf);
switch stimType,
case 'ntd',
   [NP.Flow, NP.Fhigh, NP.Rho, NP.RandSeed] = extractNewNoiseParams(idf);
case 'nspl',
   [NP.Flow, NP.Fhigh, NP.Rho, NP.RandSeed, NP.startSPL, NP.endSPL, NP.stepSPL, NP.noiseSign] ...
      = extractNewNoiseParams(idf);
otherwise, NP = [];
end
if ~isempty(NP),
   fns = fieldnames(NP);
   NPstr = '=====special noise parameters======';
   for ii=1:length(fns),
      fn = fns{ii};
      fv = getfield(NP, fn);
      fstr = sprintf(['%12s: ' repmat('%8.5f ',1,length(fv))], fn, fv);
      NPstr = strvcat(NPstr, fstr);
   end
   STR = strvcat(STR, NPstr);
end

% display or return string
if nargout<1, disp(STR);
else, dstr = STR;
end


