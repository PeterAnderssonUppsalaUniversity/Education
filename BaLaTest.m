
% Irradiation time in days
BurnTime = 200;

% Cooling time after end of operation
DecayTime = 0;

%time in hours, before (neg) and after (pos) reactor stoppage
t =  [ -24*BurnTime :1: DecayTime];

 %Power  W per kg
PowLev = 0.6E4; % 0.3E4;  
Power  = PowLev* [ ones(length(find(t<0)),1) ; zeros(length(find(t>=0)),1)]; % PowLev * [ones(9000,1) ;zeros(1000,1)] ; %power history

%preallocationg barium and lantanum and cesium concentrations and burnup

zr =  zeros(length(t),1);
ba =  zeros(length(t),1);
la =  zeros(length(t),1);
cs =  zeros(length(t),1) ;

BU =  zeros(length(t),1);

% fission yields
FY_Zr = 0.065018 ;
FY_Ba = 0.063142;
FY_La = 0.063147;
FY_Cs = 0.062208 ;

% decay constants
lambdaZr = log(2) / (64.032*24) % /h
lambdaBa = log(2) / (12.7527 * 24) % /h
lambdaLa = log(2) / (1.67855 * 24) % /h
lambdaCs = log(2) / (30.08*365*24) % /h

%running irradiation and decay
for i = 2:length(t)
    
   BU(i) = BU(i-1) + Power(i) * 1 / 1E6 ; % MWd/kg
    
   % fission rate % fissions per kg and hour
   FR = 3600 * Power(i) / ( 200E6 * 1.6E-19) ; 
   
   % Production of Ba and La
   P_Zr = FR * FY_Zr;
   P_Ba = FR * FY_Ba;
   P_La = FR * FY_La;
   P_Cs =  FR * FY_Cs;
   
   % Decay losses
   D_Zr = zr(i-1) * lambdaZr;
   D_Ba = ba(i-1) * lambdaBa;
   D_La = la(i-1) * lambdaLa;
   D_Cs = cs(i-1) * lambdaCs;
   
   % Total change
   zr(i) = zr(i-1) + P_Zr - D_Zr;
   ba(i) = ba(i-1) + P_Ba - D_Ba;
   la(i) = la(i-1) + P_La - D_La + D_Ba;
   cs(i) = cs(i-1) + P_Cs - D_Cs;
end



figure()
plot(t, ba, 'b')
hold on 
plot(t, zr, 'c')
plot( t, la, 'r')
plot( t, cs, 'k') 
xlabel('Time after end of operation[h]')
ylabel('Concentration [atoms/kg]')
    

legend({'Ba-140', 'Zr-95', 'La-140', 'Cs-137'})


figure()
plot(t, ba*lambdaBa/(24*3600) , 'b')
hold on 
plot(t, zr*lambdaZr/(24*3600), 'c')
plot( t, la*lambdaLa/(24*3600), 'r')
plot( t, cs*lambdaCs/(24*3600), 'k') 
xlabel('Time after end of operation [h]')
ylabel('Activity [Bq/kg]')
%set(gca,'YScale', 'log')

    

legend({'Ba-140', 'Zr-95', 'La-140', 'Cs-137'})