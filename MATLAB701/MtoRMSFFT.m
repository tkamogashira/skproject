% MtoRMSFFT
function RMSFFT=MtoRMSFFT(M)
for n=1:204
   if M(6,n)<0.01 % RMS p<0.01
       if M(5,n)>0 % BBRMS>NoBBRMS
           if M(2,n)>0 % Side
              plot(M(3,n),M(4,n),'go'),hold on
          else % Mid 
              plot(M(3,n),M(4,n),'g.'),hold on
          end
      else % BBRMS=<NoBBRMS
          if M(2,n)>0 % Side
              plot(M(3,n),M(4,n),'bo'),hold on
          else % Mid
              plot(M(3,n),M(4,n),'b.'),hold on
          end
      end
  else % RMS N.S.
      if M(2,n)>0 % Side
              plot(M(3,n),M(4,n),'ko'),hold on
      else % Mid
              plot(M(3,n),M(4,n),'k.'),hold on
      end
  end
  for l=1:204
      if M(8,l)<0.05 % FFT
          if M(7,l)>0 % BB>NoBB
              plot(M(3,l),M(4,l),'r*'),hold on
          end
      end
  end
end

  