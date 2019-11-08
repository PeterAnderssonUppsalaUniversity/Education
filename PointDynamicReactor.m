function dN = PointDynamicReactor(t, N, R0, l, B,Lambda, af, Cf, Tss, Pcool, nubar)
% dN and N are arrays 
% N(1) is the prompt neutron population
% N(2) is the precursor population (all of them)
% N(3) is the Fuel temperature

% t = current time (single element) [s]
% R0 = inserted reactivity (e.g. according to plan) (unitless)
% af = Fuel temperature coefficient dR/dT
% Cf = Heat capacity of fuel in core J/K
% Tss = Steady State Temperature
% Pcool = Constant cooling power
% nubar = neutrons per fission

Q = 200E6*1.6E-19;          %Energy release per fission
k = 1+ R0+ af*(N(3) - Tss); % k-effective
p = k / nubar;              % Probability of neutron to induce new fission 


dN = zeros(3,1);

dN(1) =  (k-1-B)*N(1)/l  + N(2)*Lambda;     % neutrons 
dN(2) =  k*B*N(1)/ l  - Lambda*N(2) ;       % precursors
dN(3) =  ((N(1)/l + N(2)*Lambda)*Q*p - Pcool) / Cf   ;     % Fuel temp change
  