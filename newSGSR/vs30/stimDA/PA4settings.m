function pc = PA4settings(atten);

% PA4settings - prepare PA4 calls needed for D/A
% atten is scalar 2-elem array
% pc is nx2 matrix, where n =1 or 2.
% The rows carry the arguments of the PA4atten calls.

% din addresses
PA4_1 = 1; PA4_2 = 2;


pc = [PA4_1 atten(1); PA4_2 atten(end)];
