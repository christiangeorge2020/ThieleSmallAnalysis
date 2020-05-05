%% General Parameters
c = 343;            % speed of sound, m/s
po = 1.2;           % density of air        
pref = 2e-5;        % pressure reference of air, Pa

%% Enter known Thiele Small Parameters

% Names of thiele small parameters
names = {'Fs','Qms','Qes','Qts','Cms','Mms','Rms','Le','Re','Vas','Bl','Sd','Mmd','Radius', 'xmax', 'Vd'};
numparams = size(names,2);
values = dialogValues(names, 0.0, 0, 'Thiele Small Parameters');

% Store values into a map for easy reference
ts = containers.Map(names, values);


%% Convert to symbolic variables
 Fs = sym(ts('Fs')); 
 Qms = sym(ts('Qms'));       % Mechanical Q
 Qes = sym(ts('Qes'));       % Electrical Q
 Qts = sym(ts('Qts'));       % Overall Q
 Cms = sym(ts('Cms'));       % Compliance of the Suspension
 Mms = sym(ts('Mms'));       % Mass of the Suspension
 Rms = sym(ts('Rms'));       % Resistance of the Suspension
 Le = sym(ts('Le'));         % Voice Coil Inductance
 Re = sym(ts('Re'));         % DC Voice Coil Resistance
 Vas = sym(ts('Vas'));
 Bl = sym(ts('Bl'));         % Motor Strength
 Sd = sym(ts('Sd'));         % Surface Area of the Driver
 Mmd = sym(ts('Mmd'));
 a = sym(ts('Radius'));           % Driver Radius
 xmax = sym(ts('xmax'));            % Maximum Displacement
 Vd = sym(ts('Vd'));                % Driver Displacement Volume
 
 
 
%% Calculations
finished = false;
index = 0;

