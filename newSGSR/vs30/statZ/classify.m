function class = classify(sample,training,group)
%CLASSIFY Linear discriminant analysis.
%   CLASS = CLASSIFY(SAMPLE,TRAINING,GROUP) classifies each row
%   of the data in SAMPLE into one of the values of the vector
%   GROUP. GROUP contains integers from one to the number of 
%   groups in the training set, which is the matrix, TRAINING.
%
%   SAMPLE and TRAINING must have the same number of columns.
%   TRAINING and GROUP must have the same number of rows.
%   CLASS is a vector with the same number of rows as SAMPLE.

%   B.A. Jones 2-05-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1998/05/29 21:27:34 $


[gr,gc] = size(group);
if min(gr,gc) ~= 1
   error('Requires the third argument to be a vector.');
end

if gc ~= 1,
   group = group(:);
   gr = gc;
end

if any(group - round(group)) | any(group < 1)
  error('The third input argument must be positive integers.');
end
maxg = max(group);

[tr,tc] = size(training);
if tr ~= gr,
  error('The number of rows in the second and third input arguments must match.');
end

[sr,sc] = size(sample);
if sc ~= tc
  error('The number of columns in the first and second input arguments must match.');
end

d = zeros(sr,maxg);
for k = 1:maxg
   groupk = training(find(group == k),:);
   d(:,k) = mahal(sample,groupk);
end
[tmp, class] = min(d');
class = class';
