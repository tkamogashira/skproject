function regstats(responses,data,model)
%REGSTATS Regression diagnostics for linear models.
%   REGSTATS(RESPONSES,DATA,MODEL) fits a multiple regression of the
%   measurements in the vector, RESPONSES on the values in the matrix,
%   DATA. The function creates a UI that displays a group of checkboxes
%   that save diagnostic statistics to the base workspace using specified
%   variable names. MODEL, controls the order of the regression
%   model. By default, REGSTATS uses a linear additive model
%   with a constant term. MODEL can be following strings:
%   interaction - includes constant, linear, and cross product terms.
%   quadratic - interactions plus squared terms.
%   purequadratic - includes constant, linear and squared terms.

%   Reference Goodall, C. R. (1993). Computation using the QR decomposition. 
%   Handbook in Statistics, Volume 9.  Statistical Computing
%   (C. R. Rao, ed.).   Amsterdam, NL: Elsevier/North-Holland.

%   B.A. Jones 1-17-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.10 $  $Date: 1997/11/29 01:46:39 $

if ~isstr(responses) 
    action = 'start';
else
    action = responses;
end

%On recursive calls get all necessary handles and data.
if ~strcmp(action,'start')
  diagfig = findobj('Tag','diagfig');
  ud = get(diagfig,'UserData');
  y = ud{1};
  X = ud{2};
  idx = ud{3};
  texthandle = ud{4};
end

%Initialize GUI
if strcmp(action,'start')
   if nargin < 3
      model = 'linear';
   end
   X = x2fx(data,model);
   diagfig = figure('Units','Normalized',...
           'Position',[0.1 0.5 0.5 0.5],'Color',[.5 .5 .5],...
         'Userdata',{responses, X, [], []},'Tag','diagfig');

   textlables = str2mat('Q from QR Decomposition','R from QR Decomposition','Coefficients','Coefficient Covariance','Fitted Values');
   textlables = str2mat(textlables,'Residuals','Mean Square Error');
   textlables = str2mat(textlables,'Leverage','Hat Matrix','Delete-1 Variance');
   textlables = str2mat(textlables,'Delete-1 Coefficients','Standardized Residuals');
   textlables = str2mat(textlables,'Studentized Residuals','Change in Beta',...
                    'Change in Fitted Value','Scaled change in Fit');
   textlables = str2mat(textlables,'Change in Covariance','Cook''s Distance');

   varnames = {'Q','R','beta','covb','yhat','r','mse','leverage','hatmat','s2_i',...
   'beta_i','standres','studres','dfbeta','dffit','dffits','covratio','cookd'};

   uicontrol(diagfig,'Style','text','Units','normalized',...
          'Position',[0.02 0.92 0.4 0.04],...
          'BackgroundColor',[.5 .5 .5],...
          'String','Regression Diagnostics','ForegroundColor','k');

   uicontrol(diagfig,'Style','Pushbutton','Units','normalized',...
          'Position',[0.5 0.92 0.3 0.06],...
          'BackgroundColor',[.5 .5 .5],...
          'String','Calculate Now','ForegroundColor','k',...
          'Callback',['regstats(''calculate'')']);

   chkboxes = zeros(18,1);
   for k = 1:18
       boxcol = rem(k-1,9)+1;
       boxrow = floor(k/9-eps);
       chkboxes(k) = uicontrol(diagfig,'Style','checkbox','Units','normalized',...
         'Position',[0.02+0.45*boxrow 0.9-0.1*boxcol 0.4 0.07],...         
         'BackgroundColor','w','String',textlables(k,:),'Tag',int2str(k),...
         'UserData',varnames{k},'ForegroundColor','k');
   end

close_button = uicontrol('Style','Pushbutton','Units','normalized',...
               'Position',[0.90 0 0.07 0.07],'Callback','close','String','Close');

help_button = uicontrol('Style','Pushbutton','Units','normalized',...
               'Position',[0.90 0.10 0.07 0.07],'Callback','regstats(''help'')','String','Help');

