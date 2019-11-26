% 1 second time span, 10 pcm reactivity excursion, including delayed N

% k effective [unitless]
k=  1+10E-5


% prompt neutron generation time [s]
% LWR 
l= 2E-5;

% Fast Reactor
%l = 4E-7;

% Delayed neutron fraction
%LWR
BetaEff = 0.006;

% Fast Reactor
%BetaEff = 0.0035;

% Decay Constant (effective) [1/s]
Lambda = 0.08; 

% timespan [s]
t= 0:0.0001:1 ; 

% equillibrium initial conditions
Ni = [Lambda*l/BetaEff , 1] ;
Ni = Ni/sum(Ni);

% ODE function, y' = f(t,y)  (y(1) is the prompt neutron population
% and y(2) is the delayed neutron population.)
testfunc = @(T,y) PointKineticDelayed(T,y, k,l,BetaEff, Lambda) ; 
[t,N] = ode15s(testfunc, t, Ni );

%Normalized Power - Assumed proportional to neutron population
P = N(:,1)/l + Lambda*N(:,2);

figure
plot(t, P/P(1))
xlabel('Time [s]')
ylabel('P_{th} / P_{th,0}')