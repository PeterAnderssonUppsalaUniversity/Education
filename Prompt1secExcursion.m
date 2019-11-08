% Promt neutrons only, 1 second 10 pcm reactivity excursion - not true due
% to neglecting delayed neutrons, only meant to be informative example

k= 1+10E-5


% prompt neutron generation time [s]
% LWR 
l= 2E-5;

% Fast Reactor
%l = 4E-7;


% timespan [s]
t= 0:0.001:1 ; 

% ODE function, y' = f(t,y)  (y is the neutron population.)
testfunc = @(T,Pow) PointKineticPrompt(T,Pow, k,l) ; 
[t,N] = ode45(testfunc, t, 1 )

%Normalized Power - Assumed proportional to neutron population
P = N;

figure
plot(t, P)
xlabel('Time [s]')
ylabel('P_{th} / P_{th,0}')