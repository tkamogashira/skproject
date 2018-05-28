function Name = setPA4s(dB);

% function setPA4s(dB); - set PA4s (or PA5s) ...
% to dB(1) and dB(2) or  both to dB(1) if dB is scalar
% If called with an argout, the names of the attenuators
% are returned in a string (PA4 vs PA5) and the attenuators
% are set to their max value.

if nargout>0,
   Name = [PA4atten(1), '; ' PA4atten(2), '; ' ];
   return;
end


dB = dB(:);
if (length(dB)==1), dB=[dB; dB]; end;

PA4atten(1,dB(1));
PA4atten(2,dB(2));

