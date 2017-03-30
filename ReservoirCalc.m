% Activity X.X.X: Project 2
% File:    ReservoirCalc.m
% Date:    03/30/2017
% By:      Jacob Bartkiewicz
%          jbartkie
%          Andrew Meyer
%          meyer256
%          Haley Nelson
%          nelso310
%          Mark Pollard
%          mpollar
% Section: 04
% Team:    65
%
% ELECTRONIC SIGNATURE
% Jacob Bartkiewicz
% Andrew Meyer
% Haley Nelson
% Mark Pollard
%
% The electronic signatures above indicate that the program
% submitted for evaluation is the combined effort of all
% team members and that each member of the team was an
% equal participant in its creation. In addition, each
% member of the team has a general understanding of
% all aspects of the program development and execution.
% 
% A BRIEF DESCRIPTION OF WHAT THE PROGRAM OR FUNCTION DOES
% Calculates the cost, area, and perimeter of water reservoir
% for a given mass and depth, based on the maximum area and perimeter
% for the given site, and the prices listed in a file.

function resData = ReservoirCalc(resDepth, waterMass, maxArea,...
                                 maxPerimeter, wallCostFile)
    
    % Calculate the area needed to store waterMass at a depth of resDepth
    resArea = waterMass / (1000 * resDepth);
    
    % Calculate the perimeter required to store said water, scaled from
    % maxPerimeter and maxArea
    perimeter = maxPerimeter * sqrt(resArea / maxArea);
    
    % Load the wall pricings from wallCostFile
    depthCosts = load(wallCostFile);
    
    % Find the entry for the current reservoir depth and calculate costs
    numDepths = length(depthCosts);
    for i = 1:numDepths
        if (abs(resDepth - depthCosts(i, 1)) < 0.001)
            cost = perimeter * depthCosts(i, 2);
        end
    end
    
    % Return results
    resData = [cost, resArea, perimeter];
end