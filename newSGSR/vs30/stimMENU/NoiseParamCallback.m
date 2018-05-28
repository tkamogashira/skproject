function [Flow, Fhigh, OK]= noiseparamcallback(figh);
% noiseparamcallback - handle toggles of noiseparam unit
if nargin<1, figh = gcbf; end;
Flow = NaN;
Fhigh = NaN;
OK =0;

f1h = findobj(figh,'tag','Freq1Edit');
f2h = findobj(figh,'tag','Freq2Edit');
f1ph = findobj(figh,'tag','Freq1Prompt');
f2ph = findobj(figh,'tag','Freq2Prompt');
FSh = findobj(figh,'tag','FreqSpecButton');
FUh = findobj(figh,'tag','Freq2Button');
FSstr = {'Lo/Hi','CF/BW'};
FUstr = {'Hz','Oct'};
f1p1 = 'low edge:';
f2p1 = 'high edge:';
f1p2 = 'center freq:';
f2p2 = 'bandwidth:';
prompts = {f1p1, f2p1, f1p2, f2p2};
FSval = get(FSh,'userdata');
FUval = get(FUh,'userdata');
localSetPrompts([f1ph, f2ph], prompts, FSval);

f1 = abs(uidoublefromstr(f1h,1));
f2 = abs(uidoublefromstr(f2h,1));
if ~checkNaNandInf([f1 f2]), return; end;

% current values
[Flow, Fhigh] = localLoHi(f1,f2,FSval, FUval);
if Fhigh<Flow, UIerror('low freq > high freq', [f1h f2h]);
elseif Fhigh>maxStimFreq, UIerror('frequencies too high', [f1h f2h]);
elseif Flow<0, UIerror('bandwidth/2 > center freq', f2h);
else, OK = 1;
end
if nargout>0, return; end;

% from here: this function is called by a button on the menu
TAG = get(gcbo,'tag');
Dec = 10;
switch TAG
case 'FreqSpecButton', % toggle freq spec mode
   if FSval==1, % lo/hi->cf/bw
      [CF, BW] = localLoHi2CFBW(Flow, Fhigh);
      if FUval==2, 
         [CF, BW] = localHz2Oct(CF, BW);
         setstring(FUh, FUstr{2});
         Dec = 100;
      end
      setstring(f1h, num2str(round(CF*Dec)/Dec));
      setstring(f2h, num2str(round(BW*Dec)/Dec));
      localSetPrompts([f1ph, f2ph], prompts, 2);
      setstring(FSh, FSstr{2});
      set(FSh, 'userdata', 2);
   else, % cf/bw -> lo/hi
      if FUval==2, % disable Oct mode of f2 unit
         setstring(FUh, FUstr{1});
         Dec = 10;
      end
      setstring(f1h, num2str(round(Flow*Dec)/Dec));
      setstring(f2h, num2str(round(Fhigh*Dec)/Dec));
      setstring(FSh, FSstr{1});
      localSetPrompts([f1ph, f2ph], prompts, 1);
      set(FSh, 'userdata', 1);
   end
case 'Freq2Button',
   if FSval==2,
      if FUval==1, % Hz->Oct
         [CF, BW] = localHz2Oct(f1, f2);
         setstring(FUh, FUstr{2});
         set(FUh, 'userdata', 2);
         Dec = 100;
      else, % Oct->Hz
         [CF, BW] = localOct2Hz(f1, f2);
         setstring(FUh, FUstr{1});
         set(FUh, 'userdata', 1);
         Dec = 1;
      end
      setstring(f1h, num2str(round(CF*Dec)/Dec));
      setstring(f2h, num2str(round(BW*Dec)/Dec));
   end
end
drawnow;

%-----------------
function [Lo, Hi] = localLoHi(f1,f2,FSval, FUval);
if FSval==1, % Hi/Lo
   Lo = f1; Hi = f2;
elseif FUval==1, % CF, BW in Hz
   [Lo, Hi] = localCFBW2LoHi(f1,f2);
else % CF in Hz, BW in Oct
   [CF, BW] = localOct2Hz(f1, f2);
   [Lo, Hi] = localCFBW2LoHi(CF, BW);
end

function [CF, BW] = localLoHi2CFBW(Lo,Hi);
CF = 0.5*(Lo+Hi);
BW = Hi-Lo;
function [Lo, Hi] = localCFBW2LoHi(CF,BW);
Lo = CF-BW/2;
Hi = CF+BW/2;
function [CF, BWoct] = localHz2Oct(CFhz, BWhz);
[Lo Hi] = localCFBW2LoHi(CFhz, BWhz);
CF = sqrt(Lo*Hi);
BWoct = log2(Hi/Lo);
function [CF, BW] = localOct2Hz(CFoct, BWoct);
Lo = CFoct/pow2(BWoct/2);
Hi = CFoct*pow2(BWoct/2);
[CF, BW] = localLoHi2CFBW(Lo, Hi);
function localSetPrompts(handles, prompts, FSval);
setstring(handles(1), prompts{1+2*(FSval-1)});
setstring(handles(2), prompts{2+2*(FSval-1)});
drawnow;
