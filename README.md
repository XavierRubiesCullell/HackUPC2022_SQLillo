# HackUPC2022_SQLete
SQLillo challenge in HackUPC 2022 👩🏻‍💻

Hi, we are @XavierRubiesCullell and @danaecanillas! 👋
In this repo you will find some scripts that define the workers strategies at SQLillo challenge from HackUPC.

Our main strategy consist of searching shortests paths using the BFS algorithm. We have customarized the searching by defining some workers roles:
- Defensor workers: they keep safe the user quarter
- Atacker workers: they go after the opponents
- Silly workers: they paint paths randomly
The number of each set of workers changes in each script, you can consult the strategies directory to see some of them.

If you want to execute a single bot you must run the following line in your terminal:
```console
./runner_rs --run strategies/code.rhai
```
or if you want to run multiple local bots you can run
```console
./runner_rs --run strategies/code1.rhai strategies/code2.rhai strategies/code3.rhai
```
