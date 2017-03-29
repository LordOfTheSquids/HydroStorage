function [ eIn ] = totalFunc( length, diameter, friction, depth, ...
        resElv, bendCoeffOne, bendCoeffTwo, bendCoeffThree, bendCoeffFour,...
        epsilonT, epsilonP, turbineFlow, pumpFlow, )
    eOut = megawattHours * 3600000000; % joules
    area = pi * (diameter / 2) ^ 2;
    velocity = turbineFlow / area / numSystems;
    bendLoss1 = bendCoeffOne * ((velocity ^ 2) / (2 * 9.81));
    bendLoss2 = bendCoeffTwo * ((velocity ^ 2) / (2 * 9.81));
    bendLoss3 = bendCoeffThree * ((velocity ^ 2) / (2 * 9.81));
    bendLoss4 = bendCoeffFour * ((velocity ^ 2) / (2 * 9.81));
    effElevation = resElv + (1/2) * depth;
    energyTurbine = eOut / epsilonT;
    flowLoss = friction * length  * (velocity ^ 2) / (2 * diameter * gravity);
    hLoss = bendLoss1 + bendLoss2 + bendLoss3 + bendLoss4 + flowLoss;
    mass = energyTurbine / (gravity * (effElevation - hLoss));
    fprintf('Mass: %.2f kg\n', mass);
    volume = mass / 1000;
    areaReservoir = volume / depth;
    timeEmpty = (volume / turbineFlow) / 3600; % seconds
    timeFill = (volume / pumpFlow) / 3600; % seconds
    velocity = pumpFlow / area;
    bendLoss1 = bendCoeffOne * ((velocity ^ 2) / (2 * 9.81));
    bendLoss2 = bendCoeffTwo * ((velocity ^ 2) / (2 * 9.81));
    bendLoss3 = bendCoeffThree * ((velocity ^ 2) / (2 * 9.81));
    bendLoss4 = bendCoeffFour * ((velocity ^ 2) / (2 * 9.81));
    flowLoss = friction * length * (velocity ^ 2) / (2 * diameter * gravity);
    hLoss = bendLoss1 + bendLoss2 + bendLoss3 + bendLoss4 + flowLoss;
    eIn = ((mass * gravity * effElevation) + (mass * gravity * hLoss)) / epsilonP;
    eInMegaWattHours = eIn / 3600000000;
    fprintf('Energy in = %.2f Megawatt Hours\n', eInMegaWattHours);
    



end

