function dispString = disp(ds, Nindent)
% DATASET/DISP - DISP for dataset objects

if nargin<2
    Nindent=5;
end
indent = blanks(Nindent);

if numel(ds)>1
   S = size(ds);
   disp([indent num2str(S(1)) 'x' num2str(S(2)) ' dataset matrix:']);
   isVec = any(size(ds)==1);
   for ii=1:size(ds,1),
      for jj=1:size(ds,2),
         if isVec
             coO = num2str(max(ii,jj));
         else
             coO = [num2str(ii) ',' num2str(jj)];
         end
         iseq = ds(ii,jj).ID.iSeq;
         if isfield(ds(ii,jj),'title')
             tit = ds(ii,jj).('title');
         else
             tit = 'unnamed';
         end
         disp([FixLenStr(['(' coO ')  '],14,1) ...
               FixLenStr(tit, 24, 0) ...
               '  iseq = ' FixLenStr(num2str(iseq),3,1) ]);
      end
   end
   return;
elseif isvoid(ds)
   disp([indent 'void dataset object']);
   return;
end

% ID
[dd FN] = fileparts(ds.ID.FileName);
Fm = ds.ID.FileFormat;
IDstr = [indent 'Dataset ' FN];
if ~isempty(ds.ID.SeqID), 
   IDstr = [IDstr ' <' ds.ID.SeqID '>' ];
else
   IDstr = [IDstr ' <' ds.ID.StimType '>' ];
end
if isfield(ds.ID, 'mashed')
   IDstr = [IDstr ' mashed by ' num2str(ds.ID.mashed)]; 
end
IDstr = [IDstr ', ' Fm ' Seq=' num2str(ds.ID.iSeq)];
IDstr = [IDstr ', ' IDFdate(ds.ID.Time)];
IDstr = [IDstr ', ' ds.ID.Place];

% stimtype and sizes
%Nsub = num2str(ds.Sizes.Nsub);
%Nsubrec = num2str(ds.Sizes.NsubRecorded);
%Nrep = num2str(ds.Sizes.Nrep(1));
%Repdur = durStr(ds.Stimulus.Special.RepDur(1));
SizStr = [indent 'stimtype ' ds.ID.StimType ', ' subsref(ds, substruct('.', 'pres'))]; 

idp = ds.Stimulus.IndepVar;
IndepStr = [indent 'varied: ' idp.Name ' = ' (localnum2str(idp.Values.')) ' ' idp.Unit];

spec = ds.Stimulus.Special;
bd = localnum2str(spec.BurstDur);
SpecStr = [indent 'Burst = ' bd ' ms   '];
if ~any(isnan(spec.CarFreq)),
   SpecStr = [SpecStr 'Carrier = ' localnum2str(spec.CarFreq) ' Hz   ']; 
end
if ~any(isnan(spec.ModFreq)) && ~all(spec.ModFreq==0), 
   SpecStr = [SpecStr 'Mod @ ' localnum2str(spec.ModFreq) ' Hz   ']; 
end
if ~any(isnan(spec.BeatFreq)) && ~all(spec.BeatFreq==0), 
   SpecStr = [SpecStr 'Beat @ ' localnum2str(spec.BeatFreq) ' Hz   ']; 
end
if ~any(isnan(spec.BeatModFreq)) && ~all(spec.BeatModFreq==0), 
   SpecStr = [SpecStr 'BeatMod @ ' localnum2str(spec.BeatModFreq) ' Hz   ']; 
end

STR = strvcat(IDstr, SizStr, IndepStr, SpecStr);
if nargout>0,
   dispString = STR;
else
    disp(STR)
end
% locals
function s = localnum2str(x)
u = unique(x);
if length(u)==1, x = u; end;
if length(x)==1, s=num2sstr(x);
else
   s= trimspace([ '[' num2sstr(min(x))  '...' num2sstr(max(x))  ']' ]);
end
