clear
% Game of Life's size (N x N) - field
N = 50;

% Number of iterations
Iterations = 1000;

% Chose boundaries:
% 1. surrounding cells are "dead"-cells
% 2. surrounding cells are "living"-cells
% 3. field is a sphere: what exits left, enters on the right

rule = 1;
%rule = 2;
%rule = 3;

field = randi([0, 1], [N, N]);

field = R_pentomino(N);

field = add_boundaries(field, rule, N);

figure; hAxes = gca;
imagesc(hAxes, field(2:end-1,2:end-1));
colormap(hAxes , [1 1 1; 0 1 0]);
hold on
pause(0.5)

for i=1:Iterations
    field = next_iteration(field, N);
    
    % plot
    imagesc(hAxes, field(2:end-1,2:end-1));
    colormap(hAxes , [1 1 1; 0 1 0]);
    hold on
    
    pause(0.1)
end




function field = next_iteration(field, N)
    new_field = zeros(N+2,N+2);
    for i=2:N
        for j=2:N
            count = 0;
            % check number living neighbour cells
            % add above the cell
            count = count + sum(field(i-1,j-1:j+1));
            % add below the cell
            count = count + sum(field(i+1,j-1:j+1));
            % add left side
            count = count + field(i,j-1);
            %add right side
            count = count + field(i,j+1);
            
            % take aktion based on living or dead cell
            if field(i,j) == 1
                % living cell
                % if less than to living neighbours: cell dies
                if count < 2
                    new_field(i,j) = 0;
                elseif count <= 3
                    % if 2 or 3 living neighbour cells: cell stays alive
                    new_field(i,j) = 1;
                else
                    % if more than 3 living neighbour cells: cell dies due
                    % to overpopulatoin
                    new_field(i,j) = 0;
                end
            else
                % dead cell
                if count == 3
                    % dead cell with 3 living neighbours comes alive
                    new_field(i,j) = 1;
                else
                    % otherwise stays dead
                    new_field(i,j) = 0;
                end
            end
        end
    end
    field;
    new_field;
    field = new_field;
    return
end


function field = add_boundaries(field, rule, N)
    % add boundaries, based on rule:
    if rule == 1
        % add zeros around the field
        top_bottom = zeros(1, N+2);
        sides = zeros(N, 1);

        field = [ top_bottom;
            sides field sides;
            top_bottom];

    elseif rule == 2
        % add ones around the field
        top_bottom = ones(1, N+2);
        sides = ones(N, 1);

        field = [ top_bottom;
            sides field sides;
            top_bottom];

    elseif rule == 3
        % add zeros around the field
        top_bottom = zeros(1, N+2);
        sides = zeros(N, 1);

        field = [ top_bottom;
            sides field sides;
            top_bottom];
        % repalce zeros with actual values
        field = update_fieldBoundaries(field);
    else
        field = 0;
    end
    return
end


function field = update_fieldBoundaries(field)
    % left side
    field(1,1) = field(end-1,end-1);
    field(end,1) = field(end-1,2);
    field(2:end-1,1) = field(2:end-1,end-1);

    % right side
    field(1,end) = field(end-1,2);
    field(end,end) = field(2,2);
    field(2:end-1,end) = field(2:end-1,2);

    % top
    field(1,2:end-1) = field(end-1,2:end-1);

    % bottom
    field(end,2:end-1) = field(2,2:end-1);
    return
end

function field = R_pentomino(N)
    if N < 10
        N = 10;
    end
    field = zeros(N, N);
    mid = round(N/2);
    field(mid,mid) = 1;
    field(mid-1,mid-1:mid) = 1;
    field(mid-2,mid:mid+1) = 1;
    return
end
