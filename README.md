# Demo Github Actions
https://github.com/mathew-fleisch/demo-actions/actions
Example Log: https://github.com/mathew-fleisch/demo-actions/runs/827145211?check_suite_focus=true

Must create personal access token, and save it as environment variable: GIT_TOKEN
https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token


```
# Usage 
GIT_OWNER=mathew-fleisch \
    GIT_REPOSITORY=demo-actions \
    GIT_ACTION=do-werk \
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