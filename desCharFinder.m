% Design Characterization Script
% This script examines all fully-symmetric, flip-symmetric, and
% asymmetric designs within a design space for the presence of key
% characteristics associated with symmetry
function charBools = desCharFinder(CA,NC,sel,sidenum)
    % Initialize values
    charBools = [0,0,0];
    
    %%% Boolean Characteristic 1: Presence of Long Diagonals
    charBools(1) = longDiagChecker(CA,NC,sel,sidenum);
    
    %%% Boolean Characteristic 2: Presence of Pivot Point(s)
    charBools(2) = pivotPointChecker(NC,CA,sidenum);
    
    %%% Boolean Characteristic 3: Sufficient Presence of Diagonals (Partial
    %%% Collapsibility Heuristic)
    charBools(3) = partCollapseCheck(sidenum,CA,NC,sel);
end

% FUNCTION FOR CHARACTERISTIC #1 (LONG DIAGONALS)
function ldBool = longDiagChecker(CA,NC,sel,sidenum)
    % Initialize boolean
    ldBool = 0;

    % Loop through each member in the current design
    for i = 1:size(CA,1)
        % Finding member length, angle from nodal coordinates
        x1 = NC(CA(i,1),1); x2 = NC(CA(i,2),1);
        y1 = NC(CA(i,1),2); y2 = NC(CA(i,2),2);
        L = sqrt(((x2-x1)^2)+((y2-y1)^2));
        angle = abs(acosd((x2-x1)./L));
        
        shortest45Diag = sqrt(2)*(sel/(sidenum-1));
        if (angle ~= 0) && (angle ~= 90) && (angle ~= 180)
            if abs(L) > shortest45Diag
                ldBool = 1;
            end
        end
    end
end

% FUNCTION FOR CHARACTERISTIC #2 (PIVOT POINTS)
function ppBool = pivotPointChecker(NC,CA,sidenum)
    % Initialize Boolean
    ppBool = 0;

    % Loop through each horizontal row of nodes
    [N,~] = histcounts(CA,size(NC,1));
    for j = 1:1:sidenum
        hrow = j:sidenum:((sidenum^2)-sidenum+j);
        connRow = N(hrow); numPivots = 0;
        % For each node in the row:
        for q = 1:1:length(connRow)
            % Isolate all elements starting/ending at each node
            id = connRow(q);
            indione = CA(:,1) == id; inditwo = CA(:,2) == id;
            mCAone = CA(indione,:); mCAtwo = CA(inditwo,:);
            mCA = ...
             [setdiff(mCAone,mCAtwo,'rows');setdiff(mCAtwo,mCAone,'rows')];
            % Identify angles of all elements, relative to the current node
            x1 = NC(mCA(:,1),1); x2 = NC(mCA(:,2),1);
            y1 = NC(mCA(:,1),2); y2 = NC(mCA(:,2),2);
            L = sqrt(((x2-x1).^2)+((y2-y1).^2));
            angles = acos((x2-x1)./L);
            % Determine how many members have angles [0,pi] and [-pi,0]
            posangs = 0; negangs = 0;
            for o = 1:1:length(angles)
                if y1(o) > y2(o)
                    angles(o) = angles(o) - pi;
                end
                if (angles(o) < 0) && (angles(o) > -pi)
                    negangs = negangs + 1;
                elseif (angles(o) > 0) && (angles(o) < pi)
                    posangs = posangs + 1;
                end
            end
            % Tally up potential pivot point nodes in row
            if (posangs ~= 0) && (negangs ~= 0)
                numPivots = numPivots + 1;
            end
        end
        % If there is exactly one pivot point node in the row: bool=1
        if numPivots == 1
            ppBool = 1;
        end
    end
    % Loop through each vertical column of nodes
    for k = 1:sidenum:((sidenum^2)-sidenum+1)
        vcol = k:1:(k+sidenum-1);
        connRow = N(vcol); numPivots = 0;
        % For each node in the col:
        for q = 1:1:length(connRow)
            % Isolate all elements starting/ending at each node
            id = connRow(q);
            indione = CA(:,1) == id; inditwo = CA(:,2) == id;
            mCAone = CA(indione,:); mCAtwo = CA(inditwo,:);
            mCA = ...
             [setdiff(mCAone,mCAtwo,'rows');setdiff(mCAtwo,mCAone,'rows')];
            % Identify angles of all elements, relative to the current node
            x1 = NC(mCA(:,1),1); x2 = NC(mCA(:,2),1);
            y1 = NC(mCA(:,1),2); y2 = NC(mCA(:,2),2);
            L = sqrt(((x2-x1).^2)+((y2-y1).^2));
            angles = acos((x2-x1)./L);
            % Determine how many members have angles [0,pi] and [-pi,0]
            posangs = 0; negangs = 0;
            for o = 1:1:length(angles)
                if y1(o) > y2(o)
                    angles(o) = angles(o) - pi;
                end
                if (angles(o) < 0) && (angles(o) > -pi)
                    negangs = negangs + 1;
                elseif (angles(o) > 0) && (angles(o) < pi)
                    posangs = posangs + 1;
                end
            end
            % Tally up potential pivot point nodes in row
            if (posangs ~= 0) && (negangs ~= 0)
                numPivots = numPivots + 1;
            end
        end
        % If there is exactly one pivot point node in the col: bool=1
        if numPivots == 1
            ppBool = 1;
        end
    end
