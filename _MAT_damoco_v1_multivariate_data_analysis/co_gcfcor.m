function [COR, Delta_self, Delta_ext, q2_shift]=co_gcfcor(q1,q2)
% DAMOCO Toolbox, function CO_GCFCOR, version 17.01.11
% This function computes the correlation between two coupling functions
% given on a grid. This correlation is  defined as the maximum over possible 
% relative shifts of the coupling functions. 
% q1 serves as the reference fucntion, while q2 is shifted. 
% 
% Form of call: 
%               [COR] = co_gcfcor(q1, q2)
%               [COR, Delta_self] = co_gcfcor(q1, q2) 
%               [COR, Delta_self, Delta_ext]=co_gcfcor(q1, q2) 
%               [COR, Delta_self, Deltaext, q2_shift]=co_fbcfcor(q1, q2) 
% Input:
%       q1:             The coupling function of the first oscillator, it is used as
%                       the reference. 
%                       It must not contain the autonomous frequency!
%       q2:             The coupling function of the 2nd oscialltor. This one is shifted
%                       in the test, so the shifts reported refer to this function. 
%                       It must not contain the autonomous frequency!
% Output:
%       COR:            Maximal correlation of the coupling functions
%       Delta_self:     Phase shift of the own phase of q2 which provides
%                       the maximal correlation of two coupling functions.
%       Delta_ext:      Phase shift of the external phase of q2 which provides
%                       the maximal correlation of the two coupling functions.
%       q2_shift:       q2 shifted according to Delta_self, Delta_ext, so that
%                       correlation of q1 and q2_shift is maximal
%                       for Delta_self=0, Delta_ext=0.
%
q1 = q1(1:end-1,1:end-1);    % Deleting last points in the matrix. 
q2 = q2(1:end-1,1:end-1);    %B y convention these are identical to the first one. 
ngrid = size(q1); ngrid = ngrid(1);
Q2 =[q2 q2; q2 q2];
autCor1 = trapz(trapz(q1.*q1)); % Autocorrelation
autCor2 = trapz(trapz(q2.*q2)); % Autocorrelation
m1=0; m2=0; COR=0;
for n = 0 : ngrid - 1;
    for m = 0:ngrid -1;
        A = Q2(ngrid+1-n:2*ngrid-n, ngrid+1-m:2*ngrid-m);
        a = trapz(trapz(q1.*A)) /(sqrt(autCor1*autCor2));
            if a > COR;
                m1 = n;
                m2 = m;
                COR = a;
                q2_shift = A;
            end;
    end
end;
Delta_ext = mod(2*pi - 2*pi*(m2) / ngrid, 2*pi);
Delta_self  = mod(2*pi - 2*pi*(m1) / ngrid, 2*pi);

q2_shift(:,end+1)=q2_shift(:,1); % Adding last points using the  periodicity.
q2_shift(end+1,:)=q2_shift(1,:); 
q2_shift(end,end)=q2_shift(1,1); 
end