elseif strcmp(action,'calculate')
  varhandles = zeros(18,1);
  idx = (1:18)';
  varnames = cell(18,1);
  for k = 18:-1:1
    varhandles(k) = findobj(gcf,'Tag',int2str(k));
    if get(varhandles(k),'Value') == 0, idx(k) = [];end
    varnames{k} = get(varhandles(k),'UserData');
  end
  
  for k=1:length(idx)
     if k == 1
        entrystr = varnames{idx(k)};
     else
        entrystr = [entrystr,', ',varnames{idx(k)}];
     end
  end
  instr = varnames(idx);
  promptstr = 'Enter variable names for regression diagnostics or use defaults.';
  dlghandle = dialog('Visible','off','WindowStyle','modal');

  set(dlghandle,'Units','pixels','Position',[100 300 400 100],'Visible','on');
  uicontrol(dlghandle,'Style','text','Units','pixels',...
          'Position',[10 75 380 20],...
          'String',promptstr);

  texthandle = uicontrol(dlghandle,'Style','edit','Units','pixels',...
               'String',entrystr,'HorizontalAlignment','left');
  txtlength = get(texthandle,'Extent');
  if txtlength(3) > 350
     pos = [10 30 380 40];
     set(texthandle,'Max',2,'Position',pos)
  else
     pos = [(180 - (ceil(txtlength(3)/2))+15) 40 txtlength(3)+29 20];
     set(texthandle,'Position',pos)
  end 

  ok_button = uicontrol('Style','Pushbutton','Units','pixels',...
               'Position',[180 5 40 20],'Callback','regstats(''output'');close(gcbf)','String','OK');

  ud{3} = idx;
  ud{4} = texthandle;
  set(diagfig,'UserData',ud);

