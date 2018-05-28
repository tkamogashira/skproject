function y=reconstructAll;
ml = menufiglist;
for ii=1:length(ml),
   mname = ml{ii}
   % open existing menu, save & close
   oo(mname); figsave; aa; % this updates filename
   % now reconstruct and save
   reconstructmenu(mname);
   figsave;
   aa;
end