function finish;


if isdeveloper, 
   hh  = openuimenu('warnclose');
   tic;
   while toc<5,
      pause(0.1);
      if  ~ishandle(hh.Root), 
         error('User prevented quitting.'); 
      elseif  ~ishandle(hh.CloseButton), 
         break;
      end; % 
   end
   delete(hh.Root);
end
try,
   if AP2present,
      S2CLOSE; % unlock AP2 and XBDRV if claimed
   end
end