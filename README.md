# Demo Github Actions

This demo shows how to use github actions to parallelize a job. The [brrrt.sh](brrrt.sh) script is intended to be run locally and fires of a number of curl requests. The script takes a new line separated text file of ip addresses and groups them together by the `number_pids_per_container` variable to send off to github actions as json payloads. The github actions file [werk.yaml](.github/workflows/werk.yaml) listens for the curls and passes the payloads to the [work.sh](work.sh) script, after installing `whois`. The [work.sh](work.sh) script takes a comma separate list of ip addresses as the first argument and runs a `whois` command on each ip, as a background process. The background processes are non-blocking, so a `sleep 10` is added to make sure all processes finish. The output of each background process is saved in log files, zipped up, and saved as an artifact in the github actions job.

***Github Actions UI:*** https://github.com/mathew-fleisch/demo-actions/actions

***Example Log:*** https://github.com/mathew-fleisch/demo-actions/runs/827145211?check_suite_focus=true

Must create personal access token, and export it as environment variable: `GIT_TOKEN`
https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token


```
# Usage
export GIT_TOKEN=INSERT_PERSONAL_ACCESS_TOKEN
export GIT_OWNER=mathew-fleisch
export GIT_REPOSITORY=demo-actions
export GIT_ACTION=do-werk
./brrrt.sh ips_small.txt

# Example output
Action: do-werk
Send: { "ips": "8.8.8.8,8.8.4.4" }
To: https://api.github.com/repos/mathew-fleisch/demo-actions/dispatches
--------------------------------------
Action: do-werk
Send: { "ips": "1.1.1.1,1.0.0.1" }
To: https://api.github.com/repos/mathew-fleisch/demo-actions/dispatches
...
```