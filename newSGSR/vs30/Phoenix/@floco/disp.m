function disp(f);
% Floco/disp - disp for floco objects
f = struct(f);
disp(f)
for ii=1:length(f.node),
   disp(['   ---node ' num2str(ii) '---']);
   disp(f.node(ii))
end

