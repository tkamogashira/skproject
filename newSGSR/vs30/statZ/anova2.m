function p = anova2(X,reps)
%ANOVA2 Two-way analysis of variance.
%   ANOVA2(X,REPS) performs a balanced two-way ANOVA for comparing the
%   means of two or more columns and two or more rows of the sample in X.
%   The data in different columns represent changes in one factor. The data
%   in different rows represent changes in the other factor. If there is 
%   more than one observation per row-column pair, then the argument, REPS,
%   indicates the number of observations per "cell". A cell contains REPS 
%   number of rows.
%
%   For example, if REPS = 3, then each cell contains 3 rows and the total
%   number of rows must be a multiple of 3. If X has 12 rows, and REPS = 3,
%   then the "row" factor has 4 levels (3*4 = 12). The second level of the 
%   row factor goes from rows 4 to 6.  

%   Reference: Robert V. Hogg, and Johannes Ledolter, Engineering Statistics
%   Macmillan 1987 pp. 227-231. 

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:44:48 $

[r,c] = size(X);
if nargin == 1,
  reps = 1;
  m=r;
  Y = X;
elseif reps == 1
  m=r;
  Y = X;
else
  m = r/reps;
  if (floor(m) ~= r/reps), 
      error('The number of rows must be a multiple of reps.');
  end
  Y = zeros(m,c);
  for i=1:m,
      j = (i-1)*reps;
      Y(i,:) = mean(X(j+1:j+reps,:));
  end
end
colmean = mean(Y);          % column means
rowmean = mean(Y');         % row means
gm = mean(colmean);         % grand mean
df1 = c-1;                  % Column degrees of freedom
df2 = m-1;                  % Row degrees of freedom
if reps == 1,
  edf = (c-1)*(r-1);% Error degrees of freedom. No replication. This assumes an additive model.
else
  edf = (c*m*(reps-1));     % Error degrees of freedom with replicates
  idf = (c-1)*(m-1);        % Interaction degrees of freedom
end
CSS = m*reps*(colmean - gm)*(colmean-gm)';              % Column Sum of Squares
RSS = c*reps*(rowmean - gm)*(rowmean-gm)';              % Row Sum of Squares
correction = (c*m*reps)*gm^2;
TSS = sum(sum(X .* X)) - correction;                    % Total Sum of Squares
ISS = reps*sum(sum(Y .* Y)) - correction - CSS - RSS;   % Interaction Sum of Squares
if reps == 1,
  SSE = ISS;
else
  SSE = TSS - CSS - RSS - ISS;          % Error Sum of Squares
end

if (SSE~=0)
    MSE  = SSE/edf;
    colf = (CSS/df1) / MSE;
    rowf = (RSS/df2) / MSE;
    colp = 1 - fcdf(colf,df1,edf);  % Probability of F given equal column means.
    rowp = 1 - fcdf(rowf,df2,edf);  % Probability of F given equal row means.
    p    = [colp rowp];

    if (reps > 1),
       intf = (ISS/idf)/MSE;
       ip   = 1 - fcdf(intf,idf,edf);
       p   = [p ip];
    end
    
else                    % Dealing with special cases around no error.

    if CSS==0,          % No between column variability.            
      colf = 0;
      colp = 1;
    else                % Between column variability.
      colf = Inf;
      colp = 0;
    end

    if RSS==0,          % No between row variability.
      rowf = 0;
      rowp = 1;
    else                % Between row variability.
      rowf = Inf;
      rowp = 0;
    end
    
    p = [colp rowp];

    if (reps>1) & (ISS==0)  % Replication but no interactions.
      intf = 0;
      p = [p 1];
    elseif (reps>1)         % Replication with interactions.
      intf = Inf;
      p = [p 0];
    end 


end

if (reps > 1),
  numrows = 5;
  Table=zeros(numrows,4);   %Formatting for ANOVA Table printout with interactions.
  Table(:,1)=[ CSS RSS ISS SSE TSS]';
  Table(:,2)=[df1 df2 idf edf r*c-1]';
  Table(:,3)=[ CSS/df1 RSS/df2 ISS/idf SSE/edf Inf ]';
  Table(:,4)=[ colf rowf intf Inf Inf ]';
else
  numrows = 4;
  Table=zeros(4,4);         %Formatting for ANOVA Table printout no interactions.
  Table(:,1)=[ CSS RSS SSE TSS]';
  Table(:,2)=[df1 df2 edf r*c-1]';
  Table(:,3)=[ CSS/df1 RSS/df2 SSE/edf Inf ]';
  Table(:,4)=[ colf rowf Inf Inf ]';
end

  
  
figh = figure('pos', [50 350 500 300]);
z0 = 0.00;
y0 = 0.85;
dz = 0.15;
dy =0.06;
text(z0+0.40,y0,'ANOVA Table')
axis off

z=z0+dz;
y=y0-3*dy/2;
colheads = ['Source       ';'         SS  ';'          df ';'       MS    ';...

'          F  '];

for i=1:5
  text(z,y,colheads(i,:))
  z = z + dz;
end
drawnow
if numrows == 5,
  rowheads = ['Columns    ';'Rows       ';'Interaction';'Error      ';'Total      '];
else
  rowheads = ['Columns    ';'Rows       ';'Error      ';'Total      '];
end
for i=1:numrows
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
  drawnow
end
