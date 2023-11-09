import subprocess
import platform
import os

def cdHere():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
cdHere()

pf = platform.system()
if pf == 'Windows':
    subprocess.run("cd tools & python urlToDir.py", shell=True, encoding="shift-jis")
if pf == 'Darwin':
  	subprocess.run("cd tools ; python urlToDir.py", shell=True)
if pf == 'Linux':
	  subprocess.run("cd tools ; python3 urlToDir.py", shell=True)
