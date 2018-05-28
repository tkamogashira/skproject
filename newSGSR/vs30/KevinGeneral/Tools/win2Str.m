function Str = win2Str(Win)
%WIN2STR  converts analysis window to character string
%   Str = win2Str(Win) 

%B. Van de Sande 27-10-2003

if isempty(Win)
    Str = 'N/A'; 
else 
    Str = sprintf('[%.0f-%.0f]', Win(1), Win(2));
    
    NElem = length(Win);
    for n = 3:2:NElem
        Str = sprintf('%s, [%.0f-%.0f]', Str, Win(n), Win(n+1)); 
    end
    
    Str = [Str, ' ms'];
end