function XLbanana(XL,YL);
% XLbanana(XL) - set xlimits of bananaplot
f2; 
subplot(2,1,1);
xlim(XL);
if nargin>1,
   ylim(YL);
end
subplot(2,1,2);
xlim(XL);
