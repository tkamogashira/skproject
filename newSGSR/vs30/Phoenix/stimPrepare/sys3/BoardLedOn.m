function boardledon(s);

%%controls LEDs 1 to 4

if nargin < 1,
    s = 1;
end

%sys3loadCOF('debounce', 'RV8_1', 50);     

if s == 1
    sys3setpar(0, 'Led1', 'RV8_1');
elseif s == 2 
    sys3setpar(0, 'Led2', 'RV8_1');
elseif s == 3 
    sys3setpar(0, 'Led3', 'RV8_1');
elseif s == 4 
    sys3setpar(0, 'Led4', 'RV8_1');    
else 
    disp('Wrong input argument, choose 1 or 2');
    return;
end

%sys3run('RV8_1');