while finished == false && index <= 10
    finished = true;
    for i = 1:numparams
        if values{i} <= 0
            switch i
                case 1
                    syms Fs
                case 2
                    syms Qms;
                case 3
                    syms Qes;
                case 4
                    syms Qts;
                case 5
                    syms Cms;
                case 6
                    syms Mms;
                case 7
                    syms Rms;
                case 8
                    syms Le;
                case 9
                    syms Re;
                case 10
                    syms Vas;
                case 11
                    syms Bl;
                case 12
                    syms Sd;
                case 13
                    syms Mmd;
                case 14
                    syms a;
                case 15
                    syms xmax;
                case 16
                    syms Vd;
            end
        end
    end
    syms Rat;
    eqns = [Fs == 1 / (2*pi*sqrt(Mms * Cms))                %1
            Qms == sqrt(Mms / Cms) / Rms                    %2
            Qes == sqrt((Mms) / (Cms)) * (Re / Bl^2)        %3
            Qts == (Qms * Qes) / (Qms + Qes)                %4
            Rat ==  (Bl^2 / Sd^2 / Re) + (Rms / Sd^2)       %5
            Vas == po * c^2 * Sd^2 * Cms                    %6
            Mms == Mmd + 2 * po * a^3 / 3                   %7
            Sd == pi * a^2                                  %8
            Vd == Sd * xmax];                               %9
    

    for i = 1:numparams
        if values{i} <= 0
            syms s
            switch i
                case 1
                    syms Fs;
                    s = solve(eqns(1), Fs);
                    values{i} = numericSymbol(s, Fs);
                    Fs = values{i};

                case 2
                    syms Qms;
                    s = solve(eqns(2), Qms);
                    values{i} = numericSymbol(s,Qms);
                    if  (values{i} == 0)
                        s = solve(eqns(4), Qms);
                        values{i} = numericSymbol(s,Qms);
                    end
                    Qms = values{i};

                case 3
                    syms Qes;
                    s = solve(eqns(3), Qes);
                    values{i} = numericSymbol(s,Qes);
                    if  (values{i} == 0)
                        s = solve(eqns(4), Qes);
                        values{i} = numericSymbol(s,Qes);
                    end
                    Qes = values{i};

                case 4
                    syms Qts;
                    s = solve(eqns(4), Qts);
                    values{i} = numericSymbol(s,Qts);
                    Qts = values{i};

                case 5
                    syms Cms;
                    s = solve(eqns(1), Cms);
                    values{i} = numericSymbol(s,Cms);
                    if  (values{i} == 0)
                        s = solve(eqns(2), Cms);
                        values{i} = numericSymbol(s,Cms);
                    end
                    if  (values{i} == 0)
                        s = solve(eqns(3), Cms);
                        values{i} = numericSymbol(s,Cms);
                    end
                    if  (values{i} == 0)
                        s = solve(eqns(6), Cms);
                        values{i} = numericSymbol(s,Cms);
                    end
                    Cms = values{i};

                case 6
                    syms Mms;
                    s = solve(eqns(1), Mms);
                    values{i} = numericSymbol(s,Mms);
                    if  (values{i} == 0)
                        s = solve(eqns(2), Mms);
                        values{i} = numericSymbol(s,Mms);
                    end
                    if  (values{i} == 0)
                        s = solve(eqns(3), Mms);
                        values{i} = numericSymbol(s,Mms);
                    end
                    if  (values{i} == 0)
                        s = solve(eqns(7), Mms);
                        values{i} = numericSymbol(s,Mms);
                    end
                    Mms = values{i};

                case 7
                    syms Rms;
                    s = solve(eqns(2), Rms);
                    values{i} = numericSymbol(s,Rms);
                    if  (values{i} == 0)
                        s = solve(eqns(5), Rms);
                        values{i} = numericSymbol(s,Rms);
                    end
                    Rms = values{i};

                case 8
                    syms Le;
                    fprintf('Le Needed!');

                case 9
                    syms Re;
                    s = solve(eqns(3), Re);
                    values{i} = numericSymbol(s,Re);
                    if  (values{i} == 0)
                        s = solve(eqns(5), Re);
                        values{i} = numericSymbol(s,Re);
                    end
                    Re = values{i};

                case 10
                    syms Vas;
                    s = solve(eqns(6), Vas);
                    values{i} = numericSymbol(s, Vas);
                    Vas = values{i};

                case 11
                    syms Bl;
                    s = solve(eqns(3), Bl);
                    values{i} = numericSymbol(s, Bl);
                    Bl = values{i};

                case 12
                    syms Sd;
                    s = solve(eqns(6), Sd);
                    values{i} = numericSymbol(s, Sd);
                    if  (values{i} == 0)
                        s = solve(eqns(8), Sd);
                        values{i} = numericSymbol(s,Sd);
                    end
                    Sd = values{i};

                case 13
                    syms Mmd
                    s = solve(eqns(7), Mmd);
                    values{i} = numericSymbol(s,Mmd);
                    Mmd = values{i};

                case 14
                    syms a;
                    s = solve(eqns(7), a);
                    values{i} = numericSymbol(s,a);
                    if  (values{i} == 0)
                        s = solve(eqns(8), a);
                        s = numericSymbol(s,a);
                        values{i} = s(2);
                    end
                    a = values{i};
                    
                case 15
                    syms xmax;
                    s = solve(eqns(9), xmax);
                    values{i} = numericSymbol(s,xmax);
                    xmax = values{i};
                    
                case 16
                    syms Vd
                    s = solve(eqns(9), Vd);
                    values{i} = numericSymbol(s,Vd);
                    Vd = values{i};
            end
            
            % Signal to exit the while loop; all parameters calculated
            if values{i} <= 0
                finished = false;
            end
            
        end
    end
    
    % Index to break for loop if not enough variables were given
    index = index + 1;
end

if index >= 4
    fprintf('Not enough variables given');
    values = dialogValues(names, 0.0, values, 'Thiele Small Parameters');
end


%% Calculate
%   First mode of driver breakup
syms fu1 
Fu1 = Mms * Re / (Mmd * Le * 2 * pi);

%   Second mode of driver breakup
Fu2 = sqrt(2) * c / 2 / pi / a;

%   High Frequency LPF
syms s
wu = 2 * pi * Fu1;
Tu = 1 / (1 + s/wu);        

%   2nd order HPF
syms ws eg
ws = 2*pi*Fs;
Gs = (s/ws)^2 / ( (s/ws)^2 + (s/ws/Qts) + 1 );      

%   On Axis Frequency Response
syms Mas
Mas = Mms / Sd^2;
p = (po * Bl * eg / ( 2*pi*Sd*Re*Mas ) ) * Gs * Tu;

%   Peak Frequency
Fpeak = Fs * Qts / sqrt(Qts^2 - 0.5);

%   Actual Cutoff
Fl = Fs * sqrt( ((1/2/Qts^2)-1) + sqrt((1/2/Qts^2)^2 + 1) );

%   Pressure Sensitivity
psens = sqrt(2*pi*po) * Fs^(3/2) * sqrt( Vas / Re / Qes ) / c;
psensDB = 20*log10(psens/pref);

%   Reference Efficiency
no = 4*pi^2 * Fs^3 * Vas / ( c^3 * Qes );

%   Displacement Limited Electrical Input Power
Pe = 0.5 * po * c^2 * ws * Qes * Vd^2 * ( Qts^2 - 0.25 ) / ( Vas * Qts^4 );