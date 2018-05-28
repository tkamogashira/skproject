function boolean = isbetween(value, range)

%B. Van de Sande 09-5-2003

boolean = logical(0);
if value >= range(1) & value <= range(2), boolean = logical(1); end

