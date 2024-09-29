function [trial_on, reward_on, teleport_on, grp] = util_process_data(log)
    trial_on = find(log(:, 1) == 1);
    reward_on = find(log(:, 3) == 1);
    teleport_on = find(diff(log(:, 1)) == 2);
    grp = ones(size(trial_on));
    for i = 1:size(teleport_on, 1)
        grp(find(trial_on <= teleport_on(i), 1, 'last')) = log(teleport_on(i), 1)+1;
    end
end