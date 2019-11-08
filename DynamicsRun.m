% Reactor Dynamics execution script

% timespan [s]
t= 0:.01:5 ; 

% R0 (reactivity insertion) [unitless]
R0 = 220E-5;

% Reactivity feedbacks
af=  -5E-5; % -1 pcm/K (just picked a number)

% prompt neutron generation time [s]
% LWR 
%l= 2E-5;
% Fast Reactor
l = 4E-7;

% Delayed neutron fraction
%LWR
%BetaEff = 0.006;
% Fast Reactor
BetaEff = 0.0035;

% Decay Constant (effective/average) [1/s]
Lambda = 0.08; 


% Steady state fuel temp [K]
Tss = 700;

% Steady state hear removal capacity and initial power
Pcool = 1E6; % 1 MegaWatt thermal heat removal

Q = 200E6*1.6E-19;          %Energy release per fission
k0 = 1+ R0 ;    % k-effective
nubar = 2.55;               % nubar, neutrons per fission
p = k0 / nubar;              % Probability of neutron to induce new fission 


% equillibrium initial conditions
Ni = [Lambda*l/BetaEff , 1] ;
Ni = Ni * Pcool / ( (Ni(1)/l + Lambda*Ni(2) ) * Q*p)  ;
Ni = [Ni, Tss];


CoreFuelMass = 10E3; % 10 ton core?
FuelDensity = 10.5E3;  %  UOX [kg/m3]
cp = 300 ; % Specific heat capacity
Cf = CoreFuelMass * cp; 


% ODE function, y' = f(t,y)  (y(1) is the prompt neutron population
% and y(2) is the delayed neutron population.)
testfunc = @(T,y) PointDynamicReactor(T,y, R0 ,l,BetaEff, Lambda, af, Cf, Tss, Pcool, nubar) ; 
[t,N] = ode15s(testfunc, t, Ni );

%Normalized Power - Assumed proportional to neutron population
P = (N(:,1)/l + Lambda*N(:,2)) * Q * p;

figure
subplot(2,1,1)
plot(t, P/1E6)
xlabel('Time [s]')
ylabel('P_{th} [MW]')
subplot(2,1,2)
plot(t, N(:,3))
xlabel('Time [s]')
ylabel('T [K]')