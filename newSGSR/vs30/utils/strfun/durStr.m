function xs = durStr(x);
% DurStr - heuristic num2str version for durations in ms.

if length(x)>1, % return cell array
   xs = cell(size(x));
   for ii=1:prod(size(x)),
      xs{ii} = durStr(x(ii));
   end
   return;
end

if abs(x)>=1000, x = round(x);
elseif abs(x)>=10, x = 0.1*round(10*x);
elseif abs(x)>=1, x = 0.01*round(100*x);
else, x = 0.001*round(1000*x);
end
xs = num2str(x);