function s = disp(EDFds, N)
%EDFDATASET/DISP builtin DISP-function overloaded for EDF dataset objects
%   s = disp(EDFds, N)

%B. Van de Sande 27-05-2004

if nargin < 2, N = 5; end
Indent = blanks(N);

%Array of EDF dataset objects ...
if numel(EDFds) > 1,
   Sz = size(EDFds); isVec = any(size(EDFds) == 1);
   s = [Indent num2str(Sz(1)) 'x' num2str(Sz(2)) ' EDF dataset matrix (' upper(EDFds(1).ID.SchName) '):'];
   for r = 1:size(EDFds, 1),
      for c = 1:size(EDFds, 2),
         if isVec, ElemNr = num2str(max(r, c));
         else, ElemNr = [num2str(r) ',' num2str(c)]; end
         
         iSeq  = getfield(EDFds(r, c), 'iSeq');
         if ~isempty(iSeq), Title = getfield(EDFds(r, c), 'Title');
         else, Title = 'empty dataset object'; end    
         s = strvcat(s, [fixLenStr(['(' ElemNr ')  '], 14, 1) , fixLenStr(Title, 24, 0), '  iseq = ' fixLenStr(num2str(iSeq), 3, 1)]);
      end
   end
%Empty dataset object ...
elseif isempty(EDFds), s = [Indent 'empty EDF dataset object'];
else,
    DS = EDFds.dataset;
    
    %Identifier ...
    if ~all(isnan(DS.Time)), DateStr = [idfDate(DS.Time), ', ']; 
    else, DateStr = ''; end    
    IDStr = [Indent 'Dataset ' DS.FileName ' <' DS.SeqID '>, ' DS.FileFormat ' Seq=' num2str(DS.iSeq) ', ' DateStr DS.Place];
    
    %Experiment type, schema name, DSS mode and sizes ...
    Nsub = num2str(DS.Nsub); NsubRec = num2str(DS.Nrec); Nrep = num2str(DS.Nrep);
    RepDur = num2str(round(DS.Stimulus.Special.RepDur(1)));
    if isnan(EDFds.Sizes.Ntimers), UETStr = '';
    else, UETStr = sprintf('#UET %d, ', EDFds.Sizes.Ntimers); end
    if isempty(EDFds.DSS), DSSStr = '';
    elseif length(EDFds.DSS) == 1,  DSSStr = [ 'DSS Mode ' upper(EDFds.DSS(1).Mode) ', ' ];
    else, DSSStr = [ 'DSS Mode ' upper(EDFds.DSS(1).Mode) '/' upper(EDFds.DSS(2).Mode) ', ']; end        
    SizeStr = [Indent 'ExpType ' upper(DS.StimType) ', Schema ' upper(EDFds.ID.SchName) ', ' UETStr DSSStr NsubRec '/' Nsub ' x ' Nrep ' x ' RepDur ' ms']; 
    
    %Independent variables ... 
    IndepStr = [ Indent 'varied: '];
    if ~isempty(EDFds.EDFIndepVar(1).DSS), IndepStr = [ IndepStr EDFds.EDFIndepVar(1).Name ' = ' IndepVal2Str(EDFds.EDFIndepVar(1).Values) ' ' EDFds.EDFIndepVar(1).Unit ' (' upper(EDFds.EDFIndepVar(1).DSS) ')'];
    else, IndepStr = [ IndepStr EDFds.EDFIndepVar(1).Name ' = ' IndepVal2Str(EDFds.EDFIndepVar(1).Values) ' ' EDFds.EDFIndepVar(1).Unit]; end  
    if length(EDFds.EDFIndepVar) > 1 & ~isempty(EDFds.EDFIndepVar(1).DSS), IndepStr = strvcat(IndepStr, [Indent blanks(8) EDFds.EDFIndepVar(2).Name ' = ' IndepVal2Str(EDFds.EDFIndepVar(2).Values) ' ' EDFds.EDFIndepVar(2).Unit ' (' upper(EDFds.EDFIndepVar(2).DSS) ')']); 
    elseif length(EDFds.EDFIndepVar) > 1, IndepStr = strvcat(IndepStr, [Indent blanks(8) EDFds.EDFIndepVar(2).Name ' = ' IndepVal2Str(EDFds.EDFIndepVar(2).Values) ' ' EDFds.EDFIndepVar(2).Unit]); end
        
    %Extra stimulus parameters ...
    Spec = DS.Stimulus.Special;
    SpecStr = [ Indent 'Burst = ' IndepVal2Str(Spec.BurstDur) ' ms   '];
    if ~isnan(Spec.CarFreq), 
        SpecStr = [ SpecStr 'Carrier = ' IndepVal2Str(Spec.CarFreq) ' Hz   ']; 
    end
    if ~any(isnan(Spec.ModFreq)) & ~all(Spec.ModFreq == 0), 
        SpecStr = [SpecStr 'Mod @ ' IndepVal2Str(Spec.ModFreq) ' Hz   ']; 
    end
    if ~isnan(Spec.BeatFreq) & ~all(Spec.BeatFreq == 0), 
        SpecStr = [SpecStr 'Beat @ ' IndepVal2Str(Spec.BeatFreq) ' Hz   ']; 
    end
    if ~isnan(Spec.BeatModFreq) & ~all(Spec.BeatModFreq == 0), 
        SpecStr = [SpecStr 'BeatMod @ ' IndepVal2Str(Spec.BeatModFreq) ' Hz   ']; 
    end
    
    s = strvcat(IDStr, SizeStr, IndepStr, SpecStr);
end

if nargout ~= 1, disp(s); clear('s'); end

%--------------------------------------------local functions----------------------------------------------------
function s = IndepVal2Str(Val)

if (length(Val) == 1) | (size(Val) == [1, 2] & isequal(Val(1), Val(2))) | ...
   (length(unique(Val(~isnan(Val)))) == 1),
    s = num2str(round(Val(1)));
else, s = trimspace([ '[' num2str(round(min(Val)))  '...' num2str(round(max(Val)))  ']' ]); end