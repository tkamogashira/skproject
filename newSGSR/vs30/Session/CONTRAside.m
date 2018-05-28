function CS = CONTRAside;
% CONTRAside - return contralateral side (L|R) as specified at session startup

IS = ipsiSide;
switch IS,
case 'L', CS = 'R';
case 'R', CS = 'L';
end