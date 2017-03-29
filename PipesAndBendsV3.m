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

%% Analyze size of data files
[rowsPipes, columnsPipes] = size(pipeData);
[rowsBends, columnsBends] = size(bendData);

%% Open file for writing data
dataFile = fopen('PipeData.txt', 'w');
fprintf(dataFile, 'Pipe and Bends\n');
fprintf(dataFile, ['  Cost ($)  Systems  Length (m)  Friction  Diam. (m)',...
        '  Bend 1  Bend 2  Bend 3  Bend 4   Head Loss (m)\n']);

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
rate = input('Enter flow rate in m^3/s: ');
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

%% Analysis
zoneData = zeros(rowsPipes - 1, 10);
n = 1;
for numSystems = 1:20
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
        area = ((diameter / 2) ^ 2) * pi;
        velocity = rate / area / numSystems;
        bendLoss1 = bendCoeffOne * ((velocity ^ 2) / (2 * 9.81));
        bendLoss2 = bendCoeffTwo * ((velocity ^ 2) / (2 * 9.81));
        bendLoss3 = bendCoeffThree * ((velocity ^ 2) / (2 * 9.81));
        bendLoss4 = bendCoeffFour * ((velocity ^ 2) / (2 * 9.81));
        flowLoss = friction * length  * (velocity ^ 2) / (2 * diameter * 9.81);
        hLoss = bendLoss1 + bendLoss2 + bendLoss3 + bendLoss4 + flowLoss;
        zoneData(n, 1) = totalCost;
        zoneData(n, 2) = numSystems;
        zoneData(n, 3) = length;
        zoneData(n, 4) = friction;
        zoneData(n, 5) = diameter;
        zoneData(n, 6) = bendCoeffOne;
        zoneData(n, 7) = bendCoeffTwo;
        zoneData(n, 8) = bendCoeffThree;
        zoneData(n, 9) = bendCoeffFour;
        zoneData(n, 10) = hLoss;
        
        fprintf(dataFile, ['%10.2f       %2d    %8.2f      %.2f       %.2f',...
                '    %.2f    %.2f    %.2f    %.2f  %14.2f\n'],... 
                totalCost, numSystems, length, friction, diameter, bendCoeffOne,...
                bendCoeffTwo, bendCoeffThree, bendCoeffFour, hLoss);
        n = n + 1;
    end
end
end