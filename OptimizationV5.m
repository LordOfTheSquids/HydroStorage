%% Header

%% Clear workspace and command window
clear, clc

%% Accept file names from user
%{
pipeFile = input('Input pipe catalog file name: ', 's');
pipeData = load(pipeFile);
bendFile = input('Input bend catalog file name: ', 's');
bendData = load(bendFile);
%}
pipeData = load('Pipes.txt');
bendData = load('BendsAndFittings.txt');
pumpData = load('Pumps.txt');
turbineData = load('Turbines.txt');

%% Analyze size of data files
[rowsPipes, columnsPipes] = size(pipeData);
[rowsBends, columnsBends] = size(bendData);
[rowsPumps, columnsPumps] = size(pumpData);
[rowsTurbines, columnsTurbines] = size(turbineData);

%% Open file for writing data
dataFile = fopen('PipeData.txt', 'w');
fprintf(dataFile, 'Pipe and Bends\n');
fprintf(dataFile, ['  Cost ($)  Systems  Length (m)  Friction  Diam. (m)',...
        '  Bend 1  Bend 2  Bend 3  Bend 4  Depth (m) Pump Head  Eff  Turbine Head Eff. Energy In (MWh)\n']);

%% User input of pipe parameters
unitLength = input('Enter pipe length of individual system (m): ');
numBends = input('Enter number of bends in system: ');
if (numBends > 0)
    bendAngleOne = input('Enter first bend angle (degrees): ');
end
if (numBends > 1)
    bendAngleTwo = input('Enter second bend angle (degrees): ');
end
if (numBends > 2)
    bendAngleThree = input('Enter third bend angle (degrees): ');
end
if (numBends > 3)
    bendAngleFour = input('Enter fourth bend angle (degrees): ');
end
resElv = input('Enter resevoir elevation (m): ');

%rate = input('Enter flow rate in m^3/s: ');
%numSystems = input('Input number of pump/turbine/pipe systems: ');

%% Find appropriate bend angles
if (numBends > 0)
    n = 1;
    while(abs(bendAngleOne - bendData(1, n)) > 0.0005)
        n = n + 1;
    end
    bendColOne = n;
    bendCoeffOne = bendData(2, n);
else
    bendColOne = 0;
    bendCoeffOne = 0;
end
if (numBends > 1)
    n = 1;
    while(abs(bendAngleTwo - bendData(1, n)) > 0.0005)
        n = n + 1;
    end
    bendColTwo = n;
    bendCoeffTwo = bendData(2, n);
else
    bendColTwo = 0;
    bendCoeffTwo = 0;
end
if (numBends > 2)
    n = 1;
    while(abs(bendAngleThree - bendData(1, n)) > 0.0005)
        n = n + 1;
    end
    bendColThree = n;
    bendCoeffThree = bendData(2, n);
else
    bendColThree = 0;
    bendCoeffThree = 0;
end
if (numBends > 3)
    n = 1;
    while(abs(bendAngleFour - bendData(1, n)) > 0.0005)
        n = n + 1;
    end
    bendColFour = n;
    bendCoeffFour = bendData(2, n);
else
    bendColFour = 0;
    bendCoeffFour = 0;
end

%% Eliminate unuseable pumps/turbines
row = 1;
while (pumpData(row, columnsPumps) < resElv)
    row = row + 1;
end
pumpStart = row;
row = 1;
while (turbineData(row, columnsTurbines) < resElv)
    row = row + 1;
end
turbineStart = row;