elseif strcmp(action,'output')
  [Q,R]=qr(X,0);
  beta = R\(Q'*y);
  yhat = X*beta;
  residuals = y - yhat;
  nobs = length(y);
  p = min(size(R));
  mse = sum(residuals.*residuals)./(nobs-p);
  E = X/R;
  h = sum((E.*E)')';
  s_sqr_i = ((nobs-p)*mse - residuals.*residuals./(1-h))./(nobs-p-1);
  e_i = residuals./sqrt(s_sqr_i.*(1-h));
  ri = R\eye(p);
  xtxi = ri*ri';
  s = get(texthandle,'String');
  cpos=findstr(s,',');
  if isempty(cpos)
     C = {s};
  else
     nvars = length(cpos)+1;
     C = cell(nvars,1);
     for k = 1:nvars
         if k == 1
            C{k} = s(1:cpos(1)-1);
         elseif k == nvars
            C{k} = s((cpos(k-1)+1):end);
         else
            C{k} = s((cpos(k-1)+1):(cpos(k)-1));
         end
     end
  end

  if (any(idx == 1))
    % Q from the QR decomposition of the X matrix.
     Qstr = C{find(idx==1)};
     Qstr = fliplr(deblank(fliplr(Qstr)));
	 assignin('base',Qstr,Q);
  end
  if (any(idx == 2))
    % R from the QR decomposition of the X matrix.
     Rstr = C{find(idx==2)};
     Rstr = fliplr(deblank(fliplr(Rstr)));
	 assignin('base',Rstr,R);
  end
  if (any(idx == 3))
    % Coefficients.
     bstr = C{find(idx==3)};
     bstr = fliplr(deblank(fliplr(bstr)));
	 assignin('base',bstr,beta);
  end
  if (any(idx == 4))
    % Covariance of the parameters.
     covb = xtxi*mse;
     covbstr = C{find(idx==4)};
     covbstr = fliplr(deblank(fliplr(covbstr)));
     assignin('base',covbstr,covb);
  end
  if (any(idx == 5))
    % Fitted values.
     yhatstr = C{find(idx==5)};
     yhatstr = fliplr(deblank(fliplr(yhatstr)));
     assignin('base',yhatstr,yhat);
  end
  if (any(idx == 6))
     % Residuals.
     rstr = C{find(idx==6)};
     rstr = fliplr(deblank(fliplr(rstr)));
     assignin('base',rstr,residuals);
  end
  if (any(idx == 7))
    % Mean squared error.
     msestr = C{find(idx==7)};
     msestr = fliplr(deblank(fliplr(msestr)));
     assignin('base',msestr,mse);
  end
  if (any(idx == 8))
    % Leverage.
     hstr = C{find(idx==8)};
     hstr = fliplr(deblank(fliplr(hstr)));
     assignin('base',hstr,h);
  end
  if (any(idx == 9))
    % Hat Matrix.
     hatstr = C{find(idx==9)};
     hatstr = fliplr(deblank(fliplr(hatstr)));
     assignin('base',hatstr,Q*Q');
  end
  if (any(idx == 10))
    % Delete 1 variance. S_I
     d1vstr = C{find(idx==10)};
     d1vstr = fliplr(deblank(fliplr(d1vstr)));
     assignin('base',d1vstr,s_sqr_i);
  end
  if (any(idx == 11)) | (any(idx == 14))
    % Delete 1 coefficients. BETA_I
    stde = residuals./(1-h);
    stde = stde(:,ones(p,1));
    b_i = beta(:,ones(nobs,1)) - ri*(Q.*stde)';
     if (any(idx == 11)),
        d1bstr = C{find(idx==11)};
        d1bstr = fliplr(deblank(fliplr(d1bstr)));
        assignin('base',d1bstr,b_i);
     end
  end
  if (any(idx == 12))
    % Standardized residuals.
     r1str = C{find(idx==12)};
     r1str = fliplr(deblank(fliplr(r1str)));
     assignin('base',r1str,residuals./(sqrt(mse*(1-h))));
  end
  if (any(idx == 13))
     % Studentized residuals. 
     r2str = C{find(idx==13)};
     r2str = fliplr(deblank(fliplr(r2str)));
     assignin('base',r2str,e_i);
  end
  if (any(idx == 14)) 
   % Change in beta. DFBETAS
     b = beta(:,ones(nobs,1));
     s = sqrt(s_sqr_i(:,ones(p,1))');
     rtri = sqrt(diag(xtxi));
     rtri = rtri(:,ones(nobs,1));
     dfbeta = (b - b_i)./(s.*rtri);
     dfbstr = C{find(idx==14)};
     dfbstr = fliplr(deblank(fliplr(dfbstr)));
     assignin('base',dfbstr,dfbeta);
  end
  if (any(idx == 15))
   % Change in fitted values. DFFIT
     dffitstr = C{find(idx==15)};
     dffitstr = fliplr(deblank(fliplr(dffitstr)));
     assignin('base',dffitstr,h.*residuals./(1-h));
  end
  if (any(idx == 16))
   % Scaled change in fitted values. DFFITS
     sdffitstr = C{find(idx==16)};
     sdffitstr = fliplr(deblank(fliplr(sdffitstr)));
     assignin('base',sdffitstr,sqrt(h./(1-h)).*e_i);   
  end
  if (any(idx == 17))
   %  Change in covariance. COVRATIO
     covr = (((nobs-p-1+e_i.*e_i)./(nobs-p)).^p)./(1-h);
     covrstr = C{find(idx==17)};
     covrstr = fliplr(deblank(fliplr(covrstr)));
     assignin('base',covrstr,covr);
  end
  if (any(idx == 18))
   %  Cook's Distance.
     d = residuals.*residuals.*(h./(1-h))./p;
     cookstr = C{find(idx==18)};
     cookstr = fliplr(deblank(fliplr(cookstr)));
     assignin('base',cookstr,d);
  end

elseif strcmp(action,'help')
str{1,1} = 'Regression Diagnostics';
str{1,2} = {
'Regression Diagnostics'
' '
'The literature suggests many diagnostic statistics for evaluating' 
'multiple linear regression. The usual regression model is:'
' '
'y = Xb + e '
'where y is an n by 1 vector of responses,'
'   x is an n by p matrix of predictors,'
'	  b is an p by 1 vector of parameters,'
'	  e is an n by 1 vector of random disturbances.'
'	'  
'Let X = Q*R where Q and R come from a QR Decomposition of X.' 
'Q is orthogonal and R is triangular. Both these matrices are'
'useful for calculating many regression diagnostics.'
' '
'The least squares estimator for b is:'
'b = R\(Q''*y);'
' '	   
'To learn more about the diagnostics supplied by regstats, use the'
'Topics popup menu. A list of the Topics is below: '
'   ¥ Q from QR Decomposition.'
'   ¥ R from QR Decomposition.'
'   ¥ Regression Coefficients.'
'   ¥ Covariance of regression coefficients.'
'   ¥ Fitted values  of the response data.'
'   ¥ Residuals.'
'   ¥ Mean Squared Error.'
'   ¥ Leverage.'
'   ¥ Hat Matrix.'
'   ¥ Delete-1 Variance.'
'   ¥ Delete-1 Coefficients.'
'   ¥ Standardized Residuals.'
'   ¥ Studentized Residuals.'
'   ¥ Change in Regression Coefficients.'
'   ¥ Change in Fitted Values.'
'   ¥ Scaled Change in Fitted Values.'
'   ¥ Change in Covariance.'
'   ¥ Cook''s Distance.'
};

str{2,1} = 'QR Decomposition (Q)';
str{2,2} = {
'Q from the QR Decomposition of X.'
' '
'MATLAB code:'
'[Q,R] = qr(X,0);'
' '
'This is the so-called economy sized QR decomposition.' 
'Q is n by p. Q is also orthogonal. That is:'
'Q''*Q = I (the identity matrix)'
};

str{3,1} = 'QR Decomposition (R)';
str{3,2} = {
'R from the QR Decomposition of X.'
' '
'MATLAB code:'
'[Q,R] = qr(X,0);'
' '
'This is the economy sized QR decomposition.'
'R is p by p and triangular. This makes solving linear ' 
'systems simple.'
};

str{4,1} = 'Regression Coefficients';
str{4,2} = {
'Regression Coefficients'
' '
'MATLAB code:'
'b = R\(Q''*y);'
' '
'If you only wanted the coefficients and '
'did not want to use Q and R later, then:'
'b = X\y;'
'is the simplest code.'
};

str{5,1} = 'Coefficient Covariance';
str{5,2} = {
'Covariance of Regression Coefficients'
' '
'MATLAB code:'
'%Inverse of R'
'ri = R\eye(p);'
'%inv(X''*X)'
'xtxi = ri*ri'';'
'%Covariance of the coefficients.'
'covb = xtxi*mse;'
'  '
'MSE is mean squared error.'
' '
'covb is a p by p matrix. The diagonal elements are the variances' 
'of the individual coefficients.'
};

str{6,1} = 'Fitted Values';
str{6,2} = {
'Fitted Values of the Response Data'
' '
'The usual regression model is:'
' '
'y = Xb + e' 
'where y is an n by 1 vector of responses,'
'     x is an n by p matrix of predictors,'
'	  b is an p by 1 vector of parameters,'
'	  e is an n by 1 vector of random disturbances.'
' '	  
'Let X = Q*R where Q and R come from a QR Decomposition of X. '
'Q is orthogonal and R is triangular. Both these matrices are'
'useful for calculating many regression diagnostics.'
' '
'The least squares estimator for b is:'
'b = R\(Q''*y);'
' '
'Plugging this estimate for b into the model equation (leaving out e) we have:'
'yhat = X*b = X*(R\(Q''*y))'
'where yhat is an n by 1 vector of fitted (or predicted) values of y.'
};

str{7,1} = 'Residuals';
str{7,2} = {
'Residuals' 
' '
'Let y be an n by 1 vector of responses, and'
'yhat be an n by 1 vector of fitted (or predicted) values of y.'
' '
'Then the residuals, also n by 1 are:'
'r = y - yhat'
' '
'In English, the residuals are the observed values minus the predicted values.'
};

str{8,1} = 'Mean Squared Error';
str{8,2} = {
'Mean Squared Error'
' '
'The mean squared error is an estimator of the variance of the random' 
'disturbances, which is assumed constant.'
' '
'The formula is:'
'mse = r''*r./(n-p)'
'where r is the n by 1 vector of residuals.'
'       n is the number of observations.'
'	     p is the number of unknown parameters.'
};

str{9,1} = 'Leverage';
str{9,2} = {
'Leverage' 
' '
'The leverage is a measure of the effect of a particular observation on the '
'regression predictions due to the position of that observation in the space'
'of the inputs.'
' '
'In general, the farther a point is from the center of the input space, the' 
'more leverage it has.'
' '
'The leverage vector is an n by 1 vector of the leverages of all the observations.'
'It is the diagonal of the hat matrix.'
' '
'MATLAB code'
'h = diag(Q*Q'');'
};

str{10,1} = 'Hat Matrix';
str{10,2} = {
'Hat (Projection) Matrix'
' '
'The hat matrix is an n by n matrix that projects the vector of '
'observations, y, onto the vector of predictions, yhat, thus putting '
'the "hat" on y.'
' '
'MATLAB code.'
'H    = Q*Q'';'
'yhat = H*y;'
};

str{11,1} = 'Delete-1 Variance';
str{11,2} = {
'Delete-1 Variance'
' '
'The delete-1 variance is an n by 1 vector. Each element of the vector is the' 
'mean squared error of the regression obtained by deleting that observation.'
};

str{12,1} = 'Delete-1 Coefficients';
str{12,2} = {
'Delete-1 Coefficients'
' '
'The delete-1 coefficents a an p by n matrix. Each column of the matrix is the '
'coefficients of the regression obtained by deleting corresponding observation.'
};

str{13,1} = 'Standardized Residuals';
str{13,2} = {
'Standardized Residuals'
' '
'The standardized residuals are the residuals normalized by a measure of their' 
'standard deviation.'
' '
'MATLAB code:'
'stanres = residuals./(sqrt(mse*(1-h)));'
'where mse is the mean squared error.'
'         and h is the leverage vector.'  
' '
'See also: Studentized Residuals .'
};

str{14,1} = 'Studentized Residuals';
str{14,2} = {
'Studentized Residuals' 
' '
'The studentized residuals are the residuals normalized by a measure of their '
'standard deviation.'
' '
'MATLAB code:'
'studres = residuals./(sqrt(s2i*(1-h)));'
'where s2i is the delete-1 variance.'
'         and h is the leverage vector.'  
' '
'See also: Standardized Residuals.'
};

str{15,1} = 'Change in Coefficients';
str{15,2} = {
'Change in Regression Coefficients (DFBETA)'
' '
'DFBETA is an p by n matrix. Each column of DFBETA is the scaled effect of '
'removing the corresponding point on the vector of coefficients.'
};

str{16,1} = 'Change in Prediction';
str{16,2} = {
'Change in Fitted Values (DFFIT)'
' '
'DFFIT is an n by 1 vector. Each element is the change in the fitted value'
'caused by deleting the corresponding observation.'
' '
'MATLAB code:'
'dffit = h.*residuals./(1-h)'
'where h is the leverage vector.' 
};

str{17,1} = 'Scaled Change in yhat';
str{17,2} = {
'Scaled Change in Fitted Values (DFFITS)'
'Scaled DFFIT is an n by 1 vector. Each element is the change in the fitted value '
'caused by deleting the corresponding observation and scaled by the standard error.'
' '
'MATLAB code:'
'sdffit = sqrt(h./(1-h)).*e_i)'
'where e_i is the vector of studentized residuals.'
'           and h is the leverage vector.'
};

str{18,1} = 'Change in Covariance';
str{18,2} = {
'Change in Covariance'
' '
'DFCOV is an n by 1 vector. Each element is the ratio of the generalized '
'variance of the estimated coefficients when the corresponding element is '
'deleted to the generalized variance of the coefficients using all the data.'
};

str{19,1} = 'Cook''s Distance';
str{19,2} = {
'Cook''s Distance'
' '
'Cook''s distance is an n by 1 vector. Each element is the normalized change '
'in the vector of coefficients due to the deletion of an observation.'
' '
'MATLAB code:'
'd = residuals.*residuals.*(h./(1-h))./p; ' 
'where d is Cook''s distance.'
'           h is the leverage vector.'
'           and p is the number of unknown parameters.'
};

   for k = 1:19
      str{k,2} = char(str{k,2});
   end
   helpwin(str,'Regression Diagnostics','Regression Diagnostics Help')

end
