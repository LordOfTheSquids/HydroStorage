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
pipeData = load('Pipes.csv');
bendData = load('BendsAndFittings.csv');

%% Analyze size of data files
[rowsPipes, columnsPipes] = size(pipeData);
[rowsBends, columnsBends] = size(bendData);

%% Open file for writing data
dataFile = fopen('PipeData.txt', 'w');
fprintf(dataFile, 'Pipe and Bends\n');
fprintf(dataFile, ['Cost   ($)  Length (m)  Friction  Diam. (m)',...
        '  Bend 1  Bend 2  Bend 3  Bend 4\n']);

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
numSystems = input('Input number of pump/turbine/pipe systems: ');

%% Find appropriate bend angles
if (numBends > 0)
    n = 1;
    while(abs(bendAngleOne - bendData(1, n)) > 0.0005)
        n = n + 1;
    end
    bendColOne = n;
    bendLossOne = bendData(2, n);
else
    bendColOne = 0;
    bendLossOne = 0;
end
if (numBends > 1)
    n = 1;
    while(abs(bendAngleTwo - bendData(1, n)) > 0.0005)
        n = n + 1;
    end
    bendColTwo = n;
    bendLossTwo = bendData(2, n);
else
    bendColTwo = 0;
    bendLossTwo = 0;
end
if (numBends > 2)
    n = 1;
    while(abs(bendAngleThree - bendData(1, n)) > 0.0005)
        n = n + 1;
    end
    bendColThree = n;
    bendLossThree = bendData(2, n);
else
    bendColThree = 0;
    bendLossTwo = 0;
end
if (numBends > 3)
    n = 1;
    while(abs(bendAngleFour - bendData(1, n)) > 0.0005)
        n = n + 1;
    end
    bendColFour = n;
    bendLossFour = bendData(2, n);
else
    bendColFour = 0;
    bendLossFour = 0;
end

%% Analysis
zoneData = zeros(rowsPipes - 1, 7);
n = 1;
for col = 1:(columnsPipes - 1)
    for row = 2:rowsPipes
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
        totalCost = costPipe + costBends;
        zoneData(n, 1) = totalCost;
        zoneData(n, 2) = length;
        zoneData(n, 3) = friction;
        zoneData(n, 4) = diameter;
        zoneData(n, 5) = bendLossOne;
        zoneData(n, 6) = bendLossTwo;
        zoneData(n, 7) = bendLossThree;
        zoneData(n, 8) = bendLossFour;
        fprintf(dataFile, ['%10.2f    %8.2f      %.2f       %.2f',...
                '    %.2f    %.2f    %.2f    %.2f\n'],... 
                totalCost, length, friction, diameter, bendLossOne,...
                bendLossTwo, bendLossThree, bendLossFour);
        n = n + 1;
    end
end