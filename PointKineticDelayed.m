function dN = PointKineticDelayed(t, N, k, l, B,Lambda)
% dN and N are arrays of two element whete 1) is the promt neutrons and 2)
% is the precursor concentration

dN(1,1) = (k-1-B)*N(1) / l  + N(2)*Lambda;
dN(2,1) = k*B*N(1)/ l  - Lambda*N(2) ;



