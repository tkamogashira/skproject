
GAUSS_RANGE_TIME = 50;
GAUSS_FUNCTION_SIGMA_TIME = 10;

for int_t=1: GAUSS_RANGE_TIME*2+1
    gauss_function(int_t) = 0;
end
w_gauss_area = 0;
for int_t=-GAUSS_RANGE_TIME: 1: GAUSS_RANGE_TIME
    gauss_function_time(GAUSS_RANGE_TIME+1+int_t) = int_t;
    gauss_function(GAUSS_RANGE_TIME+1+int_t) = 1.0/sqrt(2.0*pi)/GAUSS_FUNCTION_SIGMA_TIME*exp(-int_t*int_t/2.0/GAUSS_FUNCTION_SIGMA_TIME/GAUSS_FUNCTION_SIGMA_TIME);
    w_gauss_area = w_gauss_area + gauss_function(GAUSS_RANGE_TIME+1+int_t);
end
for int_t=-GAUSS_RANGE_TIME: 1: GAUSS_RANGE_TIME
    gauss_function(GAUSS_RANGE_TIME+1+int_t)  =  gauss_function(GAUSS_RANGE_TIME+1+int_t) /w_gauss_area;
end
plot(gauss_function_time, gauss_function);


w_sum = 0;
for int_t=-GAUSS_RANGE_TIME: 1: GAUSS_RANGE_TIME
    w_sum = w_sum + gauss_function(GAUSS_RANGE_TIME+1+int_t);
end
disp(w_sum);

