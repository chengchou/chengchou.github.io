# EC2011: Topics in applied econometrics

* Office hour: Thur, 14:00-16:00, AC130, Spring semester.

* You can find course materials on the [Blackboard](https://blackboard.le.ac.uk).

## Data sessions

* This class has five "data sessions".
  These sessions show how to download, clean and run simple econometric analysis of some widely used survey data, includingthe Current Population Survey (CPS), (UK) Quarterly Labour Force Survey (LFS), Panel Study of Income Dynamics (PSID), the National Longitudinal Surveys (NLS).
I mainly use Mincer's earnings equation as an example.

* Download handout, do files, data [here](../pdf/DataSessions.zip).

## Note about changing working directory
You need to the change working directory to run the included `do` files. Taking `Session1_CPS` for example, the directory `Session1_CPS` was saved under 
```
~/Dropbox/Teaching/EC2011/DataSessions/
```
in my computer. So I let Stata set the working directory to be
```sh
cd "~/Dropbox/Teaching/EC2011/DataSessions/Session1_CPS/"
```

If you have saved `Session1_CPS` under `~/somewhere/` directory, you should change the above line to

```sh
cd ~/somewhere/Session1_CPS/
```