end

% FUNCTION FOR CHARACTERISTIC #3 (PARTIAL COLLAPSIBILITY)
function pcBool = partCollapseCheck(sidenum,CA,NC,sel)
    % Initialize variables
    ND = NC./sel;

    % Iterate through slices in x-direction
    xyblocker = 0;
    for ix = 1:1:(sidenum-1)
        % Identify nodes on the surface of the current slice
        lowerbound = (ix-1)*(1/(sidenum-1));
        upperbound = (ix)*(1/(sidenum-1));
        nodeslower = find(ND(:,1) == lowerbound); 
        nodesupper = find(ND(:,1) == upperbound); 
        allnodes = [nodeslower;nodesupper];

        % Isolate all elements connecting to/from all these nodes
        mCAone = CA(ismember(CA(:,1),allnodes),:);
        mCAtwo = CA(ismember(CA(:,2),allnodes),:);
        mCA = intersect(mCAone,mCAtwo,'rows');

        % Also include diagonal elements starting on the slice but ending
        % elsewhere on the grid
        for ib = 1:1:size(nodeslower,1) % For nodeslower
            tCAone = CA(ismember(CA(:,1),nodeslower(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),1) >= ((2/(sidenum-1))+ND(ib,1))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodeslower(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),1) >= ((2/(sidenum-1))+ND(ib,1))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end
        for ib = 1:1:size(nodesupper,1) % For nodesupper
            tCAone = CA(ismember(CA(:,1),nodesupper(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),1) <= (ND(ib,1)-(2/(sidenum-1)))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodesupper(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),1) <= (ND(ib,1)-(2/(sidenum-1)))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end

        % Isolate and test diagonal elements for feasibility
        for j = 1:1:size(mCA,1)
            x1 = NC(mCA(j,1),1); x2 = NC(mCA(j,2),1);
            y1 = NC(mCA(j,1),2); y2 = NC(mCA(j,2),2);
            if (abs(x2-x1) > 0) && (abs(y2-y1) > 0)
                xyblocker = xyblocker + 1;
            end
        end
    end

    % Iterate through slices in y-direction
    yxblocker = 0;
    for iy = 1:1:(sidenum-1)
        % Identify nodes on the surface of the current slice
        lowerbound = (iy-1)*(1/(sidenum-1));
        upperbound = (iy)*(1/(sidenum-1));
        nodeslower = find(ND(:,2) == lowerbound); 
        nodesupper = find(ND(:,2) == upperbound); 
        allnodes = [nodeslower;nodesupper];

        % Isolate all elements connecting to/from all these nodes
        mCAone = CA(ismember(CA(:,1),allnodes),:);
        mCAtwo = CA(ismember(CA(:,2),allnodes),:);
        mCA = intersect(mCAone,mCAtwo,'rows');

        % Also include diagonal elements starting on the slice but ending
        % elsewhere on the grid
        for ib = 1:1:size(nodeslower,1) % For nodeslower
            tCAone = CA(ismember(CA(:,1),nodeslower(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),2) >= ((2/(sidenum-1))+ND(ib,2))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodeslower(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),2) >= ((2/(sidenum-1))+ND(ib,2))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end
        for ib = 1:1:size(nodesupper,1) % For nodesupper
            tCAone = CA(ismember(CA(:,1),nodesupper(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),2) <= (ND(ib,2)-(2/(sidenum-1)))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodesupper(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),2) <= (ND(ib,2)-(2/(sidenum-1)))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end

        % Isolate and test diagonal elements for feasibility
        for j = 1:1:size(mCA,1)
            x1 = NC(mCA(j,1),1); x2 = NC(mCA(j,2),1);
            y1 = NC(mCA(j,1),2); y2 = NC(mCA(j,2),2);
            if (abs(x2-x1) > 0) && (abs(y2-y1) > 0)
                yxblocker = yxblocker + 1;
            end
        end
    end
    
    % Check for characteristic satisfaction
    if (xyblocker >= ((sidenum-1)^2)) && (yxblocker >= ((sidenum-1)^2))
        pcBool = 1;
    else
        pcBool = 0;
    end
end

