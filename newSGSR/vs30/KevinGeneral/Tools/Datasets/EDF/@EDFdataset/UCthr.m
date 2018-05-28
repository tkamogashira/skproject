function varargout = UCthr(keyword, varargin);
% UCthr - THR curve function overloaded for EDF datasets

%B. Van de Sande 08-10-2003

%=====handling of inputs, outputs, recursive calls is handles by generic ucXXX switchboard script========
[dummy, callerfnc] = fileparts(mfilename); %Nasty Trick: All the other local functions are redirected to
                                           %the original ucthr.m ???
UCxxxSwitchboard

%==========================the real action is handled by local functions below===========================
function THR = localComputeIt(ds, params)

ds = fillDataset(ds);
TC = ds.dataset.data.OtherData.thrCurve;

THR.params = params;
THR.DSinfo = emptyDataset(ds);
THR.iSub   = [];
THR.Freq   = TC.freq;
THR.Thr    = TC.threshold;
[THR.CF, THR.minThr] = minloc(THR.Freq, THR.Thr); % (freq of) minimum thr
[THR.Ymin, THR.Ymax] = deal(params.Ymin, params.Ymax);
if isequal('auto', THR.Ymin), THR.Ymin = subsref(ds, struct('type', '.', 'subs', 'minSPL')); end
if isequal('auto', THR.Ymax), THR.Ymax = subsref(ds, struct('type', '.', 'subs', 'SPL')); end
[THR.Xscale, THR.Xunit] = deal(params.Xscale, params.Xunit);
if isequal('auto', THR.Xunit), % decide based on freq range
   if max(THR.Freq>1000), THR.Xunit = 'kHz';
   else, THR.Xunit = 'Hz';
   end
end
if isequal('auto', THR.Xscale),
   if (max(THR.Freq)/min(THR.Freq))>2, THR.Xscale = 'log';
   else, THR.Xscale = 'lin';
   end
end
THR.SpontRate = subsref(ds, struct('type', {'.', '.'}, 'subs', {'ThrCurveParam', 'NSponRec'})) * ...
                subsref(ds, struct('type', {'.', '.'}, 'subs', {'ThrCurveParam', 'MeanSA'}));
THR.plotfnc   = mfilename;