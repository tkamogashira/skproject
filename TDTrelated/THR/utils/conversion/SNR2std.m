function [std_dB, std_Cycle] = SNR2std(SNR);
% SNR2std - convert S/N ratio of spcetral components to standard deviation
%   [std_dB, std_Cycle] = SNR2std(SNR), where SNR is the S/N ratio in dB 
%   of a spectral component, returns estimates of the standard deviation
%   std_dB in the level of the component in dB, and the standard deviation
%   std_Cycle of the phase of the components in cycles. By convention, any
%   negative SNR ratios lead to std_dB == inf == std_Cycle.
%   
%   The inverse std values returned by SNR2std may be used as weights for
%   linear estimation from spectral data.
%
%   The estimates are based on numerical simulations in which a random
%   phase noise vector was added to a fixed signal.
%
%   See also wlinsolve, wlinfit, SNR2W.

% see NoiseFloorVar (in private dir) for underlying numerical work

Anoise = db2a(-SNR);
p_dB = [23.635889773590463  -57.139021043274269  52.410304163566579  -20.849344761817125  4.060198477196730  5.884684849447680  0.004755415897550];
std_dB = polyval(p_dB, Anoise);
std_dB(SNR<0) = inf;

p_cycle = [0.313684204006400  -0.736922534275086  0.655706348317446  -0.252248773593381  0.050205566591646  0.109967713920329  0.000056910279805];
std_Cycle = polyval(p_cycle, Anoise);
std_Cycle(SNR<0) = inf;

% std assymptotes to straight decaying exponential
if any(SNR>40),
    [db40, cy40] = SNR2std(40);
    std_dB(SNR>40) = db2a(a2db(db40)-(SNR(SNR>40)-40));
    std_Cycle(SNR>40) = db2a(a2db(cy40)-(SNR(SNR>40)-40));
end









