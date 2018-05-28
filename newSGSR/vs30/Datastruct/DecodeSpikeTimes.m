function ST = DecodeSpikeTimes(C)
% DecodeSpikeTimes - decode spike time struct
%
% See also CodeSpikeTimes

if isempty(C.isi16), % not a true coded aray
   ST = cumsum(C.isi);
   return
end

ST = C.shift + double(C.isi16);
ST(C.isi16==C.Flag) = C.isi;
ST = cumsum(ST);
