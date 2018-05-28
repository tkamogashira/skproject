function Date = TransFormMadisonDate(Date)

Days  = Date(1:2);
Month = strrep(lower(Date(3:6)), '-', '');
Year  = Date(7:8);

%Date = {Days Month Year};
Date = datevec([Days Month Year], 1900);