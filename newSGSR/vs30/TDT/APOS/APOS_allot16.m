function Dbn=APOS_allot16(Npts);

% function Dbn=APOS_allot16(Npts);
% APOS _allot16 - allocates 16-bit-integer, Npts long,
% DAMA buffer and returns its number.
% Note: name changed from _allot16 because heading 
% underscore troubles matlab

Dbn=s232('_allot16', Npts);

