function p = repAnova1(x)
%   repeated measures Anova
%
%   P = REPANOVA1(X) for matrix X treats each column as a separate level,  
%   and determines whether the population means of the columns are equal.   
%
%   The different rows are different subjects.
%
%   REPANOVA1 prints the standard one-way ANOVA table in Figure 1 and displays 
%   a boxplot in Figure 2 (taken from ANOVA1).
%
% based on MATLAB's ANOVA1 function and 
% Bortz, J. Statistik fuer Naturwissenschaftler, 4th ed. Springer. pp. 307
%
% includes df correction for non-circular data
%
% Maximilian Riesenhuber 10/25/00

% calculate various values
G=sum(sum(x));				% total sum
P=sum(x')';				% sum of all values for each S
p=size(x,2);				% number of levels
n=size(x,1);				% number of subjects
A=sum(x);				% sum of all values in one level

% calculate the magic 4 terms
t1=G^2/(n*p);
t2=sum(sum(x.^2));
t3=sum(A.^2)/n;
t4=sum(P.^2)/p;

SS_btwS=t4-t1;
SS_winS=t2-t4;
SS_treat=t3-t1;
SS_res=t2-t3-t4+t1;
SS_tot=t2-t1;

df_btwS=n-1;
df_winS=n*(p-1);
df_treat=p-1;
df_res=(n-1)*(p-1);
df_tot=p*n-1;

sig_btwS=SS_btwS/df_btwS;
sig_winS=SS_winS/df_winS;
sig_treat=SS_treat/df_treat;
sig_res=SS_res/df_res;
sig_tot=SS_tot/df_tot;

% now do correction of degrees of freedom, if necessary
% calculate covariance matrix
sigIJ=cov(x);
sigI=mean(sigIJ);
meanSigII=mean(diag(sigIJ));
meanSig=mean(mean(sigIJ));

% calculate epsilon
e=1/(p-1)*(p^2*(meanSigII-meanSig)^2)/(sum(sum(sigIJ.^2))-2*p*sum(sigI.^2)+p^2*meanSig^2);

corr=0;
if(e<0.75)
  corr=1;
  df_treat=floor(e*df_treat);
  df_res=floor(e*df_res);
  eps=e;
elseif(e<1.0)				% epsilon correction of Huynh and Feldt
  eTilde=(n*(p-1)*e-2)/((p-1)*(n-1-(p-1)*e));
  if(eTilde<1)
    corr=1;
    eps=eTilde;
    df_treat=floor(eTilde*df_treat);
    df_res=floor(eTilde*df_res);
  end
end

if(sig_res~=0)
  F=sig_treat/sig_res;
  p= 1- fcdf(F,df_treat,df_res);
elseif(sig_treat==0)
  F=0;
  p=1;
else
  F = Inf;
  p=0;
end
  

Table=zeros(3,4);               %Formatting for ANOVA Table printout
Table(:,1)=[ SS_treat SS_res SS_tot]';
Table(:,2)=[df_treat df_res df_tot]';
Table(:,3)=[ sig_treat sig_res Inf ]';
Table(:,4)=[ F Inf Inf ]';

fig1 = figure('pos', [50 350 500 300]);
set(gca,'Visible','off');

z0 = 0.00;
y0 = 0.85;
dz = 0.15;
dy =0.06;
text(z0+0.40,y0,'ANOVA Table')
z=z0+dz;
y=y0-3*dy/2;
if(corr==0)
  colheads = ['Source       ';'         SS  ';'          df ';'       MS    ';'          F  '];
else
  colheads = ['Source           ';'             SS  ';'      df (corr.) ';'          MS     ';sprintf('F(corr.,eps=%1.2f)',eps)];
end


for i=1:5
  text(z,y,colheads(i,:))
  z = z + dz;
end
rowheads = ['Columns    ';'Error      ';'Total      '];
for i=1:3
  y = y0-(i+1.5)*dy;
  z = z0 + dz;
  h = text(z,y,rowheads(i,:));
  
  z = z + dz;
  for j=1:4
    if (Table(i,j) ~= Inf) & j ~=2,
       h = text(z,y,sprintf('%11.4g',Table(i,j)));
       z = z + dz;
    elseif j==2,
       z = z + dz/4;
       h = text(z,y,sprintf('%7.5g',Table(i,j)));
       z = z + 3*dz/4;
    end
  end
end


fig2 = figure('pos',get(gcf,'pos') + [0,-200,0,0]);

   boxplot(x,1);






