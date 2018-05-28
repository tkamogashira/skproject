% BBsub
function BBsub(action)
switch(action)
    case 'start'
        B=evalin('base','B');
        sound(B,25000,16);
end;
end
