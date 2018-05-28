% Test CACHE
SParam.Name = 'Bram Van de Sande';
SParam.Nr   = 1;
Data = { 'Junk voor Bram' };
PutInHashFile('cachetest', SParam, Data, -7);

SParam.Name = 'Lore Van de Sande';
SParam.Nr   = 2;
Data = { 'Junk voor Lore' };
PutInHashFile('cachetest', SParam, Data, -7);

SParam.Name = 'Judith Van de Sande';
SParam.Nr   = 3;
Data = { 'Junk voor Judith' };
PutInHashFile('cachetest', SParam, Data, -7);

SParam.Name = 'Dominique Ostyn';
SParam.Nr   = 4;
Data = { 'Junk voor Dominique' };
PutInHashFile('cachetest', SParam, Data, -7);

SParam.Name = 'Tom Debruyne';
SParam.Nr   = 5;
Data = { 'Junk voor Tom' };
PutInHashFile('cachetest', SParam, Data, -7);

SParam.Name = 'Vincent Maertens';
SParam.Nr   = 6;
Data = { 'Junk voor Vincent' };
PutInHashFile('cachetest', SParam, Data, -7);

SParam.Name = 'Ans Pelgrims';
SParam.Nr   = 7;
Data = { 'Junk voor Ans' };
PutInHashFile('cachetest', SParam, Data, -7);

SParam.Name = 'Rudy Alliet';
SParam.Nr   = 8;
Data = { 'Junk voor Rudy' };
PutInHashFile('cachetest', SParam, Data, -7);

SParam.Name = 'Lore Van de Sande';
SParam.Nr   = 2;

Data = GetFromHashFile('cachetest', SParam);

% Test STORAGE
SParam.Name = 'Bram Van de Sande';
SParam.Nr   = 1;
Data = { 'Junk voor Bram' };
PutInHashFile('storagetest', SParam, Data, 7);

SParam.Name = 'Lore Van de Sande';
SParam.Nr   = 2;
Data = { 'Junk voor Lore' };
PutInHashFile('storagetest', SParam, Data, 7);

SParam.Name = 'Judith Van de Sande';
SParam.Nr   = 3;
Data = { 'Junk voor Judith' };
PutInHashFile('storagetest', SParam, Data, 7);

SParam.Name = 'Dominique Ostyn';
SParam.Nr   = 4;
Data = { 'Junk voor Dominique' };
PutInHashFile('storagetest', SParam, Data, 7);

SParam.Name = 'Tom Debruyne';
SParam.Nr   = 5;
Data = { 'Junk voor Tom' };
PutInHashFile('storagetest', SParam, Data, 7);

SParam.Name = 'Vincent Maertens';
SParam.Nr   = 6;
Data = { 'Junk voor Vincent' };
PutInHashFile('storagetest', SParam, Data, 7);

SParam.Name = 'Ans Pelgrims';
SParam.Nr   = 7;
Data = { 'Junk voor Ans' };
PutInHashFile('storagetest', SParam, Data, 7);

SParam.Name = 'Rudy Alliet';
SParam.Nr   = 8;
Data = { 'Junk voor Rudy' };
PutInHashFile('storagetest', SParam, Data, 7);

SParam.Name = 'Lore Van de Sande';
SParam.Nr   = 2;

Data = GetFromHashFile('storagetest', SParam);

%Gegevens opruimen ...
DeleteHashFile('cachetest');
DeleteHashFile('storagetest');