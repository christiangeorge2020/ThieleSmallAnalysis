%% General Parameters
c = 343;            % speed of sound, m/s
po = 1.2;           % density of air
pref = 2e-5;        % pressure reference of air, Pa

%% Enter known Thiele Small Parameters

% Names of thiele small parameters
names = {'Fs','Qms','Qes','Qts','Cms','Mms','Rms','Le','Re','Vas','Bl','Sd','Mmd','radius'};
numparams = size(names,2);
values = dialogValues(names, 0.0, 0, 'Thiele Small Parameters');

% Store values into a map for easy reference
ts = containers.Map(names, values);


%% Convert to symbolic variables
Fs = sym(ts('Fs'));
Qms = sym(ts('Qms'));
Qes = sym(ts('Qes'));
Qts = sym(ts('Qts'));
Cms = sym(ts('Cms'));
Mms = sym(ts('Mms'));
Rms = sym(ts('Rms'));
Le = sym(ts('Le'));
Re = sym(ts('Re'));
Vas = sym(ts('Vas'));
Bl = sym(ts('Bl'));
Sd = sym(ts('Sd'));
Mmd = sym(ts('Mmd'));
a = sym(ts('radius'));


%% Reset what the user didn't enter (0.0)
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
                sysm Mmd;
            case 14
                syms a;
        end
    end
end

syms Mas Mad Cas Rae Rat Ras alpha Vab


%% Equations
eqns = [Fs == 1 / (2*pi*sqrt(Mms * Cms)) 
        Qms == sqrt(Mms / Cms) / Rms
        Qes == sqrt(Mas / Cas) / Rae
        Qts == (Qms * Qes) / (Qms + Qes)
        Qts == sqrt(Mas / Cas) / Rat
        Rat == Rae + Ras
        Rat == (Bl^2 / Sd^2 / Re) + (Rms / Sd^2)
        Vas == po * c^2 * Sd^2 * Cms
        Rae == (Bl^2) / (Re * Sd^2)
        Ras == Rms / Sd^2
        Mms == Mas * Sd^2
        alpha == Vas / Vab
        Cas == Sd^2 * Cms
        Mad == Mmd / Sd^2
        Mms == Mmd + 16 * po * a^3 / 3
        Sd == pi * a^2];

%% Solve for unknowns
unknowns = solve(eqns);

%% Store in symbolic variables
for i = 1:numparams
    if values{i} <= 0
        switch i
            case 1
                Fs = unknowns.Fs;
            case 2
                Qms = unknowns.Qms;
            case 3
                Qes = unknowns.Qes;
            case 4
                Qts = unknowns.Qts;
            case 5
                Cms= unknowns.Cms;
            case 6
                Mms= unknowns.Mms;
            case 7
                Rms = unknowns.Rms;
            case 8
                Le = unknowns.Le;
            case 9
                Re = unknowns.Re;
            case 10
                Vas = unknowns.Vas;
            case 11
                Bl = unknowns.Bl;
            case 12
                Sd = unknowns.Sd;
            case 13
                Mmd = unknowns.Mmd;
            case 14
                a = unknowns.a;
        end
    end
end

%% Plot