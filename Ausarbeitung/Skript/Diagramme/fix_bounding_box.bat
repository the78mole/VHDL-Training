@echo off
cls
for /R 04_EPS\ %%f in (*.*) do (
  echo %%f
  REM epstool --copy --bbox 04_EPS\%%f 05_EPS_fixed\
)
