% This matlab script creates a file that contain a mat card for serpent
% with NaCl Fuel salt, containing pu from PWR spent fuel, mixed with
% natural uranitum and NaCl

% file name for output
filename= 'textout.txt'

% using following plutonium vector for PWR spent fuel 
% Source: https://www.world-nuclear.org/information-library/nuclear-fuel-cycle/fuel-recycling/plutonium.aspx
pu239 = 0.504; 
pu240 = 0.241;
pu241 =  0.152;
pu242 =  0.071;
pu238 = 0.027;

% Creating vector of pu content only
pu = [pu238;pu239;pu240;pu241;pu242];
% normalizing
pu = pu/sum(pu);

% Determining fraction of Pu / (U + Pu)  
% Regards atomic fractions
Pu_frac = 0; % 0.2;

% Uranium enrichment - using natural urantium - atomic enrichment
Uenrichment = 0.2; % 0.0072;

% uranium isototopes
u235 = Uenrichment;
u238 = 1-Uenrichment;
u= [u235;u238];
 
% Creating vector of U + Pu
Mix = [(1-Pu_frac)* u; pu*Pu_frac] ;

% Atomic ratio of NaCl dilutant Salt to Fuel, (NaCl) : (U+Pu)
SaltFuelRatio = 3.5;
% Half of salt each for Na and Cl, however, Cl contribution from fuel UCl3
% and PuCl3
Na = SaltFuelRatio;
Cl = SaltFuelRatio + 3;

% Creating total fuel salt mixture
FuelSalt = [Na;Cl;Mix];
% normalizing contents to 1
FuelSalt = FuelSalt/sum(FuelSalt)

% Printing
nuclides = {'11023.09c' , '17035.09c' ,'92235.09c ', '92238.09c ', '94238.09c ',  '94239.09c ', '94240.09c ', '94241.09c ',  '94242.09c ' };
fir = fopen(filename, 'w')
formatSpec = '%s %8.4f\n'
for i = 1:length(FuelSalt);
    fprintf(fir, formatSpec, nuclides{i}, FuelSalt(i))
end

% close file pointer
fclose(fir)



