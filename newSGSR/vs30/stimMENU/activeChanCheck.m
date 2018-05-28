function [activeCh ,OK] = activeChanCheck;
% activeChanCheck - check if active channels selected are realizeable
OK = 0;
global StimMenuStatus
av = ChannelNum(SessioDAchan);
hbut = StimMenuStatus.handles.ActiveChannelButton;

activeCh = UIintFromToggle(hbut)-1;

if (av~=0) & (av~=activeCh),
   mess = strvcat('Channel specification not compatible',...
      ['with DA-channel selection of sessio' 'n.'] );
   UIerror(mess, hbut);
   return;
end

OK = 1;