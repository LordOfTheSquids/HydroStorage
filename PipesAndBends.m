% Header

% Clear workspace and command window
clear, clc

% Define constants
zone1PipeLen = 67.08204;  % meters
zone2PipeLen = 187.73502; % meters
zone3PipeLen = 114.5548;  % meters

% Accept file names from user
%{
pipeFile = input('Input pipe catalog file name: ', 's');
pipeData = load(pipeFile);
bendFile = input('Input bend catalog file name: ', 's');
bendData = load(bendFile);
%}

pipeData = load('Pipes.csv');
bendData = load('BendsAndFittings.csv');

% Accept number of pump/turbine/pipe systems from user
numSystems = input('Input number of pump/turbine/pipe systems: ');

% Analyze size of data files
[rowsPipes, columnsPipes] = size(pipeData);
[rowsBends, columnsBends] = size(bendData);

% Zone 1 Analysis
zone1Data = zeros(rowsPipes - 1, 4);
bendCol = 2;
bendLoss = bendData(2, bendCol);
n = 1;
for col = 1:(columnsPipes - 1)
    for row = 2:rowsPipes
        friction = pipeData(1, col);
        diameter = pipeData(row, columnsPipes);
        unitCostPipe = pipeData(row, col);
        unitCostBend = bendData(row + 1, bendCol);
        costPipe = zone1PipeLen * unitCostPipe * numSystems;
        costBends = unitCostBend * numSystems;
        totalCost = costPipe + costBends;
        zone1Data(n, 1) = totalCost;
        zone1Data(n, 2) = friction;
        zone1Data(n, 3) = diameter;
        zone1Data(n, 4) = bendLoss;
        n = n + 1;
    end
end

% Zone 2 Analysis
zone2Data = zeros(rowsPipes - 1, 4);
bendCol = 4;
bendLoss = bendData(2, bendCol);
n = 1;
for col = 1:(columnsPipes - 1)
    for row = 2:rowsPipes
        friction = pipeData(1, col);
        diameter = pipeData(row, columnsPipes);
        unitCostPipe = pipeData(row, col);
        unitCostBend = bendData(row + 1, bendCol);
        costPipe = zone2PipeLen * unitCostPipe * numSystems;
        costBends = unitCostBend * numSystems;
        totalCost = costPipe + costBends;
        zone2Data(n, 1) = totalCost;
        zone2Data(n, 2) = friction;
        zone2Data(n, 3) = diameter;
        zone2Data(n, 4) = bendLoss;
        n = n + 1;
    end
end

% Zone 3 Analysis
zone3Data = zeros(rowsPipes - 1, 4);
bendColOne = 1;
bendColTwo = 3;
bendLossOne = bendData(2, bendColOne);
bendLossTwo = bendData(2, bendColTwo);
n = 1;
for col = 1:(columnsPipes - 1)
    for row = 2:rowsPipes
        friction = pipeData(1, col);
        diameter = pipeData(row, columnsPipes);
        unitCostPipe = pipeData(row, col);
        unitCostBendOne = bendData(row + 1, bendColOne);
        unitCostBendTwo = bendData(row + 1, bendColTwo);
        costPipe = zone3PipeLen * unitCostPipe * numSystems;
        costBends = (unitCostBend + unitCostBendTwo) * numSystems;
        totalCost = costPipe + costBends;
        zone3Data(n, 1) = totalCost;
        zone3Data(n, 2) = friction;
        zone3Data(n, 3) = diameter;
        zone3Data(n, 4) = bendLossOne;
        zone3Data(n, 5) = bendLossTwo;
        n = n + 1;
    end
end