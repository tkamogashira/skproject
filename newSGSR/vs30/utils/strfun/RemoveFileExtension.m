function fn = RemoveFileExtension(ffn);

% function fn = RemoveFileExtension(ffn);
% removes extension from filename

lastperiod = max(findstr('.', ffn));
if isempty(lastperiod),
   fn = ffn;
else
   fn = ffn(1:(lastperiod-1));
end