%% Analysis
zoneData = zeros(700000, 17);
n = 1;
optimizationFactor = -999;
for numSystems = 1:5:20
for col = 1:(columnsPipes - 1)
    for row = 2:rowsPipes
        for pumpCol = 1:(columnsPumps - 1)
        for pumpRow = pumpStart:rowsPumps
        for turbCol = 1:(columnsTurbines - 1)
        for turbRow = turbineStart:rowsTurbines
        for depth = 1:5:20
        for pumpFlow = 1:50:500
        for turbineFlow = 1:50:500
        length = unitLength * numSystems;
        friction = pipeData(1, col);
        diameter = pipeData(row, columnsPipes);
        unitCostPipe = pipeData(row, col);
        costPipe = unitCostPipe * length;
        if (numBends > 0)
            unitCostBendOne = bendData(row + 1, bendColOne);
        else
            unitCostBendOne = 0;
        end
        if (numBends > 1)
            unitCostBendTwo = bendData(row + 1, bendColTwo);
        else
            unitCostBendTwo = 0;
        end
        if (numBends > 2)
            unitCostBendThree = bendData(row + 1, bendColThree);
        else
            unitCostBendThree = 0;
        end
        if (numBends > 3)
            unitCostBendFour = bendData(row + 1, bendColFour);
        else
            unitCostBendFour = 0;
        end
        sumUnitCostBends = unitCostBendOne + unitCostBendTwo...
                         + unitCostBendThree + unitCostBendFour;
        costBends = sumUnitCostBends * numSystems;
        costPump = pumpData(pumpRow, pumpCol) * pumpFlow;
        costTurbine = turbineData(turbRow, turbCol) * turbineFlow;
        
        totalCost = costPipe + costBends + costPump + costTurbine;
        
        gravity = 9.81;
        megawattHours = 120; % megawatt hours
        eOut = megawattHours * 3600000000; % joules
        area = pi * (diameter / 2) ^ 2;
        velocity = turbineFlow / area / numSystems;
        bendLoss1 = bendCoeffOne * ((velocity ^ 2) / (2 * 9.81));
        bendLoss2 = bendCoeffTwo * ((velocity ^ 2) / (2 * 9.81));
        bendLoss3 = bendCoeffThree * ((velocity ^ 2) / (2 * 9.81));
        bendLoss4 = bendCoeffFour * ((velocity ^ 2) / (2 * 9.81));
        effElevation = resElv + (1/2) * depth;
        energyTurbine = eOut / turbineData(1, turbCol);
        flowLoss = friction * length  * (velocity ^ 2) / (2 * diameter * gravity);
        hLoss = bendLoss1 + bendLoss2 + bendLoss3 + bendLoss4 + flowLoss;
        mass = energyTurbine / (gravity * (effElevation - hLoss));
        volume = mass / 1000;
        areaReservoir = volume / depth;
        timeEmpty = (volume / turbineFlow) / 3600; % seconds
        timeFill = (volume / pumpFlow) / 3600; % seconds
        velocity = pumpFlow / area / numSystems;
        bendLoss1 = bendCoeffOne * ((velocity ^ 2) / (2 * 9.81));
        bendLoss2 = bendCoeffTwo * ((velocity ^ 2) / (2 * 9.81));
        bendLoss3 = bendCoeffThree * ((velocity ^ 2) / (2 * 9.81));
        bendLoss4 = bendCoeffFour * ((velocity ^ 2) / (2 * 9.81));
        flowLoss = friction * length * (velocity ^ 2) / (2 * diameter * gravity);
        h2Loss = bendLoss1 + bendLoss2 + bendLoss3 + bendLoss4 + flowLoss;
        eIn = ((mass * gravity * effElevation) + (mass * gravity * h2Loss)) / pumpData(1, pumpCol);
        eIn = eIn / 3600000000;
        totalHPump = effElevation + hLoss;
        totalHTurbine = effElevation + h2Loss;
        
        
        temp1 = optimizationFactor;
        optimizationFactor = (120 / eIn) / totalCost;
    
        if ((optimizationFactor > temp1) && eIn > 0 && hLoss < 120 ...
            && h2Loss < 120 && pumpData(pumpRow, columnsPumps) > totalHPump...
                && turbineData(turbRow, columnsTurbines) > totalHTurbine &&...
                timeEmpty < 12 && timeFill < 12)
        zoneData(n, 1) = totalCost;
        zoneData(n, 2) = numSystems;
        zoneData(n, 3) = length;
        zoneData(n, 4) = friction;
        zoneData(n, 5) = diameter;
        zoneData(n, 6) = bendCoeffOne;
        zoneData(n, 7) = bendCoeffTwo;
        zoneData(n, 8) = bendCoeffThree;
        zoneData(n, 9) = bendCoeffFour;
        zoneData(n, 10) = depth;
        zoneData(n, 11) = turbineFlow;
        zoneData(n, 12) = pumpFlow;
        zoneData(n, 13) = pumpData(pumpRow, columnsPumps);
        zoneData(n, 14) = pumpData(1, pumpCol);
        zoneData(n, 15) = turbineData(turbRow, columnsTurbines);
        zoneData(n, 16) = turbineData(1, turbCol);
        zoneData(n, 17) = eIn;
        
        fprintf(dataFile, ['%10.2f       %2d    %8.2f      %.2f       %.2f',...
                '    %.2f    %.2f    %.2f    %.2f      %5.2f %6.2f  %6.2f  %6.2f  %6.2f        %8.2f    %f    %f\n'],... 
                totalCost, numSystems, length, friction, diameter, bendCoeffOne,...
                bendCoeffTwo, bendCoeffThree, bendCoeffFour, depth,...
                pumpData(pumpRow, columnsPumps), pumpData(1, pumpCol),...
                turbineData(turbRow, columnsTurbines), turbineData(1, turbCol),...
                eIn, optimizationFactor, (120 / eIn));
        n = n + 1;
        else
            optimizationFactor = temp1;
            n = n + 1; 
        end
        end
        end
        end
        end
        end
        end
        end
    end
    
end
end
fprintf('Done!!!\n');
fclose('dataFile');