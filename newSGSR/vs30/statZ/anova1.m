function p = anova1(x,group)
%ANOVA1 One-way analysis of variance (ANOVA).
%   ANOVA1 performs a one-way ANOVA for comparing the means of two or more 
%   groups of data. It returns the p-value for the null hypothesis that the
%   means of the groups are equal.
%
%   P = ANOVA1(X) for matrix, X, treats each column as a separate group,  
%   and determines whether the population means of the columns are equal.   
%   This one-input form of ANOVA1 is appropriate when each group has the
%   same number of elements (balanced ANOVA).
%
%   P = ANOVA1(X,GROUP) has vector inputs X and GROUP. The vector, GROUP, 
%   identifies the group of the corresponding element of X. This two-input
%   form of ANOVA1 has no restrictions on the number of elements in each
%   group.    
% 
%   ANOVA1 prints the standard one-way ANOVA table in Figure 1 and displays 
%   a boxplot in Figure2.

%   Reference: Robert V. Hogg, and Johannes Ledolter, Engineering Statistics
%   Macmillan 1987 pp. 205-206.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.9 $  $Date: 1998/05/28 20:13:53 $


if nargin == 2
   lx = length(x);
   if lx ~= prod(size(x))
     error('First argument has to be a vector.')
   end

   li = length(group);
   if li ~= lx
     error('The inputs must be the same length.');
   end

   if any(group < 1) | any(floor(group) ~= group)
     error('The second argument must be a positive integer.');
   end
   x = x(:);
   group = group(:);
   maxi = max(group);
   xm = zeros(1,maxi);
   countx = xm;
   for j = 1:maxi
      k = find(group == j);
      if j == 1
          M = x(k);
      else
         [r, c] = size(M);
         lk = length(k);
         if lk > r
       tmp = NaN;
            M(r+1:lk,:) = tmp(ones(lk - r,c));
            tmp = x(k);
            M = [M tmp];
         else
            tmp = x(k);
            tmp1 = NaN;
            tmp((lk + 1):r,1) = tmp1(ones(r - lk,1));
            M = [M tmp];
         end
      end
            
      countx(j) = length(k);
      xm(j) = mean(x(k));               % column means
   end

   gm = mean(x);                       % grand mean
   df1 = maxi - 1;                     % Column degrees of freedom
   df2 = lx - maxi;                    % Error degrees of freedom
   RSS = countx .* (xm - gm)*(xm-gm)'; % Regression Sum of Squares


   
end

if nargin == 1   
   [r,c] = size(x);
   xm = mean(x);              % column means
   gm = mean(xm);             % grand mean
   df1 = c-1;                 % Column degrees of freedom
   df2 = c*(r-1);             % Error degrees of freedom
   RSS = r*(xm - gm)*(xm-gm)';        % Regression Sum of Squares
end

TSS = (x(:) - gm)'*(x(:) - gm);    % Total Sum of Squares
SSE = TSS - RSS;                   % Error Sum of Squares

if (SSE~=0)
   F = (RSS/df1) / (SSE/df2);
   p = 1 - fcdf(F,df1,df2);     % Probability of F given equal means.
elseif (RSS==0)                 % Constant Matrix case.
   F = 0;
   p = 1;
else                            % Perfect fit case.
   F = Inf;
   p = 0;
end

Table=zeros(3,4);               %Formatting for ANOVA Table printout
Table(:,1)=[ RSS SSE TSS]';
Table(:,2)=[df1 df2 df1+df2]';
Table(:,3)=[ RSS/df1 SSE/df2 Inf ]';
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
colheads = ['Source       ';'         SS  ';'          df ';'       MS    ';'          F  '];

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

if nargin == 1
   boxplot(x,1);
else
   boxplot(M,1);
   h = get(gca,'XLabel');
   set(h,'String','Group Number');
end


