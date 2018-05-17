function [A, a, k] = grnwdspc(spc)
%GRNWDSPC Determine frequency-position constants from species name.
%   Only species supported:
%   human, cat, chinchilla, gerbil, guinea pig, macaque, oppossum, mouse,
%   rat, cow, elephant.

%  Copyright (c) 2001 by Michael Kiefte.

species = {'human', 'cat', 'chinchilla', 'gerbil', 'guinea pig', 'macaque', ...
        'oppossum', 'mouse', 'rat', 'cow', 'elephant'};

i = strmatch(spc, species);
if length(i) == 0
    error('No match for species.')
elseif length(i) > 1
    error('Multiple matchs. Try a longer string.')
end

switch i
case 1 % human
    A = 165; a = 2.1/35; k = 1;
case 2 % cat
    A = 456; a = 2.1/25; k = 0.8;
case 3 % chinchilla
    A = 163.5; a = 2.1/18.4; k = 0.85;
case 4 % gerbil
    A = 398; a = 2.2/12.1; k = 0.631;
case 5 %  guinea pig
    A = 350; a = 2.1/18.5; k = 0.85;
case 6 % macaque
    A = 360; a = 2.1/25.6; k = 0.85;
case 7 % oppossum
    A = 5821; a = 1/6.4; k = 0.564;
case 8 % mouse
    A = 960; a = 2.04/6.8; k = 0.85;
case 9 % rat
    A = 7613.3; a = 0.928/8.03; k = 1;
case 10 % cow
    A = 52.6; a = 2.1/38.3; k = 1;
case 11 % elephant
    A = 81; a = 1.8/60; k =1;
end
