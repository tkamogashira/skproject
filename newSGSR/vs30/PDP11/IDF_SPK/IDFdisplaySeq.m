function IDFdisplaySeq(idf, i_seq, disp_all)

% function IDFdisplaySeq(idf, i_seq, disp_all);
% is (array of) sequence indices
% if i_seq is string, displays first
% sequence with that string as stimulus type
% specifying a third, dummy, argument will display
% all sequences of type i_seq


if nargin<2 % ready made idfSeq variable; wrap it and use recursive call
   if nargin==0 % pick up current idfSeq
      global idfSeq;
      idf = idfSeq;
   end
   IDF.sequence{1} = idf;
   IDFdisplaySeq(IDF,1);
   return
end

if ischar(idf) || isnumeric(idf) % filename -> read idf file
   idf = idfread(idf);
end

% string specification: direct recursive call(s)
if ischar(i_seq)
   anyfound = 0;
   for k=1:idf.header.num_seqs
      stimtype = IDFstimName(idf.sequence{k}.stimcntrl.stimtype);
      found = strcmpi(i_seq, stimtype);
      if found
         IDFdisplaySeq(idf, k);
         anyfound = 1;
         if nargin<3
             break
         end
      end
   end
   if ~anyfound
       disp([ i_seq ' stim not found']);
   end
   return
end

% zero i_seq: display all squences
if isequal(i_seq,0)
   i_seq = 1:length(idf.sequence);
end

% range, not single number: recursive
i_seq = i_seq(:)';
if length(i_seq)>1
   for ii=1:length(i_seq)
      idfDisplaySeq(idf, i_seq(ii));
   end
   return
end


% special non-numerical types
ch = {' both' ' left' 'right' };
noyes={'no' 'yes'};
ncn = {'frozen' 'drift' 'unfrozen'};
pn = {'negative' 'positive' 'none'};
% --------STIMCNTRL field--------------
disp(' ');
sc = idf.sequence{i_seq}.stimcntrl;
disp(['    SEQ # ' num2str(sc.seqnum) ' <<' ...
      upper(IDFstimName(sc.stimtype)) '>>  ' idfDate(sc.today)]);

cc = 'incomplete: ';
if sc.complete
    cc='complete: ';
end
disp([ cc num2str(sc.max_subseq) ' subseqs; '...
      num2str(sc.repcount) ' reps/subseq; ' ...
      num2str(sc.interval) '-ms intervals']);
contra = sc.contrachan+1;
active = sc.activechan+1;
limit = sc.limitchan+1;
spllimit = sc.spllimitchan+1;
disp('channels:   contra  /    active    / limit   / spllimit ');
disp([blanks(12) ch{contra} blanks(7) ch{active} blanks(7) ...
      ch{limit} blanks(7) ch{spllimit}]);
if any(sc.DUR2delay), 
   disp(['  DUR2delay: ' num2str(sc.DUR2delay) ' ms']);
end
disp('        * * * * * * * * * * * * * * * * * *');

% --------STIMCMN field-------------------
if isfield(idf.sequence{i_seq}.indiv, 'stimcmn')
   seq = idf.sequence{i_seq};
   fn = fieldnames(seq.indiv.stimcmn);
   for kk=1:length(fn)
      ll = seq.indiv.stimcmn.(fn{kk});
      if strcmp(fn{kk}, 'polarity')
         ll = pn{ll+1};
      elseif strcmp(fn{kk}, 'leadchan')
         ll = ch{ll+1};
      elseif strcmp(fn{kk}, 'var_chan')
         ll = ch{ll+1};
      elseif strcmp(fn{kk}, 'delayonmod')
         ll = noyes{ll+1};
      elseif strcmp(fn{kk}, 'phasecomp')
         ll = noyes{ll+1};
      elseif strcmp(fn{kk}, 'beatonmod')
         ll = noyes{ll+1};
      end
      ll = num2str(ll);
      dd=sprintf('%16s: %15s', fn{kk}, ll);
      disp(dd);
   end
end

% --------STIM field-------------------
if isfield(idf.sequence{i_seq}.indiv, 'stim')
   seq = idf.sequence{i_seq};
   fn = fieldnames(seq.indiv.stim{1});
   for kk=1:length(fn)
      ll = seq.indiv.stim{1}.(fn{kk});
      rr = seq.indiv.stim{2}.(fn{kk});
      ll = num2str(ll);
      rr = num2str(rr);
      dd=sprintf('%16s: %10s  %10s', fn{kk}, ll, rr);
      disp(dd);
   end
end

% --------NOISE_CHARACTER field (nspl only)-------------------
if isfield(idf.sequence{i_seq}.indiv, 'noise_character')
   nc = seq.indiv.noise_character;
   ll = ncn{1+nc(1)};
   rr = ncn{1+nc(2)};
   dd=sprintf('%16s: %10s  %10s', 'noise_character', ll, rr);
   disp(dd);
end
