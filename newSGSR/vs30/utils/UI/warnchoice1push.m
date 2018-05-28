function y=warnchoice1push;

% subtitle uiobject functions as "reaper"
% userdata fig property is used to store button text

set(gcbf,'Userdata', get(gcbo,'string'));
delete(findobj(gcbf,'tag', 'SubTitle'));