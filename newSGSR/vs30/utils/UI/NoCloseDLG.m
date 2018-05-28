function y=NoCloseDLG(figh, errMess, dlgTitle);
% NoCloseDLG - don't-close close request function
%   usage: NoCloseDLG(figh, errMess, dlgTitle)

persistent ErrMess DlgTitle
if isequal('M', figh), y = ErrMess;
elseif isequal('T', figh), y = DlgTitle;
else,
   [ErrMess, DlgTitle] = deal(errMess, dlgTitle);
   closeDLG = 'errordlg( NoCloseDLG(''M''), NoCloseDLG(''T''), ''Modal'');';
   set(figh, 'closereq', closeDLG),
end


