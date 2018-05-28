function TW = ExpandTimeWindow(TW, ds);
% ExpandTimeWindow - convert timewindow specification to full [start end] value
if ischar(TW),
   switch lower(TW)
   case 'repdur', TW = [min(ds.repdur)];
   case 'burstdur', 
      bd = ds.burstdur;
      if ~isnan(bd(1)), TW = [bd(1)];
      elseif ~isnan(bd(end)), TW = [bd(end)];
      else, TW = ExpandTimeWindow('repdur', ds);
      end
   case 'lburstdur', TW = [max(ds.burstdur(1))];
   case 'rburstdur', TW = [max(ds.burstdur(end))];
   otherwise, error(['invalid timewindow value "' TW '"']);
   end
end
if length(TW)==1, TW=[0 TW]; end;


