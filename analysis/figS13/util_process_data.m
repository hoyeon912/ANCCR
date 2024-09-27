function [st, ed, log, offset] = util_process_data(eventlog_pre, eventlog_post)

st_pre = find(eventlog_pre(:, 1) == 1);
ed_pre = find(eventlog_pre(:, 3) == 1); 
offset = size(eventlog_pre, 1);

st_post = find(eventlog_post(:, 1) == 1) + offset;
ed_post = find(eventlog_post(:, 3) == 1) + offset;
% n_post = size(eventlog_post, 1);

st = [st_pre; st_post];
ed = [ed_pre; ed_post];
log = [eventlog_pre; eventlog_post];
end