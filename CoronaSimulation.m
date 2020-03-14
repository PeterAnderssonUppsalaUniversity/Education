% -------- Set disease initial conditions -------------

% population initial parameters
Ni(1) = 200000 ;  % healthy individuals
Ni(2) = 50 ;        % infected and in incubation time
Ni(3) = 0;        % Sick individuals
Ni(4) = 0;          % immune people
Ni(5) = 0;          % Deceased 


%---------- Time frame of simulation(in days) -----------
t = 0:50;


% --------- Parameters of transfer ----------------------
% Meeting frequency - number of people one meets per day (for latent sick)
MeetFreq = 20; 

% Meeting frequency for sick people - number of people sick person meets per day
MeetFreqSick = 1; 

% Probability of transfer from sick to healthy per meeting
SickCoeff = 0.2

% Probability of transfer from latent sick to healthy per meeting
LatCoeff = 0.02;

% Time in days for half of infected to get sick:
T1 = 4; 

% Time in days for half of sick to get well (or die):
T2 = 14; 

% Rate of death per infected
FatalityRate = 0.02 

% ----------- Defining and solving ODE -----------------------

% Ordinary Differential Equation function, y' = f(t,y) 
testfunc = @(T,N) CoronaSpread(T,N, T1, T2, MeetFreq, MeetFreqSick, LatCoeff, SickCoeff, FatalityRate) ; 
[t,N] = ode45(testfunc, t, Ni );


% --------  Plotting ----------------------
figure()
plot(t, N)
xlabel('Time [days]')
ylabel('Number of people')
legend({'Healthy', 'Latent', 'Sick', 'Immune', 'Deceased'})


% ----------------   ODE function --------------

function dN = CoronaSpread(t,N, latencyperiod, sickperiod, freq, freqsick, transmissionprob1, transmissionprob2, deathprob)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dN(1,1) = - N(2) * freq * N(1)/sum(N) * transmissionprob1  -N(3) * freqsick * N(1)/sum(N) * transmissionprob2;
dN(2,1) = -dN(1) - log(2)/latencyperiod * N(2) ;  
dN(3,1) = log(2)/latencyperiod * N(2)  - log(2)/sickperiod * N(3);
dN(4,1) = log(2)/sickperiod * N(3) * (1-deathprob);
dN(5,1) = log(2)/sickperiod * N(3) * deathprob;

end
