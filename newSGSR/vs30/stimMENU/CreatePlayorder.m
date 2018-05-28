function playOrder = CreatePlayorder(Nsub, order);
% order = 0|1|2 = down|up|random

if order==0, % DOWN
   playOrder = Nsub:-1:1;
elseif order==1, % UP
   playOrder = 1:Nsub;
elseif order==2,   % RANDOM
   SetRandState;
   playOrder = randperm(Nsub);
else, 
   error('invalid play order spec');
end;
