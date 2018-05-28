function IS = IPSIside;
% IPSIside - return ipsilateral side (L|R) as depcified at session startup
global SESSION
IS = SESSION.RecordingSide(1);
