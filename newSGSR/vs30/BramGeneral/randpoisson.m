function n = randpoisson(avg)
%RANDPOISSON    generate random integer numbers according to poisson distribution
%   n = RANDPOISSON(avg) generate random integer number n according to poisson distribution with
%   expected value avg.
%
%   See also RAND, RANDN

%B. Van de Sande 02-04-2003

limit = exp(-avg);
n = 0; val = rand(1,1);
while (val > limit) 
    val = val * rand(1,1);
    n = n + 1;
end
