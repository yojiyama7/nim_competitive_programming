import subprocess
import platform

pf = platform.system()
if pf == 'Windows':
    subprocess.run("cd .. & cd tools & python urlToDir.py", shell=True, encoding="shift-jis")
if pf == 'Darwin':
  	subprocess.run("cd ../tools; python urlToDir.py", shell=True)
if pf == 'Linux':
	print('on Linux')
