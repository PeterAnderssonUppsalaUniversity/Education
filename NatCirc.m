

%rod diameter
D = 0.9E-2 ; %[m]

% PoverD is the ratio of Pitch to Diameter
%PoverD = 1.6; % lead
PoverD = 1.2; % sodium

%Pitch
P = D * PoverD ; % [m]

% Flow area
A = sqrt(3)/4 * P^2 + 3/6*pi*(D/2)^2

% Friction factor koefficient
 %K = 450E3*2/10.5E3/2.5^2  % lead
K = 750E3*2/0.85E3/8^2 % sodium

%Linear heat rate
% Full power
%Plin = 30E3 ; % [W/m] 
% Decay heat (initial)
Plin = 30E3 * 0.06 ; % [W/m] 

%Height of core
Hc = 1;  % [m]

%Height of  fluid column
H = 5 ; % [m]

% Inlet temperature of coolant 
Tin = 673 ; % [K]


% Temp difference over core, function of velocity
dT = @(v) Hc*Plin/(A * v * 10.5E3*0.15E3)

%density differnce beteen hot and cold leg, function of velocity
%Drho = @(dT) 120/100*dT %87E-6*dT*10500 % lead
Drho = @(dT) 24/100*dT %87E-6*dT*10500  % sodium

% bouyancy pressure, function of velocity
Pbouy = @(v) 9.82 * H * Drho( dT( v) )

% pressure drop, function of velocity
Pcore  = @(v) K*.5*10.5E3 * v^2

% Pressure difference (will accelerate or decelerate flow)
% Expression is equal to zero for equillibrium flow velocity
expr = @(v) Pcore(v) - Pbouy(v) 

% Solving for equality between pressures (bouyancy and core pressure drop). 
% getting equillibrium flow speed
V_sol = fsolve(expr, 1)

% Getting corresponding deltaT over core
dT_sol = dT(V_sol)

% Outlet temperature
Tout = Tin + dT_sol %[K]

% Core Pressure drop
Pcore_sol = Pcore(V_sol) %[Pa]