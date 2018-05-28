function [t, smpls]=plotsubseq(SD,isub,range);

% plotsubseq - debug function
% function [t, smpls]=plotsubseq(SD,isub,range);
smpls = [];

Nhead = [0 0];
Ntail = [0 0];
if isfield(SD.PRP,'Nhead'),
	if ~isempty(SD.PRP.Nhead), 
   	Nhead = SD.PRP.Nhead(isub,:);
   	Ntail = SD.PRP.Ntail(isub,:);
   end
end;
if isfield(SD.PRP,'subseqOrder'),
   if ~isempty(SD.PRP.subseqOrder), 
      isub = SD.PRP.subseqOrder(isub);
   end
end;
ipool = SD.subseq{isub}.ipool;
att =  SD.subseq{isub}.AnaAtten;
Y = []; ichan = 0;
for ii=ipool,
   ichan = ichan + 1;
   if (ii>0),
      samP = SD.waveform{ii}.DAdata.samP;
      [t YY] = plotwaveform(SD, ii);
      if Nhead(ichan)>0, 
         YY = [zeros(1,Nhead(ichan)) YY]; 
      end;
      if Ntail(ichan)>0, 
         YY = [YY zeros(1,Ntail(ichan))]; 
      end;
      fac = db2a(-att(ichan));
      Y = [Y fac*YY'];
   end;
end
Nsam = size(Y,1);
t = 1e-3*samP*(0:Nsam-1);
if nargin>2,
   range = find((t>=range(1))&(t<=range(2)));
   t = t(range);
   Y = Y(range,:);
end

f1;
plot(t', Y);
xlabel('time (ms)');