entry = input('Manual Entry (Y or N)?: ');
while (entry ~= Y || entry ~= N)
    fprintf('Invalid Entry.\n');
    entry = input('Manual Entry (Y or N)?: ');
end
if (entry == Y)
else
fprintf('Please select mode.\n');
fprintf('Mode 1: Cost Effective Analysis\n');
fprintf('Mode 2: Minimum Efficiency\n');
fprintf('Mode 3: Maximum Cost\n');
fprintf('Mode 4: Maximum Energy Input\n');
mode = input('MODE: ');
while (mode ~= 1 || mode ~= 2 || mode ~= 3 || mode ~= 4)
    fprintf('Invalid Entry.\n');
    mode = input('MODE: ');
end
switch(mode)
    case 1
        fprintf('Cost Effective Analysis Selected.\n');
        site = input('Enter Construction Site #: ');
        while (strcmp(site,'2a') == 0 || site ~= 2 || site ~= 3)
            fprintf('Invalid Entry.\n');
            site = input('Enter Construction Site #: ');
        end
        switch(site)
            case '2a'
                filename = 'Zone2a.csv';
            case 2
                filename = 'Zone2.csv';
            case 3
                filename = 'Zone3.csv';
        end
    case 2
        fprintf('Minimum Efficiency Selected.\n');
        site = input('Enter Construction Site #: ');
        while (strcmp(site,'2a') == 0 || site ~= 2 || site ~= 3)
            fprintf('Invalid Entry.\n');
            site = input('Enter Construction Site #: ');
        end
        switch(site)
            case '2a'
                filename = 'Zone2a.csv';
            case 2
                filename = 'Zone2.csv';
            case 3
                filename = 'Zone3.csv';
        end
    case 3
        fprintf('Maximum Cost Selected.\n');
        site = input('Enter Construction Site #: ');
        while (strcmp(site,'2a') == 0 || site ~= 2 || site ~= 3)
            fprintf('Invalid Entry.\n');
            site = input('Enter Construction Site #: ');
        end
        switch(site)
            case '2a'
                filename = 'Zone2a.csv';
            case 2
                filename = 'Zone2.csv';
            case 3
                filename = 'Zone3.csv';
        end
    case 4
        fprintf('Maximum Energy Input Selected.\n');
        site = input('Enter Construction Site #: ');
        while (strcmp(site,'2a') == 0 || site ~= 2 || site ~= 3)
            fprintf('Invalid Entry.\n');
            site = input('Enter Construction Site #: ');
        end
        switch(site)
            case '2a'
                filename = 'Zone2a.csv';
            case 2
                filename = 'Zone2.csv';
            case 3
                filename = 'Zone3.csv';
        end
end
end

